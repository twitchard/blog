---
title: Please, Systematically Enforce Your Constraints
class: prose
description: "There are two types of features: behavior-adding features and behavior-constraining features."
quote: "Some software features add behaviors, others mainly constrain them."

---

## The Two Types of Features

<img src="../images/dropCapI2.jpg" alt="I" class="dropCap" /> have two dogs. Mozzarella and Gouda. Sometimes, I add behavior to them. I teach them new tricks. My latest favorite is "dance." Other times, I (try to) add constraints to their behavior. Please, Gouda, do not eat shoes. Please, Gouda, urinate only outside the house. Please, Mozzarella, do not run out of the house to loudly express your opinions to the delivery woman.

Software is the same. Some software features add behaviors, others mainly constrain them. 

Consider these features:

* A "submit feedback" form
* Internationalization support
* Social media sharing
* A star rating system
* Activity history
* Dark mode
* The GDPR "right to be forgotten"

My classification: "submit feedback", "social media sharing", and "star rating system" are behavior-adding features. Building them would typically almost entirely involve adding new behaviors to your app. But "internationalization", "activity history", "dark mode" and "right to be forgotten" are behavior-constraining features. Building them in large part involves adding new constraints that must apply across existing and future behaviors in your app.

To support internationalization, you must forbid any element in your app from rendering hardcoded English. They may only render text that has been processed by your internationalization system. This is a constraint.

To add "activity history", you must forbid any activity (at least, any "activity" users might reasonably expect to be present in their history) from being defined without triggering creation of the appropriate history entry. This is a constraint.

To add dark mode, you must forbid all components in your app from expressing their stylings in terms of specific colors like "black" and require them to do so in terms of variable colors like "primary" or "secondary." This is a constraint.

To respect the GDPR "right to be forgotten", you must forbid all parts of your application from writing certain data anywhere it is not indexed in such a way that it can be found and purged by your deletion process. This is a constraint.

Now, I’m not a software thought leader. I have no authority to tell you how to write software. But if I were, I would give you this sound bite: **make your application’s constraints explicit. Systematically enforce them.**

If you merely add internationalization to all text presently rendered by your app, but provide no guarantee that future text will be internationalized, you have not really successfully implemented "internationalization" -- you have implemented "internationalized things once."

If you merely go through all the actions in your app today, add logic to each action that writes a log to the activity history, and then you call it a day, you have not really successfully implemented "activity history," you have implemented a "these activities history."

For a while, maybe developers will remember to add internationalization when they add new text, to add an activity log when they add a new user action, to consider GDPR when they put PII in a new place, to add a dark theme when they write a new component. But that while will end. Sooner or later, somebody will miss it here, and somebody will copy and paste the omission there, and all this will go unnoticed until months later, when context is long gone, and now somebody has to investigate, rediscover how everything works, and make a correction. Not great.

So build your system to enforce these things. When you add a component that’s missing a dark theme, or add a new data field without considering the GDPR implications, or add uninternationalized text -- something should stop you. A test should fail, a type error should trigger, a linter rule should fire, a runtime check should throw, a cron job should spam your email. Ideally, whatever that something is, it should act 

  * soon after the offending code is written
  * with clear instructions about how to appropriately satisfy the violated constraint
  * with an optional escape hatch, so that you can temporarily postpone the fix until you are finished with your current task.

## Enforcing Constraints

Building a system like this takes deliberate, conscious effort. This is not the default. Today’s software tools and techniques are designed mostly around behavior-adding features, not constraintful features. Adding a new behavior to your Rails app? Just "rails generate" a new model or view. There is no "rails constrain". Or take the whole "microservices" trend. Adding a new behavior? Spin up a new microservice! Adding a new constraint across all behavior? Well...that’s possible. But it’s not the happy path.

Even with the tools I mentioned above: tests, types, linters, crons -- using them to express application-level constraints is somewhat atypical. Most developers use these tools mainly for other things.

### Tests

The two orthodox types of software tests are integration tests and unit tests. These tests are mostly used for checking that the piece of code that you just wrote does what you think it does and preventing yourself from later causing it to do something else by accident.

But another sort of test is possible. Consider a test that asserts that every type of component in your app supports dark mode, or a test that iterates through the schema of every data field your app writes to any database, and asserts that it has an appropriate GDPR annotation. These tests aren't "unit" or "integration". I'm not sure what they are. Are they "system tests"? Whatever their name is, this technique is not as common as perhaps it should be. There aren’t a million blog posts written about this sort of test.

### Type Systems

