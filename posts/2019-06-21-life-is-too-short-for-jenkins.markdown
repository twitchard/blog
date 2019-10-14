---
title: Life is Too Short for Jenkins
class: prose
---

About nine months ago, I requested a transfer to the team working on the company's CI tooling. In my judgement, CI was a major productivity blocker for the whole organization, and I hoped I would be able to help improve it and make a broad, positive impact.

At that time, CI was in Jenkins 1, which had three major problems:

1. Everybody's CI pipeline was described in text boxes in the Jenkins UI, which meant they were not version controlled, discoverable, and editing/testing new configurations was a difficult experience.

2. The web interface was dated and unpleasant to use.

3. Developers had little control over the environment in which their jobs ran, because the VMs operating as Jenkins nodes were centrally managed.

My team considered two options.

### Option 1: Switch tools

The head of SRE championed Gitlab CI. I resisted this idea because I, the relatively inexperienced manager of a nascent team, was daunted by the prospect of trying to supplant Jenkins, Github, and JIRA all at once.

On a previous team I had used Concourse CI to some extent, but I wasn't really blown away by the experience. Travis and Circle were mentioned. I was a fool. I should have committed to seriously researching some of the contenders and making a more informed decision, but I lacked the willpower and the discernment.

### Option 2: Upgrade to Jenkins 2

On the face of it, Jenkins 2 seemed to meet all our needs. It:

1. Supports defining your CI job as a "declarative pipeline" that can live as a Jenkinsfile in the root of your repository. Hooray configuration as code!

2. Boasts a UX facelift called "Blue Ocean" that looks more modern.

3. Permits pipelines to request to be run on a docker "agent", which lets application developers control the environment on which their job is run by specifying a Docker image or Dockerfile.

## A Taxonomy of Mistakes

The worst mistakes come in two distinct flavors: catastrophic and insidious.

A catastrophic mistake is like triggering an outage, or deleting production data. The moment you realize what you've done is the worst single moment in your career. Your heart pounds in your chest. Is this a nightmare? Maybe in a second, you will wake up? No, it's real. Hopefully, you've got a healthy culture at work, and you desperately describe the situation to your teammates, who rally to your side. Somebody with a cool head thinks of some way to make the best of things, and somehow -- maybe that night, maybe the next day -- you make it through. Things go back to normal. You write a postmortem, count your losses, and go back to work -- a little less innocent, and a little wiser.

An insidious mistake, by contrast, does not reveal itself in a moment. It makes you suffer a little bit here, and a little bit there, until one day you wake up and you realize that there is a gaping hole where your humanity used to be. You are a miserable husk of a man, with cruelty on your lips and bile in your heart. You still greet your colleagues with that jolly smile of yours -- but the sweetness in your smile is the saccharine of cynicism, not the honeyed optimism as it was in the days before, when life was cheerful and your burden was light. The light in your eyes used to be the hope for a better tomorrow. Now it is the glint of madness.

## What's wrong with Jenkins

Choosing Jenkins was the insidious kind of mistake. Warning -- I'm going to rant for many, many paragraphs. My advice is to skim.

The worst thing about Jenkins is that it works. It can meet your needs. With a liiittle more effort, or by adopting sliiiightly lower standards, or with a liiiiitle more tolerance for pain, you can always get Jenkins to do aaaaalmost what you want it to. But let's talk specifics. Jenkins features:

### High indirection between you and the execution of your code.

For me, the bulk of the actual work of a CI pipeline takes the form of shell commands. are typically executed inside shell commands. In Jenkins pipeline, there is a 'sh' "step" that executes the shell. For example
```groovy
  sh 'npm install'
  sh 'make'
```

So instead of writing Bash directly, you're writing Bash inside Groovy. But:

  * Your editor won't syntax highlight the Bash inside Groovy.
  * You can't run "shellcheck" (or any sort of Linter) on the Bash inside the groovy.
  * You can't very easily execute your shell commands to test them.

There are two ways to try and address this:

  1. Write your shell in a separate Bash file that you execute from Groovy, avoid putting it inline in your pipeline.
  2. Try to avoid writing shell at all -- instead, implement everything as Groovy methods.

I think #1 is actually the better approach. We started out there. The trouble was, we started wanting to abstract our pipeline steps and turn them into "shared libraries" and so we gravitated toward #2, so that we could share steps easily across pipelines.

The trouble is: Groovy is a much, much worse language for executing commands than Bash. Bash is interpreted, has a REPL that is great for experimentation, does require a ton of imports, and has lightweight syntax. Groovy has none of these things. The way that developers test their Groovy steps is by triggering a job on the remote Jenkins server to run them. The feedback loop is 2 orders of magnitude slower than it is for just executing Bash locally.

