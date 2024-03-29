---
title: "Software culture as proof strategies"
class: prose
description: "\"Product-driven\" means backward-chaining, \"Engineering-driven\" means forward chaining."
quote: "Are you happiest when forward chaining or backward chaining?"
---

[<u><img class="dropCap" src="../images/dropCapI3.jpg" alt="I"/>nternet</u>](https://www.uxmatters.com/mt/archives/2018/01/a-shift-from-engineering-driven-to-design-driven-business-models.php) [<u>ink</u>](https://twitter.com/sachinrekhi/status/1232412946434641920) [<u>spills</u>](https://www.productplan.com/product-culture-mistakes/) [<u>occasionally</u>](https://twitter.com/AustinTByrd/status/1104466068146335744?s=20) [<u>about</u>](https://twitter.com/tsunanet/status/1234866890670923776) a distinction between "product-driven" and "engineering-driven" software cultures. These terms are somewhat vague -- apparently companies like Google are "engineering-driven" and companies like Amazon or Apple are "product-driven," though I can't speak to that.

I'd summarize the two mentalities like this:

**Product-driven approach**

  1. ???
  2. Ship desirable feature
  3. Profit

**Engineering-driven approach**

  1. Write desirable code
  2. ???
  3. Profit

This reminds me a little bit of "backward chaining" and "forward chaining": the two basic "inference methods" that proof engines use when searching for proofs.

"Backward chaining" is when you start from the proposition you hope to prove, your "goal", and proceed by identifying "subgoals", the proof of which would amount to proving your "goal", and then identifying subgoals of those subgoals, and so forth, until you reach subgoals that can be proven directly.

For example, suppose you want to prove the proposition "Socrates is mortal"; given the following facts and rules:

* **Rule 1.** If X is a woman, then X is mortal.
* **Rule 2.** If X is a man, then X is mortal.
* **Fact 1.** Taylor Swift is a woman.
* **Fact 2.** Socrates is a man.


### Backward Chaining

With backward chaining, you start with your goal and apply rules that match your goal to generate "subgoals", i.e. goals that would prove your goal in coordination with the rule. For example

1. Our goal is "Socrates is mortal".
2. Consider rule 1, "If X is a woman, then X is mortal". This matches our goal if X = socraties.
3. Now we have a new subgoal, "If Socrates is a woman, then Socrates is mortal."
4. Oops! Looks like we're out of luck. "Socrates is a woman" doesn't seem to match any rules or facts.
5. Let's "backtrack" and consider our original goal again: "Socrates is mortal."
6. This also matches rule 2, "If X is a man, then X is mortal" if we set X = socrates.
7. We have a new subgoal, "If Socrates is a man, then Socrates is mortal"
8. This matches Fact 2, Socrates is a man!
9. Therefore, Socrates is mortal! Q.E.D!

The characteristic of "backward chaining" is you explore a lot of subgoals that would be useful if you could prove them, but that may turn out to be impossible to prove.

### Forward Chaining

So what is forward chaining? With forward chaining you don't start with a goal. You start with what you know. And then you use what you know to deduce new knowledge. And you use that new knowledge to deduce more new knowledge -- until hopefully one of the things you deduce is the goal.

So, given the same example.

1. Let's pick a rule. Rule 1: "If X is a woman, then X is mortal." Can we use this?
2. Yes! It appears to match Fact 1, "Taylor Swift is a woman."
3. Now we have a new fact. "Taylor Swift is Mortal."
4. Unfortunately that doesn't match our goal.
5. It doesn't look like we can apply Rule 1 to any other facts.
6. How about rule 2? "If X is a man, then X is mortal."
7. Yes! This matches Fact 2, "Socrates is a man".
8. Now we have a new fact: "Socrates is Mortal"!
9. Woot! This is our goal! Q.E.D!

So the characteristic of "forward chaining" is that with this approach you explore a lot of deductions that are completely valid but do not necessarily lead in any way to your goal.

---

As I mentioned, the "engineering-driven" approach to software kind of reminds me of forward chaining. When you're being "engineering-driven" your ideas about what to do next are suggested by the code itself. You know what changes are easy, or natural, or interesting code-wise. Maybe you implemented some feature with a one-to-many relationship in the database, and it occurred to you "it would be interesting if it were many-to-many". Maybe you refactored the stylings of your frontend into a common module, and you know it would just be a little bit more effort to add dark mode. Recently, as part of implementing a project, I reified the shape of a system which had been implicit into a concrete data type. And I thought, "now that I have a data structure that represent this system, I bet it wouldn't be too hard to write a function that takes two of these data structures and produces a diff, and I can use that to generate a changelog". Which is something some colleagues had spoken of and thought might be useful, but wasn't made a priority because it didn't seem worth the effort. But this sort of behavior -- any thought like "now that I have X, I bet it wouldn't be too hard to..." is forward chaining. It's looking for opportunities to move forward based on the current state of the system, not based on a product goal.

Now the "product-driven" approach, like backward chaining, is goal-directed. Leadership has an idea that will revolutionize the industry if we can pull it off. That's a goal. Or maybe somebody put together a list of the most common feature requests from users. Those are goals. The implementation comes later. Heck, who even knows if the implementation is possible under reasonable time and quality constraints? The idea comes first, and then it's up to the engineers or the software architects to come up with an implementation plan and decide whether or not it is feasible. And hopefully the implementation plan is incremental, and the project is broken up into parts -- subgoals, if you will.

Good product-driven people, of course, have a strong sense of what is feasible, and take that into account when they are choosing goals. And good engineering-driven people have a sense too of what sort of properties are valuable in a system from a product perspective, and don't go off writing random code without considering how it might plausibly lead to a desirable goal. This is much as mature proof engines don't naively backward-chain or forward-chain. They use heuristics, and are clever to pick subgoals that are more likely to be feasible when backward chaining, or to pick deductions that are more likely to lead to the goal when forward chaining.

"Engineering-driven" forward chaining can go bad: refactoring code as an end in itself. Introducing fashionable new frameworks or software paradigms just because they are cool, without a compelling product justification. "Product-driven" backward chaining can go bad too -- in a "feature factory" where software teams chase shipping feature after feature, without a mind to code or product quality.

I'm afraid I don't really have much of a point beyond introducing this analogy, and hoping you'll find it interesting. I think product-drivenness and engineering-drivenness each have their place. I think my personal nature as a software developer tends toward being more "engineering-driven" than "product-driven" -- I tend to be more engaged when I'm writing cool code for a boring reason, over boring code for a cool reason, although I consciously try to correct this and behave more "product-driven" than I would otherwise.

But my feeling is that what seems to be the "default" software culture undervalues "engineering-drivenness" somewhat. I wrote in my [last post](2020-03-28-against-process.html) about a mentality bent on systematizing software teams, that sees software teams like priority queues, and the central problem in software as assigning the highest priorities to the tasks with the highest expected net value. In that sort of paradigm, the goals are known, and so "product-driven" backward chaining is favored.

A different mentality wants software teams to be more organic. Software isn't always the pursuit of known goals -- often it is highly exploratory in nature. In this paradigm, the goals are unknown, so "engineering-driven" forward chaining is more favored.

So that's my take on "product-driven" vs "engineering-driven" software cultures. What about you? Are you happiest when forward chaining or backward chaining? Were your team's biggest or most surprising successes the result of forward chaining or backward chaining? Something to think about in the next team planning session.
