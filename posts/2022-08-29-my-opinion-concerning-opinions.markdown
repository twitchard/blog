---
title: "My opinion concerning opinions"
class: prose
description: "Your tools and code have opinions. Rule them or be ruled!"
draft: true
---

I wrote in [Beware Middleware](/posts/2019-11-01-beware-middleware.html) about an instance of the ["Law of the Hammer"](https://en.wikipedia.org/wiki/Law_of_the_instrument) tl;dr if you use an HTTP framework like express.js, it will push you to put all non-route-specific logic in a series of “middlewares” i.e. effectful functions with broad, weak types -- even if this is not the best design (it's not).

Every tool has opinions like this. Another example I ranted about: the [Jenkins](/posts/2019-06-21-life-is-too-short-for-jenkins.html) CI tool provides something called "shared libraries" which pushes you to implement shared logic in Groovy in a way that isn't easily testable or executable locally.

A third example, just for fun, if you use an object-oriented programming language, it will push you to organize things into classes. When your codebase reaches a certain level of maturity, class hierarchies are useful for code re-use and encapsulation, but programmers often start breaking things into classes earlier than necessary, because it is satisfying to feel like you have "organized" things, just for the sake of organization. Unfortunately, the divisions that are most satisfying, the ones that match the ontologies in our heads, often aren't the divisions that turn out to be useful for encapsulation. (Further reading: [this analysis of OOP inheritance](https://www.sicpers.info/2018/03/why-inheritance-never-made-any-sense/))

It's not just third-party tools. Your codebase has opinions too. For example, suppose all the business logic in your web app is contained inside models, and your "model" concept assumes a 1:1 correspondence with database records. But now you're introducing a new concept - say "pagination cursors". In the opinion of your codebase, you should make a pagination cursor a model and give it a database record like everything else. But this is not the only option. You might want to put the code for pagination someplace else, where it's not tied to a database record. Or maybe you want to generalize the concept of "model" to include concepts that aren't persisted to the database.

These are all examples of *bad* opinions, that I think are likely lead you astray. Not all opinions are bad. Frameworks like Ruby on Rails or Ember.js market themselves as "opinionated" and are undoubtedly useful.

A good programmer, I think, is very conscious about how their tools are steering them, and they are deliberate about which opinions to accept and which to resist. This is especially important in long-lived, sophisticated, ambitious codebases, where your goal isn't just to fulfill today's product requirements, but to build a [playground for ideas](2019-05-23-fire.html) where it's easy to try out many things quickly, where you [systematically enforce your constraints](2021-04-24-behavior-constraining-features.html), so that it's easy to add new behavior without invalidating the application's cross-cutting concerns.

The opinions of your tools are like currents. They can carry you long and far, but if you don't steer, you will end up some place you don't want to be. Steer, I tell you, steer!

The opposite mistake is possible too, of course. Swimming against the current. It's [the big rewrite](https://www.joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/), where you decide that your existing stack and codebase have opinions that are so opposed to your vision, that the only thing to do is to throw out everything and start over from scratch. I've seen this three times in my career, on small and large scales. Every time it has been a mistake.

Surprisingly, it's possible to make both mistakes at once. You can commit to The Big Rewrite, choose a new set of tools, and then instead of actually thinking carefully about the new system you want to build and the properties you want it to have, just naively let yourself be unthinkingly guided by the opinions of the new tools you have chosen into a completely different sort of hell! Swim against one current into another one that dashes you against the rocks! This definitely has never happened in any organization I've been a part of.
