---
title: "Frame your problem domain creatively"
class: prose
description: "Promote yourself in your own mind"
draft: true
---

I gave a [conference talk](https://thestrangeloop.com/2021/artisanal-machine-generated-api-libraries.html) last year, tldr: “we generate SDKs. Here are all the lessons we’ve learned from framing this as a compilers problem.”

I think teams should try really really hard to draw analogies between what they are building and “classic”, well-understood, formally studied systems and ideas in computing. Is your web API a compiler if you squint? Is your deploy system really a database if you squint? Squint, I tell you, squint!

The reason is not so you will somehow be able to apply advanced techniques from research journals to your web apps. You won’t. But there are other advantages.

First, you get a vocabulary for free. If you pretend your app is actually a compiler, you can talk about “source language” and “intermediate representations” and “compiler passes” and “syntax trees” – things that you would otherwise have to invent bespoke names for, or be unable to talk about at all. 

Second, analogies can be a good source of interesting ideas. If your web app is a compiler, HTTP is your source language, and database queries are your target language, could you build a “source map”? What would that mean? Could you attribute the queries in your slow query log to particular parts of a request? Also what are your intermediate representations? Is it worth introducing another one? Should your app be a multi-pass compiler or a one-pass compiler. Does that distinction make sense? These won't all be good ideas, it is plain to see. But you might strike gold.

Third, morale. It’s fun to be able to think of yourself as a compiler* engineer, even if the asterisk is big and analogy is a little hazy.

Last, I’ll observe it’s quite within the realm of possibility you’ll encounter a problem that truly belongs to the domain of e.g. programming language design, no squinting required. Robert Harper [wrote](https://www.andrew.cmu.edu/course/15-312/phil.html)

> Programming language theory has many applications to programming practice. For example, “little languages” arise frequently in software systems --- command languages, scripting languages, configuration files, mark-up languages, and so on. All too often the basic principles of programming languages are neglected in their design, with all too familiar results. After all, the argument goes, these are “just” scripting languages, or “just” mark-up languages, why bother too much about them? One reason is that what starts out as “just” an ad hoc little language often grows into much more than that, to the point that it is, or ought to be, a fully-fledged language in its own right. Programming language theory can serve as a guide to the design and implementation of special purpose, as well as general purpose, languages. 

I agree something seems to be awry with the industry’s popular “little languages”. You can hardly spit without hitting a configuration language that deserves it. Devops these days is “yaml hell”. My team years ago sunk weeks into debugging our monolith’s flaky Makefile, entirely thanks to the Make language’s poor abstractive capabilities and terrible debuggability. In theory, configuration languages that are embedded in a general-purpose host language – i.e. the ruby-based or groovy-based DSLs of Puppet, Chef, Jenkins, and Gradle – should be better than yaml hell. In practice, though, the little languages of these tools fails to inherit the DX benefits of the host language, i.e. it is not natural to write unit tests, log things, attach a debugger, define your own datatypes, or even write/import functions.

Harper, a PL theorist, unsurprisingly prescribes PL theory as a remedy. Our little languages would be better if their authors knew how to write inference rules, formally define their language’s semantics, etc. 

Maybe so, but I'll settle for far less than formal semantics. I just want the authors of little languages to give themselves a promotion in their own minds. Don't be an input format designer, be a programming language designer! Don't just give your users a rigid way to specify configuration for each of your tool’s features. Give them a tool for expressing themselves, for elegantly writing down the mental models of what they want your tool to accomplish.  And of course, guide them interactively. Steer them away from nonsensical configurations, and help them discover the features of your tool. Provide the trappings that you would demand of a modern, general-purpose language –
a repl, a debugger, type checking, logging capabilities, stack traces, autoformatting, autocomplete, the ability to write tests, and so on -- or at least as many as you can afford. 

The way to do this without reinventing the wheel is almost always to embed your little language in a larger, general-purpose language. I find the “shake” build system by Neil Mitchell to be an excellent example of this. A shake build configuration is just a Haskell program, and so you can use all the interactive tools that the Haskell ecosystem provides. The bazel build system by Google is another example. It is embedded in the “starlark” general-purpose language, and so gains the expressive power of that language – however it obscures the entry point and execution path from the user, and so has a poor debuggability/interactive development story.

Even if you don't work on a developer-facing product, the internal tools and systems of a large-ish organization probably have a “little language” or two that would benefit from being recognized as such. I often think about [a talk I saw](https://thestrangeloop.com/2018/leverage-vs-autonomy-in-a-large-software-system.html) that describes Twitter’s approach to microservices and “StratoQL”, a language Twitter invented for describing service schemas and cross-service requests. I can't speak personally to how effective their tool is, but I’m comfortable predicting that it is better than the counterfactual where developers just do everything in yaml.