Are there ways to execute the Groovy steps locally? The way you're supposed to do it is with [JenkinsPipelineUnit](https://github.com/jenkinsci/JenkinsPipelineUnit) which is a very good idea -- it lets you write unit tests against your Jenkins Pipeline, and gives you an interface for mocking various Jenkins things. But there are two problems:

  1. As noted in the README, Groovy doesn't run the same way on Jenkins as it does in your unit test, because the groovy DSL is "serialized" by Jenkins before running.
  2. "Declarative" pipelines [are not supported](https://github.com/jenkinsci/JenkinsPipelineUnit/issues/10) -- a huge problem for us, since that's how we've implemented all our stuff, since it seemed to be the newest and most modern thing to be doing.

So basically, that's a huge bust. Especially since we were not a Java shop. My team was barely able to kind of piece this together because it's our job to work on the CI system, but there is absolutely no way that any of the PHP/Javascript/Golang/Python application developers who need to write pipelines will be able to download Gradle, figure out they need to run gradle init, install the pipeline unit testing library, figure out the proper way to initialize the "PipelineTestHelper".

So we're basically resigned to the workflow of running shell commands defined in methods used by a DSL embedded in groovy transmitted to the CI master node, serialized and passed to a CI worker node and executed there.

There's a "replay script" feature that lets you edit your pipeline right in the web interface, which helps cut down on the feedback time a little bit if you don't care about version controlling your changes or being able to use your own editor/tools. I personally am not willing to make that sacrifice.

TL;DR, the feedback loop sucks. You'll never be able to effectively test any of the code running in your pipeline. Your best bet is to build it all entirely in Bash, build your own mechanism for testing it and sharing functionality. The ability to write Groovy shared libraries is a trap and leads only to misery.

### Low level of discoverability

A lot of functionality that Jenkins has in the web UI -- especially the functionality that comes through plugins -- is also possible to define in pipelines, but the means for doing this is not well-documented. For example, there's this [plugin](https://github.com/jenkinsci/throttle-concurrent-builds-plugin) that permits you to "throttle" a job so that multiple jobs don't fire at once. that you can see inside the UI. After probably half a day of Googling, trial and error, and thanks to a stroke of luck, I figured out that I could accomplish what I wanted by putting the following in my Jenkinsfile:
```groovy
properties([[
        $class: 'ThrottleJobProperty',
        maxConcurrentTotal: 5,
        throttleEnabled: true,
        throttleOption: 'project'
]])
```

Maybe if I were a Java/Groovy expert I could have read the source code for the plugin and determined this was possible. But I shouldn't have to be. And the application developers trying to implement their own pipelines for there code *definitely* shouldn't have to be.

There are two tricks I've developed to help the discovery of these magic incantations. Trick 1 is the "Snippet Generator", which is basically a drop down box in the Jenkins UI with a pretty comprehensive list of options to explore and can help you find what you need maybe 15% of the time. Even if you can't produce something usable, the snippet generator can give you an idea what to Google for.

Trick 2 I've had much more success with. Use the snippet generator or Google things just enough to find a function name or keyword relevant to whatever you're trying to do. Then, go to `github.com/search` and put `filename:Jenkinsfile <keyword>`. You'll probably find something you can copy and paste. It's worked 90% of the time, for me.

Really, this experience sucks. I don't really do any sort of other engineering like that, because sane systems have better documentation, more obvious abstractions, and better interactivity. I feel like a script kiddie, blindly typing incantations in to make magic happen through trial and error. Hugely demoralizing.

### Blue Ocean is Incomplete and Unintuitive

Blue Ocean looks more modern than the classic Jenkins UI -- I'll give it that. Unfortunately, it's missing functionality, so you'll have to use and become familiar with the classic Jenkins UI anyway. It's also just not a pleasant UI to use! I'm not much of a design person or a front-end developer, so I can't articulate precisely what it is that makes the interface unpleasant, but it always seems to take several clicks in places I don't expect in order to do what I'm trying to do -- usually, I just want to run the build, or see the output of the build.

### Docker

It is possible to have your builds run inside docker containers. Jenkins 2 does let the job author specify a docker image, or dockerfile -- even kubernetes configurations for autoscaling! So, in principle, the problem of letting job authors own their job's environment is solved.

The only problem is that this problem is solved by incorporating the idea of a "Jenkins worker" INTO the idea of a Docker container. These two ideas don't always play well together. For example, one thing I kind of expected/hoped for was that, defining a Jenkinsfile to use a Dockerfile, and then giving it a build step like
```groovy
  sh 'make test'
```

would be approximately the same thing as
```bash
docker build . -t foo
docker run foo make test
```

But it different in one very significant way. With `docker run`, your cwd is whatever the Dockerfile defined. In a Jenkins job, the cwd is the Jenkins workspace -- which is bind mounted in from the host node. Basically, Jenkins tries to *turn your docker container* into a regular old Jenkins worker. This makes a degree of sense, but has a number of inconveniences.

1. You probably can't be root inside your docker container. If your build produces any sort of persistent artifact in the workspace, that artifact will be owned by root and will end up on the filesystem of the host. Jenkins on the host doesn't run as root, so it doesn't have permissions to wipe the workspace when it needs to, and you'll get janky permissions errors.

So what we ended up doing is creating a user inside the dockerfile with the same UID as the user that Jenkins runs as. Passed through via a build arg. This is not something I'd really mind doing once -- but you have to do this trick for *every single job* that is defined. So it's not just something we could solve for everybody on the CI team. Every application developer who wanted to define their own job ran up against this problem. And it's a confusing problem -- it took me days to really make sense of what Jenkins was trying to do. We documented it internally about as well as we could, but still we ended up guiding probably at least a dozen application developers through this particular confusion.

2. You're probably going to have to define a docker image *just* for the build.

One of the mostly-false promises of Docker, as it was sold to me by the true believers who introduced me to it, was that, if you do it right, you can run the same docker image, and therefore have basically the same environment in production, in CI, and on your local development machine. I've never actually see this happen, but I can tell you right now -- you're going to have to define a special docker image just for Jenkins, because of how strangely it interacts with the world of containers.

Lest this turn into a rant against Docker -- a tool I am also seriously disappointed with, I'll end here. Long story short, we used Jenkins 2. It kind of solved our problems. So now our problems are kind of solved, which is the worst kind of solved.

### Postlude

It's a month after I started writing this post. Now I work at a different, bigger company. I no longer work on CI. What's more, one of the principles I had never even thought to question at my old company -- "everybody should be writing and maintaining their own CI jobs" -- is just not at play here. There's a team that seems almost completely to own CI and all CI jobs. I'm in week 4, and I know Jenkins is there, somewhere, lurking behind the scenes. But I have never interacted with it, and it seems like there are a lot of smart people working so that I never, ever need to. What a strange new world this is.
