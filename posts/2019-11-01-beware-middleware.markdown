---
title: "Beware Middleware"
class: prose
description: Richard's Software Blog
quote: It's like we threw out everything we learned in model/controller land about trying to operate on constrained data, and just decided that, before the router, it needs to be HTTP requests everywhere!
---

*"Give a small boy a hammer, and he will find that everything he encounters needs pounding." - Abraham Kaplan*

<img src="../images/dropCapW.png" alt="W" class="dropCap"/>hen you're writing an HTTP API, you generally describe two sorts of behavior:

  - Behavior that applies to specific routes.
  - Behavior that applies to all, or many routes.

## A good idea: controllers and models

In applications I’ve seen, behavior that applies to a specific route is usually divided between a  "controller" and one or more "models". The controller, ideally, is "skinny" and doesn't do much work itself. Its task is to translate the action described by the request from the "language" of HTTP into the "language" of the models.

Why is separation into "model" and "controller" a good idea? Because it's easier to reason about constrained data than unconstrained data.

The classic example of this is the stages of a compiler, so let’s explore that analogy a little bit. The first two stages of a simple compiler are the lexer and the parser. The lexer takes completely unconstrained data -- streams of bytes -- and emits known tokens, like `QUOTATION_MARK` or `LEFT_PAREN` or `LITERAL "foo"`, and parsing takes this stream of tokens and produces a syntax tree. Translating a syntax tree representing an if statement into bytecode is straightforwardish. Translating an arbitrary stream of bytes representing an if statement directly into bytecode is... not.

HTTP requests, in this analogy, are like unconstrained streams of bytes. They have some structure, but their bodies can contain arbitrary bytes (that encode arbitrary JSON) and their headers can be arbitrary strings. You don't want to express your business logic in terms of operations on arbitrary requests. It is much more natural to express it in terms of "Accounts" and "Posts" or whatever your domain objects are. So the job of your controller, as I see it, is similar to a lexer/parser. Its job is to take an unconstrained data structure describing an action, and translate this into a more constrained form (e.g. "a call to the .update method on the account object, with a record containing strings for 'email address' and 'bio').

The odd thing about this analogy is that, while lexers/parsers *return* the syntax tree they’ve produced from a stream of bytes, an HTTP controller typically does not *return* a representation of the model method calls that corrrespond to its input HTTP request (although it certainly *could*... but that idea is a different blog post), it *executes* them directly. This shouldn't compromise the analogy though.

## A questionable idea: middlewares

Controllers, though, typically only involve behavior that applies to a single route. Behavior that applies to multiple routes, in my experience, tends to be organized into a series of “middlewares” or a “middleware stack”. This is a bad idea for approximately the same reason that putting controllers in front of models is a good idea. Namely, middlewares operate on very unconstrained data structures -- HTTP requests and responses -- instead of constrained data structures that are easy to reason about and compose.

I'm assuming some familiarity with middlewares, but to characterize them briefly, middlewares:

  * take an HTTP request and an (in-progress) HTTP response as arguments
  * don't have a meaningful return value
  * therefore must operate through mutating the request or response objects, mutating global state, causing some side-effect, or throwing an error.

It's like we threw out everything we learned in model/controller land about trying to operate on constrained data, and just decided that, before the router, it needs to be HTTP requests everywhere!

If your middlewares represent simple, independent operations, I still think middleware is a poor way of expressing these operations, but it is mostly benign. The trouble begins when the operations become complex and interdependent.

For example, these qualify as simple operations:

  1. Rate limit all requests to 100 per-minute per-ip.
  2. return 401 if a request lacks a valid authorization header
  3. log 10% of all incoming requests

