---
title: "Why I'm not a Terminal Guy Anymore"
class: prose
description: "A jaded software engineer has never forgiven GUIs for what they did to him as a child. But in the age of coding agents, has he learned to hold his nose?"
quote: "It is not lightly I say that coding agents are just better with a GUI."
draft: false
thumbnail: https://twitchard.github.io/images/opengui.jpeg
---

<img src="../images/dropCapW.png" class="dropCap" alt="W" />hen I was 5, the family computer ran DOS. My teenage older brother had written a script so I could type "games", press enter, and then there would be a numbered selection of all the games on the computer. For me, this was the perfect UX.

One terrible day, the powers that be installed Windows 3.1. I was devastated.

So do not question my legitimacy as a Terminal Guy™. I am dyed in the wool. I have [written lovingly about](https://twitchard.github.io/posts/2023-01-18-unicycles.html) my Vim, my Tmux, etc. I have a video of my phone of my son at 2 saying "open up Vim, open up Vim" in front of the fake laptop at IKEA. It is not lightly I say that coding agents are just better with a GUI. (I use both ChatGPT Desktop and Cursor).

This comes down to two things:

1. GUI is better for reading prose than the terminal.

2. GUI is easier to keep organized than the terminal.

## Reading

Proportional fonts are way better for reading than monospace fonts. There's a reason print books use monospace fonts. There's a reason that's the browser default.

They give you something like 20% more real estate. Imagine a UI with a useless block that takes up 20% of your screen.

Subjectively, I find proportional more comfortable to read. Objectively, I searched a little bit and it seems that the science thinks we can decode monospace fonts just as fast as proportional fonts. So alas, I cannot beat you over the head with my opinion using Science™.

Monospace has its advantages for code: alignment, giving proper emphasis to punctuation characters — but I write code by hand far less than I write prose to coding agents, and far, far, far less than I *read* prose by coding agents because they are insufferable blabbermouths. So sign me up for 20% more words that fit without scrolling, please.

## Scrolling

Speaking of scrolling, another point in favor of GUI.

I hate scrolling back in these terminal agent sessions. Not sure exactly why — it feels like I'm always losing my place. And the agent always blathers so much that my window only shows the last 10% or 20% of the response and I always have to be scrolling back up to the part where the response begins, and then I'm always missing that and scrolling too far.

I never really had a problem scrolling bash sessions in the terminal — perhaps because the output of bash commands is a lot more visually heterogeneous than paragraph after paragraph of AI prose?

In the GUI, you have the scrollbar of course. I lose my place less. And the ChatGPT app has these brilliant little tick marks so I can peek through and navigate to the *user messages* in the chat.

Screenshot:
![codex-ticks](../images/codex-ticks.png)

## Organization

I really like having a little sidebar where I can see what sessions I have and which ones need my attention.

Before that I was splitting tmux panes, promoting them to their own windows, and naming tmux sessions manually with single-word names in the sidebar at the bottom. This scaled comfortably to me having 4 somewhat active sessions; inactive sessions I just had to kill and ~forget about. With my GUIs I typically have about five somewhat active sessions but also ten or so inactive sessions that I'm still thinking about occasionally.

The sidebar paradigm is just better, especially in a world where sessions are spinning up other sessions and communicating with them.

* Caveat: I should probably try cmux. I have not.
* Caveat: The claude TUI was just starting to add features related to session organization back in June when I switched to GUIs. Maybe it's good now?

Another thing I get a lot of mileage out of is Codex "deeplinks", e.g. if I click on a link to `codex://threads/017045c6-ef46-7374-8200-b1b97322d4c8` it will focus that particular session. This is useful when my agents are writing Slack messages to me, or when they are rendering custom `.html` for me to look at.

## The future

Would I ever switch back to doing things in the terminal?

I think if there really were the agent chat equivalent to Vim — "you're going to invest a little bit in learning this 'language' of different composable agent management primitives and loading it into your muscle memory, and after that you will feel like a leet haxor" — that would be pretty compelling to me. But [as blogger Charalampos Kardaris argues](https://ckardaris.com/blog/2026/08/28/keyboard-driven-guis.html), there's no reason such keyboard-driven interfaces would have to be TUIs as opposed to GUIs.

On the other hand, I really hope (and expect) that agent management will just die. My ideal is a single chat where I can stream-of-consciousness (via conversational voice), have things automatically routed to the right context, and there's an agent controlling some rich UI surface (a browser? my entire desktop?) so I can observe results in a high bandwidth way.

Terminal doesn't seem the likely place for this to arrive.
