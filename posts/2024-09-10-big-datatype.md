---
title: "Big Datatype: why code tools like to be written with fancy types"
class: prose
description: "What explains the disproportionate popularity of typed FP for code tools and relative unpopularity for web apps?"
quote: "an expressive type system gives you more of an ability to *centralize your reasoning* in a single place"
retweet: "https://x.com/twitchard/status/1833721816973562087"
---
![L](../images/dropCapL.webp){class="dropCap"}anguages with ML-style type systems like Haskell and OCaml[^1] seem to be particularly successful in the "code tools" genre of software project. This is my subjective impression, at least. Here's a few I can think of off the top of my head:

In Haskell

* Many programming languages: [Purescript](https://www.purescript.org/), [Elm](https://github.com/elm/compiler/), [Unison](https://github.com/unisonweb/unison), [Agda](https://github.com/agda/agda).
* [Semantic](https://github.com/github/semantic), the library Github [built](https://github.com/github/semantic/blob/main/docs/why-haskell.md) for enabling code navigation for repos in many programming languages.
* [ShellCheck](https://github.com/koalaman/shellcheck), a linter for shell scripts

In OCaml

* [Comby](https://github.com/comby-tools/comby), a tool for codemods
* [Semgrep](https://github.com/semgrep/semgrep), a tool for searching for code patterns
* [Flow](https://github.com/facebook/flow,) Meta's type checker for Javascript
* [Hack](https://github.com/facebook/hhvm/tree/master/hphp/hack), Meta's offshoot of PHP.

Outside code tools, these languages seem rarer. There's a fintech company [Mercury](https://mercury.com/) that uses Haskell on the backend; there's a trading firm [Jane Street](https://www.janestreet.com/) that uses OCaml ubiquitously, there are some blockchain projects, but these are outliers. For the most part, if a well-known, successful company uses OCaml or Haskell it's for some particular, specialized use case -- they're not usually writing their entire system in it.

Why? What explains the disproportionate popularity for code tools and relative unpopularity for web apps?

It could be sociological: perhaps there is a certain kind of developer -- say, those more on the idealistic side -- who is both more likely both to find typed FP appealing, and to wind up having occasion to invent their own code tool.

Or, it could be path dependence and network effects. There's lots of blog posts about implementing programming language compilers and interpreters and such in Haskell and OCaml. There are well-regarded libraries for e.g. parsing (Parsec, Menhir), too, in these ecosystems. So, if you are writing something along the lines of a compiler yourself, it's easier to go with the herd and use what you see others using. In the opposite direction, there are a gazillion blog posts and well-regarded libraries for doing web apps (Rails, Django, Spring Boot) in non-FP languages, so if you're writing a web backend it's easier to go with the herd here too.

But I don't think happenstance is the whole story. There seems to be something inherent about typed, functional programming that is *particularly* useful for writing code tools -- something that isn't useful to the same degree in other contexts.

## Big Datatype

My hypothesis is that there is a fundamental difference -- I call the phenomenon *Big Datatype* -- between the way you write a web app vs. the way that you write a code tool.

In a *code tool*, the source code of your implementation is typically organized around a few, very important, centralized datatypes. In a compiler, you've got your abstract syntax tree, some intermediate representations, your output instruction set, etc., and your program is mostly a series of transforms between these Big Datatypes. The AST is a Big Datatype in many tools besides compilers too, linters and codemods and whatnot.

Web applications don't exhibit *Big Datatype* to the same degree. In a typical web backend, you have a `models/` directory with dozens or hundreds of largely independent classes, containing code that solves hundreds of loosely related but mostly independent problems. 

```bash
$ cd models/
$ ls 
avatars.rb              likes.rb     saved_searches.rb
comments.rb             products.rb  users.rb
email_subscriptions.rb  reviews.rb   wishlists.rb
```

Some of these are more important than others, yes: most models will have some sort of reference to the User model, probably, but the user model still probably isn't the all-encompassing, centrally important data structure in the same way as is the AST in a code tool. The code in `saved_searches.rb` will have a reference or two to the User model, maybe, but the `User` type won't be the input and output type of any methods inside `saved_searches.rb`, probably.

This is why *microservices* is at all a tenable idea for web backends. You can get away with writing your *likes* service in a completely different programming language with a different database than the rest of your application, your app could still function mostly fine if your *likes* service went down, say -- because the problems your *likes* service solve are sufficiently disconnected from the problems that the rest of your web app solves. But inside a compiler it would be absurd to try to implement, e.g. inheritance in one programming language, but then iteration in another. They interact. You must consider, for example, the case of iteration over a collection of expressions that may or may not inherit from a common class. Inheritance isn't a separate problem from iteration in a compiler in the same way that likes are separate from comments in a web app.

### Expressive types

If your codebase has *Big Datatype*, I claim, there is a higher payoff you can get if you use an expressive type system. People like strong types for a lot of reasons: bug prevention, IDE tooling, but a big one is *compiler-directed refactoring[^2]*. 

The story of compiler-directed refactoring is something like this: you want to make a wide-ranging change to an existing large program. You start by changing a type or a function somewhere, and you get a type error. You resolve the type error, and it *cascades.* You get type errors in, say, three more locations. You resolve those type errors appropriately, and they *cascade* again, and you have six locations to fix, and so on, until your program compiles again. In this way, the type system *guides* you. Without types, tracking down all the various downstream places that might need to change would require tedious checking and careful thought. (A good test suite can provide similar guidance, but requires more mental discipline to maintain). The more expressive your type system, the more details about the problem you can encode into the types, and so the greater the proportion of changes you can use your type checker to partially automate.

So here's my centraI point: I conjecture that this *type cascade* offers a greater advantage in codebases under the regime of *Big Datatype*. Here's a hand-wavey thought experiment. Imagine you have two different codebases:

1. A **small datatype** codebase, where an average change to a type cascades and creates type errors in 2 other places.
2. A **big datatype** codebase, where an average change to a type cascades to 4 additional type errors.

In (1), 66% of the changes you make are compiler-guided (1 original change, 2 cascaded changes); but in (2), 80% of changes are compiler-guided (1 original change, 4 cascaded changes).

A more abstract way to put this is that an expressive type system gives you more of an ability to *centralize your reasoning* in a single place (the definition of your datatypes). This gives you much more leverage in codebases where there are a small number of central datatypes (code tools), vs. codebases when there is a sprawling number of lesser-important datatypes (web apps).

Does this mean I don't think you should use typed FP for web apps? No! You certainly can. As I've hinted in previous posts, my opinion is that we should actually try to write web apps [more like compilers](2019-11-01-beware-middleware.html), in a style that makes the [constraintful features](2021-04-24-behavior-constraining-features.html) of web apps more explicit.

## Typescript

Most of what I write professionally isn't Haskell or OCaml, it's Typescript. The "code tool" I've worked most on isn't exactly a compiler: it generates SDKs from an OpenAPI definition, but it is definitely subject to *Big Datatype*.

If you are deliberate about it, Typescript can also be a good language for writing code tools. You've got the expressive type system with sum types, parametric polymorphism, and convenient structural typing. If you've got a habit of avoiding gratuitous side effects and writing functions so that the input and return types tell a complete story of what is happening inside the function, then you too can experience the *type error cascade* when making project-widen design changes. Typescript doesn't *force* a style like this, the way a language like Haskell does, so you have to work for it, but I've been pretty happy. 

So if *you* find yourself working on a code tool, it may or may not be practical to write it in OCaml or Haskell, but at the very least I think it pays to *teach yourself* an ML-inspired language on the side to practice the skill of telling stories with types. Learn to put Big Datatype at work for you.

[^1]: Rust also has an expressive (and ML-inspired) type system, and is also popular for code tools, so I suspect Rust also supports my arguments but omit discussing Rust just because I'm personally not as familiar.

[^2]: I've looked for a blog post that describes "compiler-directed refactoring", but haven't quite found one to my satisfaction. Sandy Maguire has a [good post](https://reasonablypolymorphic.com/blog/typeholes/) where he talks about how "you don't have to use your brain to do programming" with Haskell, but he is talking about how you can use the compiler as a code assistant *in the small*, so to speak, to write an implementation of a single tricky function. My concern is more about using the type checker as an assistant *in the large*. Edwin Brady, author of the Idris programming language, has an entire book entitled ["Type-driven development with Idris"](https://www.manning.com/books/type-driven-development-with-idris) (strongly recommended, by the way), but "type-driven development" here refers to a technique for writing *whole programs* from scratch where you use your types as a sort of outline for your program and you progressively fill in the implementation. This is closer to what I mean, but is sort of too broad. 
