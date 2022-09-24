---
title: "Fools! Stop Mysticizing System Dynamics"
class: prose
description: "A system dynamics model, properly considered, is just an analogy dressed up in a bit of formalism."
quote: "A system dynamics model, properly considered, is just an analogy dressed up in a bit of formalism."
reddit: https://www.reddit.com/r/programming/comments/xn1qil/fools_stop_mysticizing_system_dynamics/?utm_source=share&utm_medium=web2x&context=3
retweet: https://twitter.com/twitchard/status/1573756536496656384?s=20&t=ewxW-11tc9Q0FX7hd0itRg
---

![O](../images/dropCapO.jpg){class="dropCap"}ccasionally, my Twitter feed sends to me a writer arguing via [queueing theory](https://www.lostconsultants.com/2019/11/20/littles-law-applied-in-agile-software-development/), [stock and flow diagrams](https://lethain.com/systems-thinking/), [equations](https://codahale.com/work-is-work/), or [even](https://lethain.com/limiting-wip/) [simulations](https://twitter.com/michelgrootjans/status/1431653674024046593) to advance their ideas of how software teams should operate. These are the tools of [system dynamics](https://en.wikipedia.org/wiki/System_dynamics).

I understand the appeal. We're engineers. We like building things. System dynamics lets you construct an argument by building a model. Provocative title aside, I do appreciate this style of argument. Some very thoughtful writing is done this way. It is explicit and engaging; it can even be visual or interactive.

But I have two objections: first, **arguments involving system dynamics tend to rely on *mysticism***; that is, they claim authority without enough justification. A system dynamics model, properly considered, is just an analogy dressed up in a bit of formalism. Like any analogy, you should only give it force if the stories it tells are plausible in light of your experience and knowledge.

Second, **system dynamics *mechanizes* software teams too much**: it models software teams as ruly phenomena that obey equations and universal laws -- not collections of humans, unpredictable and unique. It suggests a vision of *software leader as maximizer*: leadership is cast as a form of engineering, it is ultimately about designing systems and organizing processes to maximize throughput. I'm not sure whether the wielders of system dynamics *intend* to advance the *leadership is engineering* metaphor, but that is the undercurrent.

To illustrate, I'll proceed through three examples of "system dynamics gone wrong" from blogs or books I've read. 

## Example 1: Stock and Flow Diagrams

Let's start with [a post](https://lethain.com/systems-thinking/) by Will Larson. I have a small criticism of a single blog post, but I heartily recommend all of Larson's writing, particularly his book [An Elegant Puzzle](https://lethain.com/elegant-puzzle/), a treasury of thoughtful, practical advice for engineering leaders. Larson writes occasionally about "systems thinking", and is particularly fond of [stock and flow diagrams](https://en.wikipedia.org/wiki/Stock_and_flow), from the system dynamics toolbox. In [this particular post](https://lethain.com/systems-thinking/), he draws this diagram

![](../images/dev-velocity-sys.png){style="width: 100%"}

and then argues

> If your model is a good one, opportunities for improvement should be immediately obvious, which I believe is true in this case. However, to truly identify where to invest, you need to identify the true values of these stocks and flows! For example, if you don’t have a backlog of ready commits, then speeding up your deploy rate may not be valuable. 
 
The first time I read this post, I went googly-eyed at the diagram and nodded along to the analysis. But something is clearly wrong. Imagine you are a solo developer, and deploys take an hour. You won't build up a backlog of commits. Does this mean speeding up deploys to 1 minute is valueless? That's crazy talk! [Speed](2022-08-30-short-feedback.html) up your deploys and you have gained a super power: the ability to interactively ask questions of your production environment, e.g. add a quick log statement to get a sample of the values a variable has under production traffic.

The stock and flow diagram says nothing about this superpower. To the diagram, the only value of deploys is that they convert the stock of ready commits into the stock of deployed commits. It has nothing to say about developer workflows, time-sensitive information, or the concept of interactivity.

### Not as flexible as they seem 

Stock and flow models have this deceptive veneer of flexibility: you can model virtually anything with them it seems: you need only think of it as something that *accumulates*. But this is the limitation -- the only aspect of your system a stocks and flows model can capture is the *accumulation* aspect. Thus, you can't easily translate the story about fast deploys making production logs more interactive into a story about stocks and flows. This is a story about time-sensitive information and temporary states inside the mind of a working developer. Such things don't accumulate into stockpiles.

Put another way, stock and flow models *seem* much more flexible than they actually *are*. You can pick virtually *any* object and tell *a* story about it with a stock and flow diagram. But you can't pick *an* object and tell *any* story about it, you are actually very limited about the types of stories that you can tell. And these won't always be the stories that best describe the important behavior of the system.

### Leadership is not modeling

I think stock and flow analysis can be a fun, occasionally useful exercise for brainstorming and ideation. I do not think it is a fundamentally important skill for leaders.

Leaders[^1] should worry foremost about being effective, inspiring communicators, spending time listening to the people they are responsible for and understanding the organization's problems from their perspective. They should learn to tell stories that resonate about the organization's direction and the product vision. Their job is not to lock themselves in a room, build models of the organization, draw diagrams, measure things, diagnose issues, and implement solutions. That's *leadership as engineering*.

Leaders do need to manage the bureaucracy. Somebody needs to manage the reporting structure, the hiring process, review processes, and so forth. It's nice to work in an organization with thoughtful and smooth bureaucracy. Bureaucracy can be engineered, to an extent. Stock and flow analysis has a place here. In my philosophy of engineering leadership, though, smooth bureaucracy is very secondary. Culture is king. I don't want my manager's manager and their manager to spend all their energy fiddling with the details of the org chart all the time. They should fix these things if they are severely broken -- i.e. in a way that does not require detailed analysis of subtle interactions-at-a-distance between interrelated elements of a system to uncover -- but I would rather they focus on developing culture. Here is a list of things I think matter much more in a software team than smooth bureaucracy:

  * psychological safety
  * deep understanding of the customer
  * compelling product narratives
  * positive team sentiment
  * belief in the organization's mission
  * [well-framed ideas](2022-09-02-glamorize-your-problem-domain.html)
  * [pride of workmanship](https://en.wikipedia.org/wiki/Pride_of_workmanship)
  * [interactive tools](2022-08-30-short-feedback.html)

These things are not really subject to stock and flow analysis. I am afraid that expositing stock and flow analysis as a tool for engineering leaders without this context paints a distorted picture of what leadership is.

## Example 2: The Theory of Constraints

I occasionally see software writers mention ["The Theory of Constraints"](https://en.wikipedia.org/wiki/Theory_of_constraints). This comes from a book "The Goal", a work of fiction about a manufacturing plant, which I haven't read, but I have read ["The Phoenix Project"](https://www.goodreads.com/book/show/17255186-the-phoenix-project), which I understand is a knock-off of "The Goal" but in a software setting. It's a novel, where the authors invent a fictional dysfunctional company that is only able to fix its problems by applying the particular techniques the author wishes to advance. I recommend this book, too. It's thoughtful and entertaining, although I'm not sure I agree with the authors' agenda.

### Summary

The central idea of "The Theory of Constraints" is that the output of your system is limited by a single constraint. In a manufacturing plant, this might be a critical piece of machinery. In "The Pheonix Project" the constraint is Brent, an engineer involved in way too many projects who has amassed way too much tribal knowledge. To improve the system, leaders must singularly focus on the constraint. Improving something that doesn't affect the constraint won't actually increase output, because the constraint is the limit.

In "The Pheonix Project", the theory of constraints feels very mystical. It is among "The Three Ways" laconically revealed by this wise guru character. A mystical attitude towards system dynamics ideas is exactly what I'm out to dispel, so let's dive in.

### Sanity check

I buy that *some* systems are limited by a single constraint. I know little about manufacturing, but I'd believe you if you told me that on an assembly line the performance of one specialized machine could be the bottleneck for the whole system. I can also believe that the incredibly contrived IT organization in "The Pheonix Project" could have this property - it was specifically written to be that way.

But some systems are clearly *not* like this. For example: markets. If you want to increase the output of a market economy, you don't need to "identify the constraint" and make improvements only there. You can improve output anywhere. Find a huge deposit of iron ore. Have a bumper crop of bananas. It doesn't matter whether or not bananas or iron are the economy's "constraint" or not. There is no single constraint. Sell your iron, sell your bananas. Supply increases. Prices go down. Firms adjust their production plans to take into account the lower price and increased abundance of iron or bananas, and output goes up.

Markets don't have a single constraint because goods can substitute for each other, and consumers and firms can coordinate through the price mechanism. I can have chicken for dinner if beef is too expensive. I can design my building around concrete beams if steel beams are too expensive. Manufacturing plants (as far as I imagine) don't feature this level of substitutability. If the laser cutter is too busy, you can't just use the molding machine instead. The equipment is highly specialized.

So the question is, are software teams more like manufacturing plants or more like markets? It really depends on culture. You can have highly specialized teams, "the database team", "the cloud team", etc. and a bottleneck can build up in front of "the database team" just like a bottleneck could build up in front of the laser cutter.

Or, you can have a culture where you have "product" teams, who own and are responsible for driving all aspects of their projects end-to-end, and "platform teams" whose mandate is not to undertake the database work, the cloud work, etc. of particular projects, but is to provide and support a set of tools so that it is easy for product teams to undertake and drive this work themselves. This sort of environment is much less likely to be subject to a single constraint.

### Leadership is not bottleneck-clearing

Maybe I'm obtuse, and this was the point all along of "The Pheonix Project". You apply the theory of constraints to a dysfunctional organization until the theory doesn't apply anymore and the end result is a well-platformed engineering organization with autonomous teams that own projects end-to-end. But by my reading, advocates of The Theory of Constraints seem to think it *always* applies. The business of leaders is always to optimize the system dynamics problem and single-mindedly focus on clearing bottlenecks at *the constraint*.

I find this vision wanting. Engineering leaders, in my view, are gardeners, not bottleneck-clearers. As I wrote above, the priority of leaders should be *culture* - psychological safety, pride of workmanship, compelling narratives, and such. The Theory of Constraints is an attempt to turn leadership back into an engineering problem. I see the appeal, so many of our managers in this industry were originally engineers. But I reject it.

## Example 3: Queuing Theory

The last example I'll discuss is the acclaimed, irreverent blog post ["Work is Work"](https://codahale.com/work-is-work/) by Coda Hale. 

### Summary

Why do features take longer to ship as an organization grows, asks Hale. His story:

  * "Work capacity" only grows linearly as you hire more engineers, but
  * "Contention costs grow superlinearly" (for shared resources); and
  * "Coherence costs grow quadratically" (i.e. communication costs[^2]).

Furthermore, we know that this is the True Story of the slower pace at larger organizations. Stories about tech stack, talent level, or project management are "emic" and therefore "crap", whereas a queueing theory explanation is "etic" and therefore "a priori truth". Hale is very explicit about expecting you to grant special authority to the system dynamics analogy.

### Sanity check

Let's not be hypnotized by fancy equations, and check our experience and intuitions. Is this story actually plausible? Over the last decade or so, the company I work for grew from dozens to thousands of engineers. If tomorrow they decided to fire all the engineers except for me, this would eliminate contention costs and coherence costs. I wouldn't have to contend with anybody for the QA environment. I wouldn't need to communicate with anybody, either. Would I suddenly be able to ship my assigned feature as fast as I could have back in 2012? If Hale is right, and it's really about contention costs and coherence costs, then I should.

It would be nice to clear my calendar a bit. And it would be nice not to risk merge conflicts or code review disputes. But will this change the game? No.

Hale's story misses that the slower pace at large organizations is less about the growing size of *the team* and more about the growing size and complexity of *the codebase* and *the product*. CI takes 30 minutes to run when it used to take 3? Fire everybody, and it'll still take 30 minutes to run. Database migration takes days when it used to take minutes? Fire everybody, it'll still take days.

Features are also simply *more complicated* for a mature software product. I've [written before](http://twitchard.github.io/posts/2021-04-24-behavior-constraining-features.html) about two types of features: some features involve adding new behavior, but many features add *new constraints* on existing **and future** behavior. That is, in the early days of your product, if you want to add a "star ratings" feature, you just add the star ratings feature. In the later days of your product, you add the star ratings feature, you make sure it logs its activity properly for the "activity history" feature, you make sure it writes the data in such a way that the GDPR purger can clear it, you make sure that all text it displays goes through the internationalization system, you make sure that you've described the UI stylings for both light mode and dark mode, you make sure you are emitting events for monitoring and analytics. This has nothing to do with the number of engineers, it concerns the *number of constraintful features* that your product has accumulated. Fire everybody, and you still have to do all this work in order to have a correctly-implemented feature that preserves the invariants that users expect of your system.

### The wrong villain

Hale's advice is

  * "building high-performing organizations requires a careful and continuous search for shared resources, and developing explicit strategies for mitigating their impact on performance"
  * "limit the number of people an individual needs to talk to in order to do their job to a constant factor"

This isn't bad advice. I agree with it. I hate contending for shared resources and bureaucratic processes that require me to talk to a bunch of people. Managing these as an organization grows is *necessary* to remain productive, but far from sufficient. Resource contention and coherence costs are merely side characters: the arch-villain is **complexity**. This is obscured if you suspend disbelief, get hypnotized by fancy equations into believing a poor analogy between software teams and parallel processes. But it is immediately clear if you are an engineer at a large organization and take a simple moment to reflect on how your time is actually distributed.

There is no one way to battle complexity. But some things help. ["Make your constraints explicit, enforce them systematically"](http://twitchard.github.io/posts/2021-04-24-behavior-constraining-features.html), as I advised in that previous post. You also need to battle complexity on the fronts that Hale dismissed as "crap". Do keep a high bar for talent. Do be thoughtful about your tech stack: it's no accident that Facebook, Google, Microsoft, Stripe, and Dropbox invested in ways to bolt static type systems on top of Javascript, PHP, Ruby, and Python. Static types matter.

### Leadership is building humane organizations

Despite vastly overselling system dynamics, Hale does an admirable job combatting its tendency to over-mechanize the practice of software leadership. He writes

> That we know some of the boundaries of organizational performance and their dynamics doesn’t excuse us from using our empathy to build humane organizations. Companies are groups of people being compensated for having to spend some of their finite lifetimes not being with their partners, children, pets, or super weird hobbies. They deserve to be members of organizations which honor that time by ensuring that their work has value and meaning. There is no mathematical model to guide us to that goal.

A beautiful sentiment, and a fine way to end the post. Go in peace!

[^1]: Disclaimer: I have a lot of opinions about how software organizations should be led. I am not myself any sort of manager. So judge my argument on its merits, not on my credentials! 

    Of course, my managers seem always to be full of opinions about what their engineers should be doing. Why shouldn't an engineer have opinions the opposite way?

[^2]: This is similar to the famous argument from "The Mythical Man Month" by Fred Brooks, as [Wikipedia](https://en.wikipedia.org/wiki/The_Mythical_Man-Month#The_mythical_man-month) summarizes

    > Assigning more programmers to a project running behind schedule will make it even later. This is because the time required for the new programmers to learn about the project and the increased communication overhead will consume an ever-increasing quantity of the calendar time available. When n people have to communicate among themselves, as n increases, their output decreases and when it becomes negative the project is delayed further with every person added. 
  
    The difference is that Brooks is writing about adding engineers to a *project* whereas Hale is describing adding engineers to an *organization*.

