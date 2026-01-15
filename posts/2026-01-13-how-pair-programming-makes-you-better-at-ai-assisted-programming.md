---
title: "Want to get better at code agents? Try pairing with a human."
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

There's skill to using coding agents effectively. As a trivial example, you will achieve greater success sooner with prompts like

> I ran `command` and got `output`, might be a parse error is getting swallowed in the controller? Improve the error experience here and then fix the immediate problem.

than with

> fix this error `[paste]`

Being skilled at using LLMs to code involves, among others, the following skills:

1. Articulating problems
2. Presenting context
3. Creative dialogue
4. Frontloading the tricky stuff

As it happens, these are all skills you use and develop when pair programming. For the past ten years I've spent something like three hours a week pair programming (usually over Zoom) with colleagues. In this post I'll describe lessons and skills I gained from this practice, and then explain how they have made me a more effective user of coding agents, like Claude Code, Cursor, and Codex.

### Articulating problems

When you solo program, you can translate thought directly into code. Pair programming, especially when you are "navigating" and your pair is "driving", involves the additional step of putting your thoughts into words. This skill has a high ceiling. I can much better express specific ways I want code to change than I could ten years ago.

Some of this is vocabulary. There are lots of code actions you can refer to more effectively if you (and your pair) have the right words: "DRY this up", "inline that function", "parameterize that expression over X", "that error is getting swallowed", "can we reify the Y behavior", "defunctionalize the continuation here, please". (Someday I plan to publish a glossary with my favorite software-related vocabulary).

Articulating ideas about code is tremendously useful for AI-assisted coding, too. When the right word for an idea rolls off the tongue this can turn minutes of demonstrating by example into seconds of typing the right sentence.

Programming solo, with or without an agent, won't really improve your articulative abilities. Reading helps some. By far the best way[^1] to improve your code vocabulary and your ability to apply it is to pair program with bright colleagues.

### Presenting context

When you pair program, especially if you're leading, you have to keep track of another mind. What does your pair already know about the problem? What information are they missing? What is the most time-efficient way to catch them up?

This has a lot in common with keeping track of a coding agent's context. What have you already told it? What files has it already read and understood? Does it understand your broader goal here, or only the immediate task?

It is much better to practice this skill with a human than an AI assistant. If you have provided context poorly, your human pair will tell you -- if not directly in words, then in pattern of speech and tone of voice -- whereas an AI will happily plug along making guesses about your meaning, reading files willy-nilly from the codebase in the hopes that something there will provide the missing insight and allow it to suss out your intent. Lots of the time, it will actually succeed, too, or halfway succeed, and then unless you're paying close attention to the trace, you will never become alerted to the fact that you could improve. Even if the agent fails and does the wrong thing, you might chalk it up to a shortcoming in the AI and not your own failure. Thus, pairing with a human can be better practice for using AI than using AI is.

### Creative Dialogue

Solving most code problems is usually a straightforward application of experience and elbow grease, but every once in a while you encounter a problem that requires unusual creativity or particularly careful judgement. If I hit a problem like this while pair programming, we will begin to ask questions starting with "why is..." or "why don't we..." or "what if..." We have to take a step back and actually think creatively.

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

My thesis -- that agents work better with input derived from human-grade articulation, contextualization, dialogue, and frontloading strategy -- is based on anecdote and observation, not experiment. I believe they make a difference for the time being, but it could be that agents eventually improve in such a way that really the most time-efficient way to prompt them will be merely to grunt vaguely in the direction of something that needs improvement.

But we're not there yet! For now, keep yourself sharp. Go ask your teammate to pair.

[^1]:  This is true for me, and I think the majority of engineers who can pair program enjoyably and productively. Some people just don't thrive when pairing, and that's ok!
