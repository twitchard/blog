---
title: "Engineer SMART feedback loops"
class: prose
description: "Speedy, hands-off, opinionated, reliable, timely"
---

I used to work on a developer productivity team. This kind of team is responsible for the maintenance and configuration of tools that developers on other teams use to do their jobs: test suites, type checkers, ci systems, linters, error trackers, bug reports, code review, code search, debuggers, logs, code coverage tools, reliability metrics, observability tools, repls, profiling tools, and so on. 

How, exactly, do you go about improving these things? Some projects are obvious "let's speed up CI builds!", but there's a bit more to creating a pleasant internal developer experience than making things go fast.

I have a little acrostic to aid in thinking of possible ways to improve internal DX. Great feedback from developer tools is SHORT: speedy, hands-off, opinionated, reliable, and timely.

* **Speedy:** this is obvious. If things are fast, they can be interactive. If you can deploy in half a minute, you can add logs and ask questions about your how your program behaves under production traffic. If it takes hours, it’s not really interactive at all.

* **Hands-off:** it’s better if I don’t have to take explicit action to get feedback. I like it if my type-checker/test suite runs when I save a file, or when CI runs when I push a commit, or if my error tracker pings me on Slack when it detects a new type of error related to my deploy.

* **Opinionated:** Don’t just provide me information. Suggest the next step to me. Did a test fail? Give me the command to run it locally. Did a request 500? Give me the curl invocation to send a similar request to a development environment. 

* **Reliable:** if your tool is giving me a bunch of false positives – security “vulnerabilities” that aren’t actually vulnerabilities, 500s that don't represent actual errors – I’m just going to ignore your tool altogether. 

* **Timely:** tell me about a problem as close as possible to the moment I introduce it. If I introduced a performance regression, don’t tell me about it in a weekly report. Tell me upon pushing the commit with the regression.
