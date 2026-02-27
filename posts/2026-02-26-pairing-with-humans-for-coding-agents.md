---
title: "Want to get better at coding agents? Try pairing with a human."
draft: false
class: prose
description: "Lessons from a decade of pair programming that transfer surprisingly well to working with coding agents"
quote: "Pairing with a human can be better practice for using AI than using AI is"
thumbnail: "https://twitchard.github.io/images/dropCapPairProgramming.png"
---

<div class="epigraph">
<p>Iron is sharpened by iron, one person sharpens another.</p>
<cite>— Proverbs 27:17</cite>
</div>

<img src="../images/dropCapPairProgramming.png" class="dropCap only-light-mode" alt="Two people pair programming" /><img src="../images/dropCapPairProgrammingDark.png" class="dropCap only-dark-mode" alt="Two people pair programming" />There's skill to using coding agents effectively.

Being skilled at using LLMs to code involves, among others, the following skills:

1. Listening
2. Articulating
3. Contextualizing
4. Creative dialogue
5. Frontloading the tricky stuff

As it happens, these are all skills you use and develop when pair programming. For the past ten years I've spent something like three hours a week pair programming (usually over Zoom) with colleagues. In this post I'll describe lessons and skills I gained from this practice, and then explain how they have made me a more effective user of coding agents, Claude Code, Cursor, Codex, etc.

## Listening

Epictetus said "you have two ears and one mouth so that you can listen twice as much as you speak".[^1]

LLMs are huge blatherers compared to most humans, so you shouldn't pay attention to every word they say, you can skim. LLMs also don't mind if you interrupt them and force them to re-explain in a way you like better. So on the surface, *listening* to an LLM looks very different (and much ruder than) *listening* to a human.

But true listening is an interior act. It is adopting a certain disposition. Inwardly, there is not much difference between listening to a person or to an LLM. You put yourself and your own ideas temporarily aside. You open yourself, and let words from outside change you.

It is much harder to seriously listen to an LLM than it is to listen to a person. For me, at least, I have people-pleasing instincts. I have strong motives to listen to other people and to take their ideas seriously, because if I do that, I will make them feel good and they will like me better. Alas, I don't care about making LLMs feel good. Might pose a problem when they overthrow us.

But if you form good listening *habits* by pairing with your human colleagues, this will carry over and you will be able to orient yourself to listen effectively and learn from LLMs as well.

### Articulating

When you solo program, you can translate thought directly into code. Pair programming, especially when you are "navigating" and your pair is "driving", involves the additional step of putting your thoughts into words. This skill has a high ceiling. I can much better express specific ways I want code to change than I could ten years ago.

Some of this is vocabulary. There are lots of code actions you can refer to more effectively if you (and your pair) have the right words: "DRY this up", "inline that function", "parameterize that expression over X", "that error is getting swallowed", "can we reify the Y behavior", "defunctionalize the continuation here, please", "let's expose a seam here for testing"[^2]. (Someday I plan to publish a glossary with my favorite software-related vocabulary).

Articulating ideas about code is tremendously useful for AI-assisted coding, too. When the right word for an idea rolls off the tongue this can turn minutes of demonstrating by example into seconds of typing the right sentence.

Programming solo, with or without an agent, won't really improve your articulative abilities. Reading helps some. By far the best way to improve your code vocabulary and your ability to apply it is to pair program with bright colleagues[^3]

### Presenting context

When you pair program, especially if you're leading, you have to keep track of another mind. What does your pair already know about the problem? What information are they missing? What is the most time-efficient way to catch them up? This has a lot in common with keeping track of a coding agent's context. What have you already told it? What files has it already read and understood? Does it understand your broader goal here, or only the immediate task?

There are some differences in *mechanics*. To give a coding agent context, you need to give it the barest hint of a direction it can follow, whereas with a person, you have to explain things inline, or point them in a direction and come back later.

The advantage of practicing this skill with people, rather than just LLMs, is that people make it very clear when you have provided context poorly -- if not directly in words, then in pattern of speech and tone of voice. Coding agents happily plug along making guesses about your meaning, reading files willy-nilly from the codebase in the hopes that something there will provide the missing insight and allow it to suss out your intent. Lots of the time, it will actually succeed, too, or halfway succeed, and then unless you're paying close attention to the trace, you will never become alerted to the fact that you could improve. Even if the agent fails and does the wrong thing, you might chalk it up to a shortcoming in the AI and not your own failure.

### Creative Dialogue

Solving many code problems is a straightforward application of experience and elbow grease. At other times you encounter a problem that requires unusual creativity or particularly careful judgement. If I hit a problem like this while pair programming, we will begin to ask questions starting with "why is..." or "why don't we..." or "what if..." We have to take a step back and actually think creatively.

