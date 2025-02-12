---
title: "P(user-hostile trash heap)"
class: prose
description: "Will generative AI will magically make the software industry start doing right by users?"
quote: "just because something amazing is *now possible to build* does not mean that something amazing *will win*"
---

## In the future AI will ____

There's a genre of AI influencer social media post — I call them "in-the-futures". You'll see people make posts like 

- "in the future all the kids will have personalized AI tutors that match their pace and learning style and teach them what they need to know while keeping curiosity alive", or
- "in the future doctors' offices will all have AI assistants to help you interpret your medical results and evaluate potential medical procedures with easy reference to accessible summaries of medical research",
- "in the future, we'll all have personal AI shopping concierges that know our tastes and budget and find us the best products for our needs."

People post these because they are excited about all the new things that are technically possible with generative AI: there are ideas that, three years ago, were so infeasible they would have gotten you laughed out of the startup accelerator — today they are not only technically possible but perhaps even trivial ("just a gpt wrapper, not a real business, no moat").

The quality of this genre of post varies a lot. Some of them are low-effort "I played around for 15 minutes with ChatGPT and now I'm playing 'but with AI' madlibs"; some posts are genuinely thoughtful insights into non-obvious new possibilities. But even the aren't very good *predictive* insights. They fall into a trap of mistaking *technical possibility* for *inevitability.* In reality, just because something amazing is *now possible to build* does not mean that something amazing *will win*.

## Trash wins

Just look around. Most of the software that wins is many times worse for users than the best version of the software it would be technically possible to build. To be blunt, the software that wins tends to be user-hostile trash.