Written as middlewares in Express, this looks something like the following (code is illustrative only, please don't try and run it)

```javascript
const rateLimitingMiddleware = async (req, res) => {
  const ip = req.headers['ip']
  db.incrementNRequests(ip)
  if (await db.nRequestsSince(Date.now() - 60000, ip) > 100) {
    return res.send(423)
  }
}

const authorizationMiddleware = async (req, res) => {
  const account = await db.accountByAuthorization(req.headers['authorization'])
  if (!account) { return res.send(401) }
}

const loggingMiddleware = async (req, res) => {
  if (Math.random() <= .1) {
    console.log(`request received ${req.method} ${req.path}\n${req.body}`)
  }
}

app.use([
  rateLimitingMiddleware,
  authorizationMiddleware,
  loggingMiddleware
].map(
  // Not important, quick and dirty plumbing to make express play nice with
  // async/await
  (f) => (req, res, next) =>
    f(req, res)
      .then(() => next())
      .catch(err => next(err))
))
```

What I advocate for is more along the lines of this:

```javascript
const shouldRateLimit = async (ip) => {
  return await db.nRequestsSince(Date.now() - 60000, ip) < 100
}

const isAuthorizationValid = async (authorization) => {
  return !!await db.accountByAuthorization(authorization)
}

const emitLog = (method, path, body) => {
  if (Math.random() < .1) {
    console.log(`request received ${method} ${path}\n${body}`)
  }
}

const mw = async (req, res) => {
  const {ip, authorization} = req.headers
  const {method, path, body} = req

  if (await shouldRateLimit(ip)) {
    return res.send(423)
  }

  if (!await isAuthorizationValid(authorization)) {
    return res.send(401)
  }

  emitLog(method, path, body)
}

app.use((req, res, next) => {
  // async/await plumbing
  mw(req, res).then(() => next()).catch(err => next(err))
})
```

Instead of registering each operation as its own middleware and relying on Express to call them in sequence, passing in unconstrained request and response objects, I write each operation as as a function with its constrained inputs declared as parameters, and its result described in its return value. Then I register a single middleware which is responsible for "translating" HTTP into the more constrained language of these operations (and executing them). This, I believe, is the moral equivalent of "thin controllers".

In this simple example, my approach doesn't really have a clear advantage. So lets introduce some complications.

Suppose some new requirements come in

  1. Some requests come from "admins".
  2. 100% of requests from admins should be logged (so debugging is easier)
  3. Admin requests shouldn't be subject to the rate limit, either.

The simplest way to do this is to do the lookup and the check in the logging and rate limiting middlewares.

```javascript
const rateLimitingMiddleware = async (req, res) => {
  const account = await db.accountByAuthorization(req.headers['authorization'])
  if (account.isAdmin()) {
    return
  }
  const ip = req.headers['ip']
  db.incrementNRequests(ip)
  if (await db.nRequestsSince(Date.now() - 60000, ip) > 100) {
    return res.send(423)
  }
}

const loggingMiddleware = async (req, res) => {
  const account = await db.accountByAuthorization(req.headers['authorization'])
  if (account.isAdmin() || Math.random() <= .1) {
    console.log(`request received ${req.method} ${req.path}\n${req.body}`)
  }
}
```

but this is unsatisfying. Wouldn't it be better to call `db.accountByAuthorization` only once and avoid three round-trips to the database? Middlewares cannot produce return values, nor accept as arguments values produced by other middlewares, so the way this must be done is by mutating the request (or response) object, like so:

```javascript
const authorizationMiddleware = async (req, res) => {
  const account = await db.accountByAuthorization(req.headers['authorization'])
  if (!account) { return res.send(401) }
  req.isAdmin = account.isAdmin()
}

const rateLimitingMiddleware = async (req, res) => {
  if (req.isAdmin) return
  const ip = req.headers['ip']
  db.incrementNRequests(ip)
  if (await db.nRequestsSince(Date.now() - 60000, ip) > 100) {
    return res.send(423)
  }
}

const loggingMiddleware = async (req, res) => {
  if (req.isAdmin || Math.random() <= .1) {
    console.log(`request received ${req.method} ${req.path}\n${req.body}`)
  }
}
```

This should morally disturb you. First of all, mutation is bad -- or at least these days it's fallen out of fashion (rightly so, in my opinion). Second of all `isAdmin` has nothing to do with an HTTP request, so it should seem unnatural to smuggle it onto an object purporting to represent an HTTP request.

Moreover, there is a practical issue. The code is broken. `rateLimitingMiddleware` now implicitly depends on being run after `authorizationMiddleware` has run. Until I fix it and put authorizationMiddleware first, admins will not properly be exempted from the rate limit.

So what does this look like without middlewares? (Well, with only the one...)

```javascript
const shouldRateLimit = async (ip, account) => {
  return !account.isAdmin() &&
    await db.nRequestsSince(Date.now() - 60000, ip) < 100
}

const authorizedAccount = async (authorization) => {
  return await db.accountByAuthorization(authorization)
}

const emitLog = (method, path, body, account) => {
  if (account.isAdmin()) { return }
  if (Math.random() < .1) {
    console.log(`request received ${method} ${path}\n${body}`)
  }
}

const mw = async (req, res) => {
  const {ip, authorization} = req.headers
  const {method, path, body} = req

  const account = authorizedAccount(authorization)
  if (!account) { return res.send(401) }

  if (await shouldRateLimit(ip, account)) {
    return res.send(423)
  }

  emitLog(method, path, body, account)
}
```

The equivalent bug here would involve writing e.g.

```javascript
if (await shouldRateLimit(ip, account)) {
  ...
}
const account = authorizedAccount(authorization)
```

which -- defining a variable `account` before it is used is miles easier to spot. ESLint will catch it, if you don't. Again, this is made possible by defining functions with *constrained* parameters and return values. Static analysis won't get you very far on unconstrained "request" objects that are grab-bags of arbitrary properties.

I hope this example convinces you, or resonates with your experience using middleware, even though the issues in my example are still quite mild. It becomes much worse in real applications, especially when you add more complications into the mix -- admins being able to act as other accounts, resource-level rate-limits and ip restrictions, feature flags, and so on.

## Whence cometh this darkness?

Hopefully I've convinced you that middlewares are bad -- or at least easily misapplied. But if they are so bad, how did they come to be so popular?

I've written my share of ill-advised middlewares, and for me I think what it comes down to is ["the law of the hammer"](https://en.wikipedia.org/wiki/Law_of_the_instrument). As described in the opening quote: "give a small boy a hammer, and he will find that everything he encounters needs pounding." Middlewares are the hammer, and I have been the small boy.

These web frameworks (Express, Rack, Laravel, etc.) emphasize this concept of "middlewares". I knew there was a series of operations that I needed to perform on requests before they reached the router. I saw that "middlewares" seemed to be intended for this purpose. I never really stopped to reason about the advantages and disadvantages. It just seemed like the "right" thing to do -- what the framework *wanted* me to do. So I did it.

I think there's also some vague feeling that it is Good to solve a problem in the way that your framework wants you to, because if you do, maybe you'll be able to better take advantages of the other features your framework has to offer. In my experience, this hope seldom bears out.

I've also fallen prey to this sort of thinking [in other circumstances](2019-06-21-life-is-too-short-for-jenkins.html). For example, I used [Jenkins shared libraries](https://jenkins.io/doc/book/pipeline/shared-libraries/) when I wanted to re-use code across multiple CI jobs. I wrote }[&%ing *Groovy* to do this, a language I abhor. What I should have done -- and what I would have done had I not known that "Jenkins shared libraries" existed -- is simply write the actions in whatever programming language I wanted (probably Bash in this case) and make them available to be called via shell on the CI workers.

So the broader lesson here is, try to be aware of this tendency in your own thinking. Use the tools. Don't let the tools use you. Especially if you're a more experienced programmer, and using the tool the way it "wants" to be used doesn't seem quite right -- it probably isn't.

Use functions that take what they need as arguments, and put their result in their return value.And write applications like compilers, if you can -- that's a good lesson, too.
