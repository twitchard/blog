---
title: "Take your pragmatism for a unicycle ride"
class: prose
description: "The critical resource is not *developer time*, it's *developer energy*"
quote: "Sometimes the tool that brings the best results isn't the tool that is \"best\" on the practical merits"
thumbnail: https://twitchard.github.io/images/clown-unicycle.png
retweet: "https://twitter.com/twitchard/status/1615919994755235844?s=20&t=wZSGABvjNCxq6XTmZUG7fA"
reddit: "https://www.reddit.com/r/programming/comments/10fs360/take_your_pragmatism_for_a_unicycle_ride"
---

## The thrill of unicycling
![W](../images/dropCapW.jpg){class="dropCap"}hen
I was a teenager, my parents bought my little brother a unicycle. It stayed unused in the garage for a year, but the next summer I decided I would learn to ride it.

The unicycle is not a very *pragmatic* form of locomotion. In a race against a bicycle, it will lose. It's slower, less efficient, and more difficult to use. Yet that ridiculous little thing took me further that summer than a bicycle would have. I spent many an afternoon unicycling by the creek or across town. There's a thrill to riding the unicycle, a *connection to the wheel* that isn't quite matched by anything else.

**The moral:** sometimes the tool that brings the best results isn't the tool that is "best" on the practical merits. How a tool makes us *feel* can completely overshadow the actual technical characteristics of the tool. A unicycle is better than a bicycle, because I wouldn't have used the bicycle.

This is true of recreational equipment, and it's also true of software tools[^1].

<center>
![](../images/clown-unicycle.png){style="width:300px; margin-bottom: 0;"}
<p style="font-size: 8pt; margin-top: 0">Image generated by Dall-E</p>
</center>

## The thrill of Vim

I am a Vim user. Eight years ago when I adopted Vim, I bought a bunch of hype about how modal editing was revolutionary, how powerful the composable "modifier-noun" Vim "language" is, how mastering Vim would make me so much more efficient at editing code. In the years since, I've learned that Vim isn't necessarily a superpower. Once in a blue moon I'll bust out some Vim magic and blow somebody's mind, but so far as I've observed, there isn't too much variation in the rate that experienced developers, whatever their editor, are able to edit their code, once they get going.

These days, Vim is valuable to me for a different reason. There's a thrill I get from using Vim, somewhat like a unicycle ride. There's something addictive about being able to cause so much to happen with so few keystrokes. Everything feels so immediate. You feel connected to the text. My `.vimrc` makes my editor feel like a home: a place I've made my own. Does Vim actually does help me code faster? That's not so important. Far more important is that the attitude I have towards my editor has turned the mundane act of editing text from something draining into something that gives me energy, and I am a more effective developer for it. Like the unicycle made me more disposed to spend an afternoon cycling instead of sitting at the computer, Vim makes me more disposed to dive in and engage with the code, rather than to sit around and dither.

Vim is only one of my unicycles. I also use a very custom desktop Linux. I run NixOS and use a wonderful project called [home-manager](https://github.com/nix-community/home-manager)[^2] which is really a dream for any enthusiast of quirky software. Through home-manager, I configure a tiling window manager (XMonad), a custom keyboard layout (Programmer Dvorak)[^3], a very custom Bash and Tmux, and so forth. All these tools promised that, in exchange for some effort up front to configure and learn, they will save me time and make me a more efficient developer. I'm a sucker for this line. Mostly, things don't live up to the efficiency hype. In terms of time savings, I probably recover nowhere near the time I put into this stuff. But what I get out of it is energy. Even after all these years, there's this surge of excitement and a feeling of coming home I get when opening my personal laptop. I feel nothing like this when I open my work laptop: a macbook with severe restrictions on what customizations can be made and what software can be installed.

## The critical resource

The software world is obsessed with *developer time*. I had a college professor who used to say "computers are cheap, but *developer time* is expensive". The developer productivity team at the large tech company I work for often quantifies their wins in terms of *developer time* saved[^4]. When my team estimates tasks, we do in terms of *developer time*. When Hacker News discusses the merits of one software tool vs. another, the implicit criterion is often one of *efficiency*. Which tool will allow you to write better software quicker, per unit of *developer time* spent using the tool?

But I'd like to challenge this. I say the critical resource is not *developer time*, it's *developer energy*. The "10x developer" may or may not be a myth, but it is no myth that I personally am 10x more productive on days when I am energized than on days when I am exhausted, distracted, and frustrated. 

It's a rare day that I have the energy to spend all my time highly engaged with high-value work the whole day. I'll spend a typical morning getting organized, being on Slack, doing low-value administrivia, etc. Eventually, I'll have the energy built up (or get stressed out enough by the fact that I haven't accomplished anything valuable yet that day), and dive in to confront the challenging, high-value parts of whatever project I'm working on. Then after some time, my energy wanes, and I retreat back into lower-value administrivia again. So my productivity on a given day is less a function of how much *time* I have available, than how easy it is to muster up and preserve the *energy* to actually focus on the highest-value work and overcome the challenges there. I suspect something similar is probably true of your work habits, too.

