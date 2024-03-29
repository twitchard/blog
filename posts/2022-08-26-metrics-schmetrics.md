---
title: "Be good-argument-driven, not data-driven"
class: prose
description: "Software culture and the abuse of data"
quote: Is data-drivenness a psyop from Google?
hackernews: https://news.ycombinator.com/item?id=32651763
retweet: https://twitter.com/twitchard/status/1563267751803637760
reddit: https://www.reddit.com/r/programming/comments/wymg9e/be_goodargumentdriven_not_datadriven
thumbnail: https://twitchard.github.io/images/appropriate-data.png
---

<img src="../images/dropCapI.jpg" alt="I" class="dropCap"/>'ve [ranted previously](2019-10-13-software-development-and-the-false-promise-of-science.html) about taking empirical research about software engineering practices with a grain of salt. Let's dust off the old salt shaker and season up a related idea: the notion that software organizations ought to be "data-driven", i.e. that all teams and projects should define metrics to evaluate their success; decisions should be generally be given some data-based justification; without data we can't be objective; if we rely merely on reason and intuition, bias will creep in. Science! Truth! The American Way!

There's nothing wrong with a fondness for data. The trouble begins when you begin to favor *bad arguments* that involve data over good arguments that don't, or insist that metrics be introduced in realms where data can’t realistically be the foundation of a good argument. 

## When are data-based arguments appropriate?

Sometimes data-based arguments are perfectly acceptable. Let's have a diagram!

![](../images/appropriate-data.svg)

Let's have some prose, too:

1. **Are all factors that drive your metric well-understood?**

    Some things you can measure and ~completely understand their causes. For example: server costs. You can know which types of records in your database are taking how much storage. You can know what types of requests are taking up how much compute.

    If you want to evaluate a project responsible for decreasing server costs, then measure away! Take care to measure against the *counterfactual*: don't evaluate success based on whether server costs went up or down, evaluate success based off *how much higher server costs would be if the project had not shipped*. This is possible only because you can fully attribute server costs. The team can plausibly say "our project prevented X records from being created, which would have occupied Y terabytes and accrued a cost of $Z per month".

2. **Can you run an experiment?**

    Other things have causes that cannot easily be understood, especially when human factors are involved. Take new user growth. You can easily measure how many new users signed up in a period. But can you understand what is behind this number? Was it a new feature you released? Was it a change you made to your pricing? Was it a change a competitor made to its pricing? Did some tech influencer drag you on Twitter? Was it the overhaul you did to the landing page? Was it the SEO project that completed? Can you know?

    You can't fully attribute user sign-ups in the same way that you can fully attribute server costs. Even if you interrogated a user who signed up or chose not to, they likely could not give a full accounting of the psychological factors behind their decision. Nevertheless, you can still do some attribution with A/B testing. If you can collect your data like a scientific experiment, i.e. you can randomly assign users to a control group and a treatment group, and measure a difference between the two groups. For instance, suppose you want to evaluate a new landing page. If you show the new landing page to group A, and show the old landing page to group B, and you detect some difference in sign-ups between the two groups, and the only difference between the groups was which landing page they saw -- then the only possible causes of that difference are random chance (which you can rule out through sample size) or the landing page. You can analyze a pricing change similarly[^1].

    What about analyzing the impact of a new feature on user sign-ups? That's harder. You don't typically control all the channels where users learn about your feature, so you can't randomly assign some people to learn about the feature, and some people not to. However, you can do a somewhat shakier analysis by randomizing just those channels you do control, e.g. which users see messaging about your new feature on your website. If you calculate how seeing the message about your feature affects sign-ups, and you have some idea which proportion of people who saw the message were learning about the feature for the first time, then you can derive an estimate for the effect that learning about your feature has on sign-ups altogether, and figure out how many of your sign-ups to attribute to the new feature. This is called the "instrumental variable" technique, and like all statistical techniques has caveats. Namely, it assumes that the set of users who learn about your feature on your website have the same behavior with respect to sign-up behavior as users who learn about your feature elsewhere - which seems like a pretty fraught assumption. Also, this sort of analysis gives you a glimpse only into the very short-term effects of your feature. If your feature just generally increases user satisfaction, and in the long-term drives your users to more heavily recommend your product to their friends, this cannot realistically be captured with A/B testing.

3. **Are you prepared to do some very very fancy statistics?**

    Things get hairier the further you get from a controlled experiment. It is *possible* to make good arguments based on "field data" collected about events that are occurring without any sort of randomized control, but this is enormously difficult. How do you distinguish correlation from causation? How do you grapple with omitted variable bias? There are techniques: this is "causal inference", the province of econometrics and data science. Tech companies do occasionally hire data scientists and statisticians and others who know how to draw insights from non-experimental data, but in my experience, causal inference experts are scarce. The data scientists in a software organization usually are deployed on a narrow, selected set of problems where statistics translates very directly to increased revenue, and there's not enough of them around to really make sure that the "data-driven" decisions being made by everyday software teams are being done on a robust statistical basis. If your culture is that every project, every team should be metrics driven, you'd better be hiring a boatload of data scientists.