The website [How I Experience Web Today](http://how-i-experience-web-today.com/) makes the point pretty succinctly. You can read [Cory Doctorow on "en$#!^ification"](https://www.wired.com/story/tiktok-platforms-cory-doctorow/), who might be a bit sensationalist but makes criticisms of large tech platforms that I find resonant, as a user.

Examples of "user-hostile trash" that come to top of my mind:

### **Mobile Game Adpocalypse**

I play Words with Friends. What I really want is a Scrabble clone that runs on my phone, gives me reminders when it's my move, and lets me devastate my Mom by spelling "IBEXES" in a well-multiplied position. Instead, network effects oblige me to use a Scrabble clone that regales me with notifications for "daily word play" and other engagement-bait. After every move I am presented with an ad for "Royal Match" that mutes my background Spotify so it can play its obnoxious noises, and it strategically hides the "X" button at exactly the right moment to make me click the ad and go to the app store against my will.

Don't get me wrong, I love the app despite all this and have many fond memories around it, it's just the sad and simple truth that pestering your users with ads and in-app purchase bait is often a winning strategy in the world of mobile games. This has become so normal that people don't really even think to complain.

### **Word Processing C-ad-tastrophe**

I recently learned that Microsoft [stopped shipping/maintaining Wordpad](https://learn.microsoft.com/en-us/windows/whats-new/deprecated-features) on recent versions of Windows. If you won't pay for Word, they want you to use an ad-supported, free version of Word. That is, you have to watch **video ads** before you can do your word processing. No skin off my teeth — I do my writing in Vim or Google Docs — but I felt ashamed on behalf of the industry discovering this and explaining it to my wife's grandmother, who, before her latest computer upgrade, had been using Wordpad to write her annual "Letter to Myself" (basically a technical retrospective on the family Christmas party she hosts every year).

Sadly, this is common practice just about everywhere: make the product worse, benefit by coercing users to paying money or being able to extract more from them via ads.

### **Gen 1 Voice Assistants**

A vivid memory for me is watching [the announcement of the Echo](https://youtu.be/zmhcPKKt7gw?feature=shared) by Amazon in 2014. I ordered it immediately. It completely captured my imagination — I was sure this was the beginning of a new era, the rise of a completely new, more natural way to interact with the world of computing. In the announcement video, a whole family gathers around the Echo in awe at the useful things it can do. The Echo is cast as a beloved household robot -- a digital member of the family. 

Fast forward to today, the novelty of Alexa, Siri, etc. has all worn off. This generation of voice assistants is a disappointment. They are appliances, not computers. Kitchen reminders are useful, yes, but has Alexa successfully taken the role of beloved household robot? Alas, she has made one too many aggressive attempts to sign me up for a free trial of Amazon Music or upsell me to this or that in the course of interacting with her for me to see her as a member of the family[^1]. Amazon's product strategy for "Alexa Skills", oddly, seems to have been to build a platform that helps teenage hobbyists write as many Harry Potter personality quizzes as possible, rather than building the sort of platform that would allow serious software professionals to build interesting new experiences with the voice modality.

Alexa is a great product in many ways (I own like 8 echos), despite her not living up to my inflated dreams. This example should be a reminder that tech companies don't always solve for constraints like "how can we build the voice assistant that outsells the others by offering a superior user experience", but more like "how can we build the voice assistant that helps us earn the most additional revenue from our existing vast retail empire?"

First-world problems, I know. I'm complaining about what's top of mind -- you can learn about the more serious forms of software malfeasance from more serious writers. Subscribe to the EFF mailing list, read your local Hacker News. The point is: look around, Candide, we do not live in the best of all possible softwares.

## AI Trash Will Also Win

From the thought leaders in my social media bubble, you'd get the idea that there are basically only two outcomes when it comes to the future of AI: AI doom or AI paradise. AI could just destroy civilization, yes — but if it doesn't, then we're in a golden age where the best versions of all the coolest generative AI stuff we can imagine will inevitably[^2] enter common use.

In reality, AI software of the future will be subject to all the same cultural and industrial pressures that ordinary software is today. There's no *a priori* reason to expect that it won't just wind up being like a lot of ordinary software is today: user-hostile trash. People don't like to write about this. It's more fun to think about the extremes. But you have to take it seriously.

So here's a more cynical "in-the-future": in the future, we will carry around tremendously intelligent AI in our pockets that can write better than Shakespeare, draw better than Picasso, theorize better than Einstein, etc. and it will direct these talents mainly for the purpose of creating addictive content to keep us clicking as we view ads for GLP-1s, boutique underwear subscriptions, and, most especially, the mobile game "Royal Match"

If somebody does build magnificent AI tutors that helps kids follow the threads of their curiosity, learn at their own pace, with individualized methods that work best for them, these AI tutors won't win; they won't be what actually ends up in the typical classroom. Any AI tutors that win will be those that helps teachers and school administrators most effectively do things the way that they do now: "teach to the test" and encourage kids to solve problems in the precise ways dictated by the over-prescriptive state curricula.

If somebody does build a magnificent AI shopping concierge that helps you conversationally find the best product for your constraints at the right price, this too will not win. It will be deployed nowhere. All the online shopping destinations, if they build AI shopping experiences, will mostly resemble the "search" experience they offer today — that is, they will push you as hard as they can towards results that somebody has bid to give priority (even when there's only a small chance that this is what you are looking for). Results that actually match your need or compare well according to objective criteria will come second, if at all.

## Minimizing P(user-hostile trash)[^3]

So, what's my call to action. How do we fight the trash heap?

I'm just a random software engineer who enjoys writing on the Internet, not any kind of expert authority, so take my scattered thoughts with a grain of salt, but here they are:

### **The time is now.**

Generative AI is a paradigm shift, and it's early days. Right now, there's a lot of enthusiasm within the software culture for trying new things, the industry is willing to tolerate a lot of experimentation. This is temporary. Sooner than you think, people will get used to generative AI, the taste for novelty will fade, and whatever products are successful at that point will set the tone for decades. 

Imagine if, back in the 90s, instead of figuring out how to track ad impressions on the web, somebody really nailed how to do micropayments on the web really well. The world of consumer software would look completely different today.

### **Don't be the problem**

If you're in a position to be picky about your work, exercise the privilege. Try to work on a product that uses AI to make the lives of users better, not to manipulate the user to serve some other business goal. I'm fortunate to work for a company that has explicitly adopted [something like this](https://thehumeinitiative.org/about) as an official ethical principle.

There's a lot of money to be made out there from treating users as a means to an end. This always will be unless we do something drastic like dismantle capitalism (and would that really be the lesser evil?) But you don't need to be involved.

### **Learn to win.**

To fight the trash heap, you have to build software that (a) does right by users and (b) wins. The trash heap rises when people pursue winning by any means: b without a, but if you're the sort of person who cares deeply about doing right by users, the more dangerous failure mode for you is (a) without (b) — building software that's fabulous for users but doesn't really have a prayer of seeing any type of serious adoption. Building great software that can't win is a waste of your time. You'd do more good joining a successful but unprincipled organization and doing your best to nudge them in a good direction, or finding some morally neutral B2B SaaS to write.

### **Reject inevitabilism**

I'll say it again: *technically possibility* doesn't entail *inevitability*. Excise inevitabilism from your language. Instead of "in the future, we'll all have &lt;amazing thing now possible with AI&gt;" — prefer "somebody should build &lt;amazing thing now possible with AI&gt;". 

Excise it from your worldview too. Never decide against building something just because you assume somebody else inevitably will. Never find an amazing community or organization with a great vision and decide against getting involved just because you assume they'll succeed anyway. Things don't happen because they are inevitable, they happen because somebody makes them happen.

### **Supplant trash, reset norms**

Sadly, people have grown to tolerate being mistreated by the software they use. The software industry has grown bones around extractive business models that treat users as a means to an end.

Generative AI can change things and reset norms, especially where it *completely supplants existing ways of working with software.*

Things like [Replit Agent](https://blog.replit.com/introducing-replit-agent) or [val.towns "Townie"](https://blog.val.town/blog/townie/) are good examples. The idea is: instead of using software that somebody else has designed for you, regular folks should be able to just design their own software by describing it to the AI. Technically viable? Maybe, maybe not. But if this sort of thing makes it big, it will certainly reset norms and put the user at the center of the universe.

Things like Anthropic's [computer use](https://www.anthropic.com/news/3-5-models-and-computer-use) or OpenAI's [operator](https://openai.com/index/introducing-operator/) are also supplantive. They let you take advantage of existing software systems, but free you from the need to actually interact with them. So say, if some website decides it wants to make me you [navigate a labyrinth](https://arstechnica.com/tech-policy/2023/06/ftc-sues-amazon-over-4-page-6-click-15-option-prime-cancellation-process/) in order to unsubscribe, this sucks if you have to navigate the labyrinth yourself, but this is mostly moot if you're in the habit of having an AI agent do this sort of thing.

I work in [conversational voice](https://www.hume.ai/products) AI. Voice AI isn't quite supplantive — I believe you could (and should!!) add a voice interface on alongside basically any piece of existing software. But I do suspect Voice AI will have a tendency to reset norms. People have developed very low standards for traditional web software and mobile apps. They also presently have low standards for voice, because they're used to "voice command lines" like Alexa/Siri/Google Assistant. I suspect, though, that once the latest generation of voice models (like EVI, that can respond to tone of voice, be interrupted, and express emotively) makes it into consumer software, talking to an AI will feel much more like talking to a human, and so people will naturally begin to expect the same standard of treatment when talking to an AI via voice that they do when talking to a human via voice. That is, I think that there are users who would take it in stride when a web interface puts them through an obnoxious 12-step process to unsubscribe, and assume this is just the way technology is — that would become very angry if a person (or a voice AI) tried to put them through those same steps. Voice AI has the potential to reset norms, too.

## Last remarks

I've complained about a lot of software in this post, "trash heap" etc. But It's only a trash heap compared *what it could and should be.* Trash heap or not, at the end of the day, software has added a vast amount of wealth and convenience to the world and is unquestionably a net force for good. Similarly, I fully expect consumer AI to add tremendous wealth and convenience to the world. P(user-hostile trash heap) isn't a doom scenario, it's just a scenario where the technology fails to live up to the incredible potential that everybody (well, all the technologists in my little social media tech bubble) senses it to have.

P(user-hostile trash heap) is not as important as P(doom). High-stakes AI problems, e.g.  alignment, the threat of deepfakes eroding our ability to distinguish fact and fiction, the risk of giving bad actors access to tools of mass destruction, automation-driven unemployment, copyright questions — all these deserve to be taken seriously. But what can you do about it? Maybe something if you're a big shot at a major AI lab, or an AI safety researcher, or some kind of regulator. But if you're a rank-and-file person who works in software — well, you can vote with your dollars, perhaps — favor whatever AI lab seems to have the best story around AI safety, and try and persuade others to do the same, but this isn't really much of a lever to pull. I fear that if the only kind of "AI ethics" people talk about is high-stakes AI ethics and P(doom) this threatens to alienate people. It turns AI ethics into a thought experiment and political posturing, instead of what it should be: a practical tool that you can use in order to align your actions with your values.

So I hope that the industry can start talking more about small-stakes AI ethics. What does it mean to build AI software that does right by users? How does the industry need to change so that building this type of software has a strong path to success? What developing areas of technology are most promising in terms of enabling better industry incentives and more ethical business models? Even if you vehemently disagree with absolutely everything I've posted in my little screed here, I hope that you will take to social media and roast me, because at least that will mean that more people in the AI social media tech bubble are talking about these things, and from my perspective, that can really only be good.


[^1]: The touchscreen Alexas also make it way too easy for my toddler to order $50 worth of sugar-free strawberry syrup, probably the most useless liquid known to man. 

[^2]: For example, Dario Amodei, CEO of Anthropic, writes in his essay["Machines of Loving Grace"](https://darioamodei.com/machines-of-loving-grace)

> The basic development of AI technology and many (not all) of its benefits seems inevitable (unless the risks derail everything) and is fundamentally driven by powerful market forces. 

His essay is about broader themes than just consumer software; but I think the state of consumer software today is a pretty strong argument that factors like power dynamics and industrial culture can hold a technology back from its potential in a significant way over the long term. Very far from all the benefits are inevitable.

[^3]: In case you're not familiar, ["P(doom)"](https://en.wikipedia.org/wiki/P(doom)) is AI jargon for the probability that AI will destroy civilization. If failing to adequately house train my Yorkie mix has taught me anything, it's that you need not limit your imagination when it comes to considering things that `P()` might surround. Hence, `P(user-hostile trash heap)`.
