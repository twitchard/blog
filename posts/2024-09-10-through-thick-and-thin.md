---
title: "How thick should your SDK be?"
class: prose
description: "Usually thin is better -- but not always"
quote: "A 'thick' SDK method gives you all the responsibility and none of the control, it is the worst of both worlds."

---
Say you've got a public REST API, that you wrap with SDKs in several languages. Should the SDK be a "thin" wrapper; that is, should the methods in the SDK be 1:1 with endpoints in the underlying API? Or should it be a "thick" wrapper; that is, should the SDK contain methods that have significant logic of their own, potentially calling multiple underlying API methods? 

My take? Thick is typically wrong. Ninety percent of the time, If you're tempted to add an SDK method with any "extra" logic in it, what you should *actually* do is either 

* Put that logic in a new API endpoint. This gives you more control; or,
* Put that logic in the docs. This lets you abdicate some of the responsibility to the user.

g "thick" SDK method gives you all the responsibility and none of the control, it is the worst of both worlds.

## Example

Suppose that you own `api.petinfluencer.io`, a tool where users manage their pet's social media presence, with a public API like

```txt
# This endpoint information about social destinations configured via frontend UI
GET /social_settings 

# Each of these endpoints triggers a post of supplied content to a single social destination
POST /facebook_posts
POST /twitter_posts
POST /linkedin_posts
```

Your users are asking for an easy way to publish the same content to all configured destinations at the same time.

You *could* write a "thick" SDK method that connects the existing APIs:

```javascript
const sliceIntoChunks = ...;
export async function createAllSocialsPost(post) {
  const {enabled_socials} = await lib.getSocialSettings(userId);
  const ret = {
    twitter_results: null,
    facebook_result: null,
    linkedin_result: null,
  }
  if (enabled_socials.includes('twitter')) {
    const tweets = sliceIntoChunks(140, post.text);
    ret.twitter_results = []
    ret.twitter_results.push(
      await lib.create_tweet({
        text: tweets[0]
      })
    )
    for (let i = 1; i < tweets.length; i++) {
      const last_tweet_id = ret.twitter_results[
        ret.twitter_results.length - 1
      ].id
      results.push(await lib.create_tweet({
        userId,
        text: tweets[i],
        in_reply_to: last_tweet_id
      }))
    }
  }
  if (enabled_socials.includes('linkedin')) {
    ret.linkedin_result = await lib.create_linkedin_post({
      content: post.text
    })
  }
  if (enabled_socials.includes('facebook')) {
    ret.facebook_result = await lib.create_facebook_post({
      content: post.text
    })
  }
  return ret
}
```

The problem: if things need to change, there's a library upgrade in the way. 

Say tomorrow your users ask for Reddit support. 

1. You add  `POST /reddit_posts`,  a `reddit` field to the the response of `GET /social_settings`, and the requisite ui. You update the SDK and release a new version.
3. The users go to the web interface and configure their Reddit settings.
4. The users get confused, why aren't posts going to Reddit?
5. They look at their code, see that they are indeed calling `lib.createAllSocialsPost`... what part of "all socials" does your API not understand?
6. They contact support and learn that, oh yes of course, they need to bump the version in the `package.json` and deploy their servers with the new version, how silly of them.

By contrast if `lib.createAllSocialsPost` was a thin wrapper around an endpoint `POST /all_socials_post`, no action whatsoever would be required from the user after you updated that endpoint. Thin for the win.

Alternatively, if `lib.createAllSocialsPost` was not included in the SDK, but its implementation was displayed in the docs for users to paste, it would be significantly easier for the user to find the place in their own codebase where they call `lib.createLinkedinPost` etc. but not `lib.createRedditPost`, and would understand that it is their responsibility to update their code if they want posts to go to Reddit.

Other things to consider:

* **Implementation cost**: Logic that lives in the SDK has to be written (and maintained) once **per language you support**. Logic on the server has to be written once in your backend language.
* **Latency**: Logic that runs in the SDK has to make a round-trip per API call. Logic that runs on your server is already there, on your server.
* **Consistency**: What happens if your "thick" SDK method fails halfway through? Logic on your server, in theory, can write durable records of partial progress to enable recovery. This isn't practical for logic in the SDK.

### A case for thick: fetching more data

I said that "thick" was inappropriate 90% of the time. What's the other 10%?

One exception is helper methods for fetching more data, e.g. pagination or following references. These are *thick* in a sense, but here it's not the case you can just move the logic to the server and things would strictly be better. Moving the logic to the server would mean returning the entire list of results in one chunk, or returning the result with all references pre-expanded, which would defeat the entire point. 
 
## A case for thick: user-defined logic

Another case where I think there's a case for *thick* is when the combination of API calls involves user-defined logic; in other words: when you want the user to be able to pass a callback. 

ln our running example, imagine that the logic to break the text of the post up into 280-character chunks for Twitter wasn't just a hardcoded piece of logic in the SDK or API, but you wanted to let the user describe their own logic for chunking. (A bit contrived -- why not just accept pre-chunked text? -- but bear with me).

If `lib.createAllSocialsPost` needs to take a callback function, putting the logic entirely in a `POST /all_socials_post` endpoint is no longer straightforward. How do you transmit a callback function to a REST API?

You can use a webhook: require the user to host an HTTP server somewhere reachable to you with an endpoint like `/petinfluencer_webhooks`, and send to them `{"type": "twitter_chunk", "text": "..."}`. This is obviously latency-heavy and unergonomic.

Another option is "hosted callbacks" -- allow the user to upload code or some sort of code artifact to your servers, and then trigger the user code on your own servers (in some sort of sandboxed environment) when appropriate. Less latency this way, but still bad ergonomically.

Another option is "serialized callbacks". Here, the user would write code in some agreed-upon language and send it over the wire as a string. If the code is in a general purpose language, you need to sandbox it (in effect this is much like "hosted callbacks", just inline). You can also use a DSL specifically intended for this use case, such as Google's CEL. Also not great, ergonomically.

None of these options are great. So the case for a "thick" SDK that accepts the user's callback is stronger here. (The other strong contender being write it in the docs and let users copy paste.)

## When you'd have to be thick not to go thick: plugging in

Some SDKs go much further than *REST wrapper*. They want to involve the user's database, frontend, or web framework. This is a *thick* SDK, by definition. Libraries like this are legitimate, if not wonderful. When I say "thick is a almost always a mistake" and "SDKs should be thin" I'm not expressing opposition to this kind of SDK -- my position is more like "if you have thick abstractions in your SDK, they had better be abstracting over more than just your own API". 

That said, your (thin) REST wrapper should probably exist as a separate, independent product from your (thick) web framework plugin, as you will probably want to version and release them separately. 

--- 

As my family says at the card table, "cut thin, sure to win". Enjoy your REST!








 
