---
title: For serious projects, don't use Bash, use... what? 
class: prose
description: "Analyzes several general-purpose languages' suitability for doing 'shelly' things"
draft: "true"
---

# Which general-purpose programming language is the best alternative to shell scripting?

<img class="dropCap" src="../images/dropCapS.png" alt="S"/>S</span>ometimes, I need to write a program whose main job is to run other programs.

For this, I often choose to write a Bash script. Bash makes it easy to run other programs, and the Bash prompt is this amazingly powerful interactive tool that many programmers are just kind of accidentally familiar with. You, dear reader, likely have a bash prompt running right now, open in another window!

But the conventional wisdom is that, while Bash is great for one-offs and experiments, for sufficiently serious projects, you should probably use a general-purpose programming language instead, where it's easier to write modular, testable, well-abstracted code.

But which one? Does there exist a general-purpose programming language with similar advantages to Bash, but fewer gotchas? Let's explore!

### Bash's strengths

Any viable Bash substitute will need to share Bash's strengths. What are Bash's strengths? I would list:
  - **Execution ergonomics**: it's easy to run external programs in Bash. In particular, bash has:
      * Lightweight syntax for running programs.
      * Single-character pipes/redirects `|`, `>`, etc.
      * Command substitution
  - **Interactive Development**: Bash has a great REPL that everybody already has open.
  - **Familiarity**: Again, everybody already has a Bash prompt open.
  - **Flexible package management**: AKA `$PATH`

### The contenders

I'm going to consider

  - **Dynamic languages**
    - Javascript (node.js)
    - Ruby
    - PHP
    - Python
    - Perl
    - Clojure
  - **Static Languages**
    - Groovy
    - Haskell


Occasionally, I need to write a program whose job is mainly to run other programs and combine their results. For me, this usually begins as a Bash script.

Bash has two great advantages. One: ergonomics. Want to run a program? Just type its name! Want to send its output to another program? Just ‘|’. Want command substitution? Backticks or dollar-parens, take your pick!

Advantage two: it's everywhere!. Every time I open a terminal, there's Bash! Most everyone with a terminal has some degree of fluency in Bash. Paste it to a colleague, and they will understand exactly how to run it. In fact, before you're done thinking they’ve probably already pasted it into their already-open terminal.

The bash prompt is a powerful development environment that many programmers are just kind of accidentally proficient in. Google “repl-driven development” and the results will tell you about a programming language called Clojure
with a good REPL story, and how that makes for a delightful, interactive, and productive experience. But REPL-driven development is common with Bash, too! The experience of writing Bash is generally more interactive than writing the typical general-purpose language, I would say. 

As a tool, Bash is marvelous. Unfortunately, as a programming language, Bash is not marvelous. It is quite limited. In particular there are lots of gotchas when it comes to whitespace, argument expansion, string escaping and so forth. And it's also a bit disappointing in the data structure department. Arrays are weird, and it don't really have anything like structs or objects. I’ll skip the details. Plenty had been written about this elsewhere, and the conventional wisdom seems to be that if you're writing something sufficiently serious, you should probably avoid bash and use s general purpose programming language. But which language? 
