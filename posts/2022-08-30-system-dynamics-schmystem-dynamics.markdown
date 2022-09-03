---
title: "Software teams aren't system dynamics problems"
class: prose
description: "Queuing theory and stocks-and-flows diagrams are mere analogies"
draft: true
---

I have [ranted previously](2020-03-28-against-process.html) against scrum-like practices, e.g. grooming the backlog, and ascribed them to a flawed, implicit mental model of "software teams are job schedulers". 

The more sophisticated version of "software teams are job schedulers" is "software teams are system dynamics problems". You actually see this stated explicitly quite a bit: software thought leaders attempting to use [queueing theory](https://www.lostconsultants.com/2019/11/20/littles-law-applied-in-agile-software-development/), [diagrams](https://lethain.com/systems-thinking/), and [equations](https://codahale.com/work-is-work/), [even](https://lethain.com/limiting-wip/) [simulations](https://twitter.com/michelgrootjans/status/1431653674024046593) to make arguments about software engineering organizations. I understand this: we're engineers. We like to build things. A system dynamics model lets you argue by building something. 

I like this style of argument. It's explicit, engaging. It can be visual, or even interactive! Some of the best, most thoughtful writing about software teams comes from people arguing in this style.

But! The trouble is when we give credence to an argument from a system dynamics model because its framing appeals to our aesthetic tastes, not because the story it tells about software engineering is actually plausible in light of our experience and knowledge.

How about an example? Take [this post](https://lethain.com/systems-thinking/) by Will Larson (author of "An Elegant Puzzle", which I recommend). He draws a stocks and flows diagram,

![](dev-velocity-sys.png)

and then argues

> If your model is a good one, opportunities for improvement should be immediately obvious, which I believe is true in this case. However, to truly identify where to invest, you need to identify the true values of these stocks and flows! For example, if you don’t have a backlog of ready commits, then speeding up your deploy rate may not be valuable. 
 
The first time I read this post, I went googly-eyed at the diagram and nodded along to this analysis. But something is clearly wrong here. Imagine you are a solo developer, and deploys take an hour. You won't build up a backlog of commits. Does this mean speeding up deploys to 1 minute is valueless? That's crazy talk! Speed up your deploys and you have gained a super power: the ability to interactively ask questions of your production environment, e.g. add a quick log statement to get a sample of the values a variable has under production traffic.

The stocks-and-flows diagram says nothing about this superpower. To the stock-and-flows diagram, the only value of deploys is that they convert the stock of ready commits to the stock of deployed commits. The stocks-and-flows diagrams knows nothing about developer workflows or time-sensitive information. It knows stocks - quantities that accumulate, and it knows flows - rates of change - and the concept of "interactivity" doesn't fit neatly into either concept.




The trouble is, even though almost anything can be modeled as a stock or a flow, modeling it as a stock or flow that interrelates with other stocks and flows won't necessarily capture what's *important* about it.




* Psychological safety ->
* Knowledge of customer ->
* Compelling narratives ->
* Positive team sentiment ->
* Belief in mission ->
* Well-framed ideas ->
* Tenure ->
* Pride of workmanship ->





In [building software is not a job scheduling optimization problem](TODO), I argued that, tl;dr "prioritizing the backlog" doesn't really do much good, and that people only believe it does because, perhaps unconsciously, they subscribe to a bad analogy between software teams and job scheduling engines. 

I think more generally, software people are much too willing to think about people in the same ways that they think about software. They give too much credence to analogies between human systems and systems we study in computing.


Momentum.
Cross-pollination of ideas.
Pride of workmanship.
Retention
Gelled-ness of a team.
Motivation.
Psychological safety.



