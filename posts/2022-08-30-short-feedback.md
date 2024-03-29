---
title: "Engineer SHORT feedback loops"
class: prose
description: "Speedy, hands-off, opinionated, reliable, timely"
quote: "speedy, hands-off, opinionated, reliable, and timely."
---

<img src="../images/dropCapI4.jpg" alt="I" class="dropCap"/> used to work on a developer productivity team. This kind of team is responsible for the maintenance and configuration of tools that developers on other teams use to do their jobs: test suites, type checkers, ci systems, linters, error trackers, bug reports, code review, code search, debuggers, logs, code coverage tools, reliability metrics, observability tools, repls, profiling tools, and so on. 

## Ideas for improving your tools

How, exactly, do you go about improving these things? Some projects are obvious "let's speed up CI builds!", but there's a bit more to creating a pleasant internal developer experience than making things go fast.

I have a little acrostic to aid in thinking of possible ways to improve internal DX. Great feedback from developer tools is SHORT: speedy, hands-off, opinionated, reliable, and timely.

* **Speedy:** this is obvious. If things are fast, they can be interactive. If you can deploy in half a minute, you can add logs and ask questions about your how your program behaves under production traffic. If it takes hours, it’s not really interactive at all. If your typechecker runs in a second, you can use techniques like deliberately introducing type errors to guide a refactor. If it takes 5 minutes, maybe you're better off with grep.

* **Hands-off:** it’s better if I don’t have to take explicit action to get feedback. I like it if my type-checker/test suite runs when I save a file, or when CI runs when I push a commit, or if my error tracker pings me on Slack when it detects a new type of error related to my deploy.

* **Opinionated:** Don’t just provide me information. Suggest the next step to me. Did a test fail? Give me the command to run it locally. Did a request 500? Give me the curl invocation to send a similar request to a development environment. 

* **Reliable:** if your tool is giving me a bunch of false positives – security “vulnerabilities” that aren’t actually vulnerabilities, 500s that don't represent actual errors – I’m just going to ignore your tool altogether. 

* **Timely:** tell me about a problem as close as possible to the moment I introduce it. If I introduced a performance regression, don’t tell me about it in a weekly report. Tell me upon pushing the commit with the regression.

## Bake well-configured tooling into your culture

I think teams generally undervalue improving their feedback loops.

Here's an example of what not to do: recently, I wanted to speed up a script. I found a magic command from the internet to generate a flame graph, I squinted at the graph, ignoring a bunch of frames from the runtime and other things out of my control, until I identified a likely candidate for speeding up. I made a change, timed the before and after, shipped it, and celebrated victory. What I did not do: I didn't check in the script for generating the flame graph. I made no attempt to automate the process of filtering out the irrelevant information, or identifying promising bottlenecks. I didn't add the ability to generate a flame graph to the CI system, nor did I set up anything to track the runtime of the script I sped up, or notify the team if it ever regressed. I didn't automate celebrating victory either. Boo me.

Here's another example: I've experienced teams at three different organizations that used [Sentry](sentry.io), an error tracking tool. Sentry can be useful even if you don't put much effort into setting it up. As long as you're sending the error data, it’s there and it's queryable, so if a user reports an error, you can find it in Sentry and get an idea of how frequent it is and when it started or stopped. But Sentry can be much more useful with a little elbow grease. If you upload source maps, you can get a stack trace that isn't nonsense. If you add some tags, you can organize errors into projects so that each team only sees the errors that are relevant to them. And if you take the time to sort through the errors, have your app stop emitting false positives, or mark them appropriately in Sentry, then you can begin responding to errors proactively, and have the tool notify you as soon as a new class of error arises and is deployed. Well, well worth it, in my view, but I’ve been places where months and months went by before anybody mustered up the willpower to get this in order (mea culpa too, obviously).

There are tradeoffs. You can't spend all day configuring your tools - you would never get anything shipped! If you’re a small team working on an experimental project, you should probably invest far less in your tools than a large team working on a long-lived project. The *mindset* is much more important than the actual state of things. Do engineers even consider improving their own feedback loops? Or do they take the state of their tooling as immutable, out of scope, somebody else’s problem? Do they celebrate teammates who improve feedback processes, or do they make them feel guilty for “stealing” time away from the project roadmap?