Energy is critical. Chronically low energy leads to burnout, which is tragic for the individual. And it leads to churn, which is death for the team. Energy > time.

## The linguistic game

Energy is different for everybody. For me, using a super custom Vim and window manager is one source of energy, especially if the challenge of the day involves a lot of text editing. I also get a lot of energy out of pair programming, especially if it's with somebody less experienced than me whom I can feel like I am helping learn. I also can get energy if I like the programming language that I'm using.

There was[^6] a tweet that made the rounds awhile back

<div style="text-align:center"><img alt="Becoming more and more aware that languages in the ML tradition (Haskell, Rust, OCaml, etc) are about a certain kind of linguistic game that the developers have fun playing, and not because it makes any software arrive quicker, behave righter, perform better, or last longer - Chris Done, September 2022]" src="../images/done-tweet.png" style="width:500px;"/></div>

I am a staunch advocate of the ML tradition, as you may have guessed from my [monad tutorial](./2020-07-26-monads.html) (another example of how I'm a sucker for "quirky technology that promises great rewards past an initial challenge"), so this hurts a little to admit, but I think there's some truth in this tweet. Maybe we all give Haskell so much street cred because of how satisfying it is to play Haskell type tetris, and not because we've examined evidence that the practical merits of the language make it possible to write more robust software in less time.

But so what? As I said about the unicycle, how a tool makes us *feel* can be way more important than the narrowly conceived "practical merits", anyway. By this measure, describing a "linguistic game that the developers have fun playing" seems like one of the most flattering ways you could paint a programming language.

Of course, different strokes for different folks. For me, once I got the hang of it, programming with an ML-style type system was an incredible source of energy. Addictive, even. But I think it's important to admit that type tetris is not the only thing about a programming language that can make people excited.

## "Look, Mom, I made a fully-formed English sentence"

Take Ruby on Rails, for instance. I think Ruby on Rails makes developers excited in a completely different way. DHH, the author of Rails, has written about the first tenet of the "Rails Doctrine" being ["Optimize for Programmer Happiness"](https://rubyonrails.org/doctrine#optimize-for-programmer-happiness). 

I'm interpreting a little bit, but I think what DHH means by "programmer happiness" he is specifically referring to a particular ethos I have noticed among the Ruby/Rails community: a willingness to accept slightly convoluted implementations as a fair price for the ability to write code that looks "cute" on the surface.

DHH mentions two examples: the fact that Rails has `.first`, `.second`, `.third`, etc. accessors instead of just `[0]`, `[1]`, `[2]`, etc. and the fact that Rails knows that the plural of "person" is "people", not "persons" and the plural of "analysis" is "analyses", not "analysises".

A more substantial example of this ethos, (not mentioned by DHH), is the [cucumber testing library](https://cucumber.io/tools/cucumber-open/) that arose in the Ruby community. With cucumber, you write your tests as paragraphs that look like plain English. Here's a test scenario from [their docs](https://cucumber.io/docs/guides/10-minute-tutorial/?lang=ruby#write-a-scenario)

```cucumber
Feature: Is it Friday yet?
  Everybody wants to know when it's Friday

  Scenario: Sunday isn't Friday
    Given today is Sunday
    When I ask whether it's Friday yet
    Then I should be told "Nope"
```

This is a real test that executes. To make it work, you have to define "step helpers" that are capable of dispatching methods based on the text that is written.

I have mixed feelings here. The first time I encountered cucumber, I was trying to fix an issue in a Rails app maintained by a team whose time zone had gone to bed, and my exact thoughts about it at the time were "*what the heck are these text files doing in here*" and "*where in the heck are the tests?*"

On the one hand, I hate this. It seems like needless, frivolous indirection.

On the other hand, there's just something cool about English text that executes. I have to admit it. I hate it, but there it is.

My point is, this is a perfectly legitimate source of developer energy. If the ability to write grammatical, executable English sentences gets you and your team excited to write tests, then absolutely more power to you[^5]. It bears repeating: the critical resource is *developer energy*, not *developer time*. Energy is gold, and you should seize it wherever you can find it, even if it means writing cucumber scenarios.

## The call to action

This is a fairly recent shift in my thinking. Many practices and traditions across the industry that, a year ago, would have seemed misguided or pointless to me make more sense considered in terms of "developer energy". For example, the people who are super dogmatic about TDD or XP or Agile Methods, or obsessed with building their own elaborately customized mechanical keyboards, or the people in [r/battlestations](https://reddit.com/r/battlestations), or the people who like dependency injection frameworks, or why web frameworks give semantic meaning to file paths. None of these things seem particularly practical to me, but at the same time I can also see how somebody would find them aesthetically satisfying or energizing in some way.

I have three calls to action:

### 1. Stop feeling guilty about the software you love.

Don't feel bad about spending quality time with your dotfiles, or installing a fancy font with ligatures, or getting used to that fancy new mechanical keyboard, or whatever your poison is. Think of these things as an investment in your energy, not a distraction from your work. (Everything in moderation, of course).

### 2. Hype things up, throw some shade.

I have a brother 13 years older -- it's his fault I use Vim and Desktop Linux. 

I was in my formative college years. He convinced me to give Vim and Linux a shot, not by giving me some sort of objective analysis of all the options for editors available, but by throwing shade on IDEs ("they make you helpless, they obscure what's really going on") and Windows ("Microsoft is an evil monopoly, proprietary software is immoral"), and hyping up Vim and Linux a bit more than they probably deserved.

This was a huge favor. I owe so much to him.

By "throwing shade" I do not mean "bullying". Please don't join the wretches online who get their kicks from trying to make other people feel bad about themselves or lesser because of their choice of technology/programming language. Good-natured, civil hype and shade have their place, though. Hype up what thrills you! Decry the mediocre, corporate-backed, optimized-for-drudgery alternatives[^7].

If you're a beginner just entering the world of software, what you need most is energy and the motivation to learn. You should feel like the programming language you are learning to use is special, in some way. You should feel like the editor you are learning to use will let you become some sort of leet haxor. You should feel like you are becoming part of a community, with special lore, its own brand of humor, and a superior culture. You need these feelings more than you need an objective picture of things, and I am lucky I had them.

### 3. Open your mind. Try impractical things.

Have a teammate who's really eager to introduce cucumber tests? Have a boss who's into heavily regimented scrum? Have a friend who always wants to talk your ear off about their weird obsession with custom mechanical keyboards?

You have two options. You can take a stand for pragmatism, make your arguments about how these really aren't the most efficient uses of time. Or: you can dive in. Write those cucumber scenarios. Go ham with it. Don't settle for plain English, unleash your inner Shakespeare! Lean into that Scrum stuff too. Throw pragmatism to the wind, find the joy in your team's favorite impracticalities, and see how much more productive you can be if you commit to *enjoying yourself*.

---

That's the post! Now hop on the unicycle and start pedalling.

[^1]: I came across [this post](https://www.baldurbjarnason.com/2022/theory-building/) on Hacker News the other day, describing the act of programming as "theory-building". I like this frame. If you conceive software engineering as not just building software mechanisms, but growing the attitudes and ideas that surround those software mechanisms, it follows that the *feelings* people have about software tools can be more important than the actual technical characteristics those tools have.

[^2]: If you take nothing else away from this post, try [home-manager](https://github.com/nix-community/home-manager).

[^3]: I should say, I don't really recommend switching to Dvorak. Not in the same way as I recommend Vim or Desktop Linux, anyway. I switched in college, and mostly regret/am embarassed by it today, although possibly it could be protecting me against RSI -- who can say? In any case, it's a part of who I am now and I'm not about to ditch it.

    If you're actually interested in the ability to input text faster than a qwerty typist can, and you have time to waste, you should look into a project called [plover](http://www.openstenoproject.org/plover/), which lets you use your keyboard like a stenography engine.

[^4]: If you quantify your success in terms of *developer time saved* you're probably *understating* the value of what you delivered, since often, the things that waste developer time are even more expensive in terms of *developer energy*. Nobody likes waiting for a slow script to finish. I've abandoned approaches due to slow scripts. I've ended pair programming sessions early due to slow scripts. I've *changed teams* because of slow scripts.

    However, speeding up things isn't the only way to improve feedback loops and make the developer lifecycle more "energy-efficient", see [Engineer SHORT feedback loops](./2022-08-30-short-feedback.html)

[^5]: Couldn't be me.

[^6]: Chris Done, the author of the tweet, recently deleted all his tweets and left Twitter. Luckily, I found the tweet screenshotted in a [Strange Loop Talk, "Stop Writing Dead Programs" by Jack Rusher](https://thestrangeloop.com/2022/stop-writing-dead-programs.html).

[^7]: You should read ["Choose Boring Technology"](https://mcfunley.com/choose-boring-technology). My post might *sound* like a counterargument to "Choose Boring Technology", but it isn't. "Choose Boring Technology" has a bad title: it's really an argument against *unproven* technology, not against exciting technology. McKinley for some reason seems to equate software being unproven with it being exciting, and software being proven being boring, but for me, at least, I find the most excitement mostly in old, mature technologies like Desktop Linux, Haskell, Nix, Vim -- which are hardly unproven, they're just a little bit out of the mainstream.