Now take type systems. When static types enthusiasts try to sell others on the idea of static types, they usually emphasize types as an effective way to "catch bugs". Your type checker will help you catch silly mistakes -- no more "undefined is not a function". No more passing seconds to functions that expect milliseconds. That’s essentially the argument you’ll encounter if you google "why Typescript", anyway. That plus easier refactors.

Silly mistakes can be very costly, and catching them is great, but in my view this vastly undersells the potential of types. An expressive type system wielded well is not a mere proofreader that helps you write the code you intended to write in the first place. It is an executive editor that can prompt you to reason more deeply when the code you intend to write neglects important product requirements that perhaps you didn’t even remember existed.

You don’t need to be all that fancy with your types to have this. You don’t need to adopt Haskell, although certainly that helps the ergonomics. Your favorite OOP language will do. 

Want to enforce that everybody who adds a new field of data into your app is confronted by the need to respect the GDPR right to be forgotten? A sketch of how you might go about this:

Refactor your app so that nothing is written to any database except through calling a function called `writeToDatabase`. 
Design the type of `writeToDatabase` to accept only arguments that involve instances of a particular class `DataField`. 
Define `DataField` to be an abstract class with an unimplemented method `doGDPRRightToBeForgottenPurge` that every child class must define. Give it a descriptive docstring. Provide some standard implementations for common cases.
Voila! Everybody who adds new types of data now will be prompted to reason about the GDPR implications of their addition.

You don't even really need your types to be static for this. Dynamic types will serve. You can easily do this in, say, PHP -- you just won't get the error until runtime.

What you don't want to do is build some `GDPRPurgerWorker` class off by its lonesome self, with a method inside that handles the deletion logic for all the relevant data fields that you know about today. Or at least, if you do want this, then you’ll need to come up with some other mechanism for enforcing that future fields don’t neglect this. If your programming language gives you exhaustiveness checking over sum types, that’s a solid option. In other languages, you might have to build your own exhaustiveness checking mechanism. Maybe you need to build the concept of "registering" a data field, and then you can write a test that asserts that no data fields are "registered" besides those handled in your purge method. In any case, without adding some sort of check, you are begging for your constraint to be ignored.

### Linters

Kind of like type systems, it's easy to undervalue linters. Yes, linters are good at catching silly mistakes like "oops, I defined that variable but didn’t use it." But they can be more powerful. You are allowed to define your own linter rules. Use a linter in your JSX to catch hardcoded text that wasn’t piped through your internationalization system. Use a linter to catch stylings that seem to be hardcoding colors rather than using your dark and light themes.

## A Culture of Constraints

I don’t think this idea: "systematically enforce your constraints; be explicit about them" is a particularly novel insight. Every major codebase I’ve worked in does this to some degree or other. But I wish this degree were higher. And I hope, with my four examples, I’ve made you wish that, too. Think of your least favorite part of your most recent codebase -- the part that keeps breaking. Is the underlying problem some constraint that hasn’t been made explicit?

Huge swaths of the software domain are almost entirely constraintful in nature. Security? Privacy? Accessibility? All constraints.

I wish that the standard tools of software development made emphasizing the constraints easier. Naturally, I wish more languages had expressive type systems like Haskell’s. I wish that it were more standard for codebases to reify notions like "data field" or "activity" or "theme" so that in your tests you could iterate over all of them in tests and make assertions about global properties.

As I suggested above, I’m vaguely concerned about trends like microservices. Microservices do drive you to decouple your app into independent parts, but this isn’t quite as desirable for behavior-constraining features as it is for behavior-adding features. Putting the logic for "social media sharing", "star ratings" and "submit feedback" into independent services makes sense to me. But an "activity history service" I question. How do you automate confronting the authors of the "star rating" or "social media" service with the necessity of sending a request to the "activity history" service? I would argue "activity history" belongs not as a service of its own, but as a component of the infrastructure that all microservices have in common. In the same place where the "star rating" defines what sort of user requests/events it consumes -- be that inside some sort of "service manifest" or inside the "API Gateway" -- it should also be required to define what "user activities" might result and how those should be logged. I don’t really see any other way to enforce that "activity history" isn’t neglected. But that runs against the grain of microservices. If you have a hammer, everything looks like a nail. If you’re adopting microservices, every concern looks like it should be its own service. And my fear is that this trend will lead software systems to sacrifice more constrainability than they should. So be careful!

## A final word

I’ll say it again: I’m not a software thought leader. I have no authority to tell you how to write software. And nothing in this post is a particularly novel insight. Still, I’m glad you’ve read it. And I hope me putting it in these terms will prompt you to think in a different way about whatever feature you work on next. Is it behavior-adding, or behavior-constraining? If it’s behavior-constraining, is there anything you can do to be more explicit about the constraint, or more systematically enforce it? Believe me, your successors will thank you.