Being creative with a partner is a *different skill* than being creative solo. If I want to be creative solo, I [take a shower](https://medium.com/engineering-livestream/on-showers-golang-and-creativity-2230b0b97d78), relax, and let my mind explore various trains of thought. Being creative with a partner is argument, skepticism, entertaining ideas you are resistant to, hypothesis, antithesis, synthesis. To do this well, you have to learn to put aside your preconceptions so you can truly open yourself to ideas from somebody else, but on the other hand you need to stay critical so you can apply your own perspective.

You can have creative dialogue with an AI assistant, too, but you have to explicitly set it up. Coding agents have a strong bias towards *making progress*, they like to just go off to try and work in complete iterations. Even in "plan mode" they can try and do all the thinking and maybe give you a little questionnaire after the fact so you feel included.

There's also a meta-level to this. If you have a good sense for when a problem is hairy and really needs careful thought, especially if you have tokens to spare, you can put your agent on the highest reasoning level, spin off several subagents, instruct them each to pursue different lines of thinking, have them debate and synthesize, instruct them to check their assumptions, etc. etc. Basically, take your skill for creative dialogue and put it into a prompt.

AI is much inferior to humans for practice here. When an AI is wrong it will still confidently spout nonsense to you, but when you challenge them, they will sycophantly just yield to your point of view. They can still be useful partners, they can take your thought to places you could never reach alone, but you have to take them with a grain of salt -- and it helps a lot the more experience you have doing this type of discussion live with humans.

### Frontloading the tricky bits

Especially when I'm pairing with a more junior developer, I apply some techniques to try and tackle the interesting, difficult parts of a problem first. This allows me to provide (impose?) maximum direction on what my pair is working on, and reduces the likelihood of somebody asking for rework later when there's code review.

One such technique is TDD -- writing the tests first -- and another is the other TDD -- writing the *types* (plus function stubs with type signatures) first. Both techniques allow you to start specifying details about the *whole approach* sooner than you could if you just dive into implementation. You can also temporarily hardcode data or implementations -- there's a whole art to setting up clever feedback loops from types, tests, logs, debuggers, even agents, in order to tackle things in a different order.

Frontloading the tricky bits can also be useful for agents. Especially having the agent start with type definitions. I do this all the time. I get the results I want much more quickly versus when I just hand the agent the problem and then say "no, I want X", "no, I want Y". You want to iterate as much as possible on a smaller artifact that captures the essential details of the whole implementation.

## Substitutes and Complements

The first time I screenshared and shared my editor with advanced voice mode on ChatGPT desktop, my instinctual reaction, conditioned by all the rhetoric about AI replacing humans, was "guess I should start pair programming with the AI more and stop pairing with humans as much",  but on reflection I do not think this correct at all. To use the economics jargon, AI pairing is a *complement* to human pairing, not a *substitute*. In the generative AI age, you should pair program with AI more **and** with humans more. What you should do less of is solo programming. (And of course, nothing prevents you from getting on a Zoom with a colleague and prompting the AI together. This is a great way to spread AI tools knowhow.)

## Postlude: uh oh I got ai-pilled

I wrote the original draft of this post in January. Two things have changed since then:

1. I joined Ramp. Tokens aren't scarce for me, now.
2. 2026 Opus, Codex, and Gemini are just waay better. [^4]

Before, AI was a tool I used to help me more quickly write the code I was already going to write. Now, AI is more like a partner I am using to discover what sort of code should be written in the first place. I barely open Vim now. I've got agents using agents using agents.

My first day at the new job I realized the budget prompting habits I had developed were drastically different from the habits of my colleagues who had been living in this brave world, in a world where tokens are abundant and *your time* is scarce. So, I held off on publishing. What did I know about anything?

One month in to the token-rich lifestyle, I'm not the Leonard Bernstein of conducting multi-agent coding symphonies, but I've had a chance to get the lay of the land. And I'm comfortable enough to confidently stand by everything that I wrote.

It is still true that listening, articulating, contextualizing, dialectic, and derisking are the skills you need to get the most out of your agents.

It is still true that building something together with a human partner is the best way to sharpen these skills. The handful of Zoom sessions I've had prompting AI together with [Austin Ray](https://x.com/austospumanto), the head of AI DevX at Ramp, are the upskillingest hours I've had in years, to coin a term.

Someday soon the day will come when the most time-efficient way to prompt them will be merely to grunt vaguely in the direction of something that needs improvement, no-skill-necessary. But I don't think we're there yet. For the time being, agents perform much better with a thoughtful, articulate, knowledgeable, dialectical, strategic human at the helm. So keep yourself sharp! Go ask your teammate to pair.

[^1]: Always be skeptical of arguments from anatomy, though. Aristotle, for instance, believed that we so often sneeze twice in quick succession because we have two nostrils.
[^2]: I learned "seam" recently from paying attention (viz. listening) to Codex's model output when I was writing some tests. See https://martinfowler.com/bliki/LegacySeam.html
[^3]: I think this is true for a lot of people at least. Some people never take to pair programming.
[^4]: Karpathy [put it well](https://x.com/karpathy/status/2026731645169185220): "imo coding agents basically didn't work before December and basically work since - the models have significantly higher quality, long-term coherence and tenacity and they can power through large and long tasks, well past enough that it is extremely disruptive to the default programming workflow."