## Is data-drivenness a [psyop from Google](https://twitter.com/sundarpichai/status/1543328071532523521)?

I originally claimed that data-driven culture leads bad arguments involving data to be favored over good arguments that don't. Let's substantiate that with an example:

Recently, an engineering leader I respect [linked me on Twitter](https://twitter.com/skamille/status/1551750953300271104) to [the chapter on metrics](https://abseil.io/resources/swe-book/html/ch07.html#signals) from the book [_Software Engineering at Google_](https://abseil.io/resources/swe-book). The chapter describes a project to evaluate Google's "readability" process, where some engineers go through a process and are "granted readability" and all code by others must be reviewed and accepted by somebody who has been granted readability. They basically surveyed engineers to see if they felt positive about the process, but also analyzed "hard numbers", like the average duration of reviews for an engineer's code.

It is *possible* to get meaningful insights from data like this. You have to either run an experiment -- i.e. randomly choose some engineers to be granted readability without going through the process, comparing them against engineers who aren't skipped -- or, if you don't do that, you can do some fancy statistics (from what I vaguely recall from undergrad econometrics, maybe a regression with time and per-engineer "fixed-effects"?) Maybe this is in fact what Google did. I'd like to think so: their research team allegedly includes economists and social scientists, but the chapter states that they did a naïve comparison of "median review time for CLs from authors with readability and without readability" without any acknowledgement of or attempt to adjust for the obvious selection bias. Wouldn't you expect the engineers who seek to be granted readability to be disproportionally those who *value* having fast review times, and thus have other characteristics that would cause them to have fast review times? How do you know that the difference in review velocity is caused by the readability process and not those other characteristics?

The worst thing about the chapter is that it pays so much lip service to the shortcomings of metrics. It talks the talk: not everything is worth measuring, metrics can be confounded by unknown factors, qualitative analysis is important, avoid vanity metrics, etc., but then the data-based argument it advances as an exemplar for the rest of the industry is ~~a psyop~~ completely inappropriate and should not be judged as persuasive by any reasonable individual. This is a typical pro-metrics rhetorical trick. The champions of data are always careful to list all the caveats of measurement, but the implicit assertion is that metrics are useful in the common case; it is the exceptional case where measurement is inappropriate. I claim that the exact opposite is true. The common case is that you can't measure what you want to measure, you can only measure a proxy and in order to meaningfully interpret even that, you either need to run an experiment that you probably don't have the resources to run, or do statistics that you probably don't have the expertise to do.

## R.I.P. intrinsic motivation

An overemphasis on data can harm your culture through two different channels. One is the suspension of disbelief. Metrics are important, says your organization, so you just proceed to introduce metrics in areas where they don't belong and everybody just ignores the fact that they are meaningless. Two is the streetlight effect. Metrics are important, says the organization, so you encourage your engineers to focus disproportionately on improvements that are easy to measure through metrics - i.e. you focus too much on engagement, growth hacks, small, superficial changes that can be A/B tested, vs. sophisticated, more nuanced improvements whose impact is more meaningful but harder or impossible to measure.

In both cases, the cost is morale. It's demoralizing to feel that your success, in the eyes of the organization, is defined by a metric that is either out of your control or doesn't match your convictions about how to best serve users and the organization. There is a class of engineers - extrinsically motivated, preoccupied chiefly with climbing the corporate ladder, without such convictions, happy to claim credit for upward-bound metrics that seem related to their area of work without being bothered by the lack of a strong causal argument, or to growth hack away and drive up the numbers without creating meaningful improvement - who thrive in this environment. But bad metrics is a surefire way to destroy instrinsic motivation.

Overemphasis on data is also a sign of weak leadership. It is interpersonally less risky to say "according to the metrics, your team is underperforming", even when everybody knows the metrics are nonsense on stilts, than it is to say "in my judgement, based on observations X, Y, and Z, your team is underperforming". A mature leader has no need to hide behind false objectivity, but insecure leaders use metrics as a crutch.

## Call to action

Data has its place. Metrics are a useful tool for making a certain class of persuasive arguments in certain domains. But they are *only a tool* for making good arguments. Data is not an end in itself. A weak argument founded on poorly-interpreted data is not better than a well-reasoned argument founded on observation and theory. Stop going all googly-eyed (tee hee) at statistics. Metrics are tempting. They promise easy answers. Resist! Be skeptical! Have no tolerance for poor arguments made with data. Keep intrinsic motivation alive.

[^1]: Redditor u/Pelera [points out](https://www.reddit.com/r/programming/comments/wymg9e/comment/ilzlb3p/?utm_source=share&utm_medium=web2x&context=3) that A/B testing even something like a landing page or pricing revamp has caveats - since often multiple people are involved in a purchase/sign-up decision, and even individuals might visit a page from multiple devices.
