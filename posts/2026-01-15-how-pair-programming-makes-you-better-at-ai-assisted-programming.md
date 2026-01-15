---
title: "The secret to mastering coding agents? Pair programming."
draft: true
class: prose
description: "Lessons from a decade of pair programming that transfer surprisingly well to working with coding agents"
quote: "Pairing with a human can be better practice for using AI than using AI is"
thumbnail: "https://twitchard.github.io/images/pair-programming-ai.png"
---

<div class="epigraph">
<p>Iron is sharpened by iron, one person sharpens another.</p>
<cite>— Proverbs 27:17</cite>
</div>

## Skill issues

Some developers are better at using coding agents. I was confused -- and a little frustrated -- the first time I saw somebody struggle with getting an agent to help them. "Just talk to it like you would onboard another developer to your problem, come on!" I thought.

But on reflection I've realized this isn't something you can "just" do. It's a set of skills that take practice. I just happened to have had this practice already.

I took pretty naturally to coding agents, and I credit one simple thing for this: over the past ten years I have probably averaged something like three hours a week pair programming with colleagues. Pair programming, it turns out, is the perfect way to practice the same skills that make you good at coding agents. I believe it's even better practice for coding agents than using coding agents themselves.

In this post, I'll write a little bit about some specific skills I have gained from pair programming and describe how they transfer to coding agents. These skills are:

1. Articulating problems
2. Presenting context
3. Creative dialogue
4. Frontloading the tricky stuff

A quick aside: some people just hate pairing and will always hate pairing. Completely valid -- you can stop reading. If you enjoy it or are neutral, read on -- let me convince you to do it more!

### Articulating problems

When you solo program, you translate thought directly into code. Pair programming forces you to put your thoughts into words, which is an important skill for using agents. When the right word for an idea rolls off the tongue this can turn minutes of demonstrating by example into seconds of typing the right sentence.

This skill has a high ceiling. I was not good at it ten years ago. I would often have ideas or code changes that I understood in my head, but struggled to explain them clearly to another person in any other way than just writing out the code myself. I have improved at this, and I am still improving. (Sometimes when I'm "navigating" I still basically try to boss my pair around like they are Vim, not great).

Some of this is vocabulary. There are lots of code actions you can refer to more effectively if you (and your pair) have the right words: "DRY this up", "inline that function", "parameterize that expression over X", "that error is getting swallowed", "can we reify the Y behavior", "defunctionalize the continuation here, please". (Someday I plan to publish a glossary with my favorite software-related vocabulary).

Programming solo, with or without an agent, won't really improve your articulative abilities. Reading helps some. But by far the best way I have found to improve my code vocabulary and recall has been to pair program with bright colleagues.

### Presenting context

Here is an example of a type of prompt I call a "grunt":

> the sync script is broken

Contrast this to a different prompt that provides a lot more direction: 

> I ran `[command]` and got `[output]`, might be a parse error is getting swallowed in the controller? Improve the error experience here and then fix the immediate problem.

Part of using coding agents well is being able to judge when it's OK to grunt, and you will get results faster by providing more direction. I think of this as having a good "theory of mind" for the coding agent. What have you already told it? What files has it already read and understood? Does it understand your broader goal here, or only the immediate task? What exactly was in the CLAUDE.md? Should you summarize the way things work, or should you just point it at a couple of files that will give it the gist?

When you pair program, you have to keep track of another mind. What does your pair already know about the problem? What information are they missing? Have they misunderstood something? What is the most time-efficient way to catch them up?

It is much better to practice this skill with a human than an AI assistant. If you have provided context poorly, your human pair will tell you -- if not directly in words, then in pattern of speech and tone of voice -- whereas an AI will happily plug along making guesses about your meaning, reading files willy-nilly from the codebase in the hopes that something there will provide the missing insight and allow it to suss out your intent. Sometimes it will actually halfway succeed, and then unless you're paying close attention to the trace, you will never become alerted to the fact that you could improve. Even if the agent fails and does the wrong thing, you might chalk it up to a shortcoming in the AI and not your own failure. Thus, using AI won't always give you the feedback you need to improve at using AI.

### Creative Dialogue

Every once in a while you encounter a problem that requires unusual creativity or particularly careful judgement. If I hit a problem like this while pair programming, we will begin to ask questions starting with "why is..." or "why don't we..." or "what if..." We have to take a step back and actually think creatively.

Being creative with a partner is a *different skill* than being creative solo. If I want to be creative solo, I [take a shower](https://medium.com/engineering-livestream/on-showers-golang-and-creativity-2230b0b97d78), relax, and let my mind explore various trains of thought. Being creative with a partner is more like attaching my mind like a caboose to my partner's selected train of thought, and alternating and letting them do the same. It's the skill of dialogue.

You can have creative dialogue with an AI assistant, too, but you have to explicitly set it up. Coding agents have a strong tendency to just go off to try and work in complete iterations. Even in "plan mode" they go try and do all the thinking and maybe give you a little questionnaire after the fact so you feel included.

In any case, creative dialogue is a skill, or perhaps two skills: the ability to put aside your preconceptions so you can really listen to what your partner is saying, and on the other hand the ability to listen openly but critically to what your partner is saying.

AI doesn't provide as good practice as a human, here. When an AI is wrong it will still confidently spout nonsense to you, but when you challenge them, they will sycophantly just yield to your point of view. They can still be still useful partners, they can take your thought to places you could never reach alone, but you have to take them with a grain of salt -- and it helps a lot the more experience you have doing this type of discussion live with humans.

### Frontloading the tricky bits

Especially when I'm pairing with a more junior developer, I apply some techniques to try and tackle the interesting, difficult parts of a problem first. This allows me to provide (impose?) maximum direction on what my pair is working on, and reduces the likelihood of somebody asking for rework later when there's code review.

One such technique is TDD -- writing the tests first -- and another is the other TDD -- writing the *types* (plus function stubs with type signatures) first. Both techniques allow you to start specifying details about the *whole approach* sooner than you could if you just dive into implementation. You can also temporarily hardcore data or implementations -- there's a whole art to setting up clever feedback loops from types, tests, logs, debuggers, even agents, in order to tackle things in a different order.

Frontloading the tricky bits can also be useful for agents. Especially having the agent start with type definitions. I do this all the time. I get the results I want much more quickly versus when I just hand the agent the problem and then say "no, I want X", "no, I want Y". You want to iterate as much as possible on a smaller artifact that captures the essential details of the whole implementation.

## Substitutes and Complements

The first time I screenshared and shared my editor with advanced voice mode on ChatGPT desktop, my instinctual reaction, conditioned by all the rhetoric about AI replacing humans, was "guess I should start pair programming with the AI more and stop pairing with humans as much",  but on reflection I do not think this correct at all. To use the economics jargon, AI pairing is a *complement* to human pairing, not a *substitute*. In the generative AI age, you should pair program with AI more **and** with humans more. What you should do less of is solo programming. (And of course, nothing prevents you from getting on a Zoom with a colleague and prompting the AI together. This is a great way to spread AI tools knowhow.)

## Caveat
This is all based on personal experience and observation, not experiment. I believe that these skills make a difference in how effectively you can use agents for the time being, but it could be that agents eventually improve in such a way that really the most time-efficient way to prompt them will always be merely to grunt vaguely in the direction of something that needs improvement. But we're not there yet! For now, keep yourself sharp. Go ask your teammate to pair.

