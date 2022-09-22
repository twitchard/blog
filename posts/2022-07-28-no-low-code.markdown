---
title: "No code and higher-level programming"
class: prose
description: "Is no code higher level programming?"
draft: true
---

Alan Perlis said
> A programming language is low level when its programs require attention to the irrelevant. 

Web programming today feels too low level to me. When I build a web application, it feels like *building a machine that happens to support the interactions I desire*, when I would rather *describe the user interactions I desire* directly and then, in a separate step, translate that description into a working app.

Suppose I was building a Twitter clone. I would like to say:

  * logged-out users can specify a username/password to register or sign in
  * logged-in users can specify text to create a tweet
  * logged-in users can follow other users
  * logged-in users can browse a chronological feed of tweets from users they follow
  * users can browse registered users lexically by username
  * users can browse a particular user's tweets


Instead, what I say is
  * On page `/`, if you are logged-out, there is a button labeled `register` that links to `/register`
  * On page `/`, if you are logged-out, there is a button labeled `log in` that links to `/login`
  * On page `/`, if you are logged-in, there is a button labeled "tweet" that opens a modal with a form including a textarea that will `POST /tweet {"text": ...}`
  * On page `/`, if you are logged-in, there is a `<Tweets>` component with data from `GET /feed` that, for each row, renders a `<Tweet>` component, and will paginate and display more if you scroll to the bottom.
  * The `<Tweet>` renders as a card with `username` in the top left that links to `/users/{username}`, a (human-readable, relative) `created_at` in the top right, and `text` below.
  * On page `/`, there is a link to `/users`
  * Page `/users` has a `<Users>` component with data from `GET /users` that, for each row, renders a `<User>` component.
  * The `<User>` component renders `username` on the left and a "see tweets" link that links to `/users/{username}`
  * There's a `Tweet` model with `create`, `retrieve` and `list` operations, associated with a `tweets` collection in the database, with columns `id`, `created_at`, `author`, and `text`.
  * The `POST /tweets` endpoint accepts `text`, authorizes the user, and then calls `Tweet.create` with the user's id and text.
  And so on and so forth...

In other words, I have to
  * Select widgets for collecting data from and displaying data to the user.
  * Organize these widgets into components.
  * Organize these components into pages.
  * Give each page a URL.

  * Organize the data into database tables, models, and controllers.
  * Define routes
  * Define a controller.




  * Define components like `<Users>`, figure out what data ("props") each component accepts.
  * Decide how to map the data in each component to HTML elements and widgets that can display it.
  * Select widgets for collecting data from the user.
  * Define endpoints for data to be transmitted to the server. Name the URL and the fields.
  * Define "models" on the backend.
  * Define a database schema.






A major problem with web development today, I think, it that it forces developers to specify details *before they become relevant*.

If you're spinning up a new web app, on the backend, you have to:
  * build an ontology of "models" to describe your data
  * decide which fields and which logic go on which model, 
  * pick a database
  * design a database schema for your models
  * pick REST or GraphQL
  * design a bunch of endpoints so the frontend can talk to the backend
  * decide what fields go on which endpoints and name them

On the frontend, you have to:
  * Pick a framework
  * Decide how the app is going to fetch data and communicate with the back end.
  * Invent an ontology of "components"
  * Inside your components, create buttons and labels and text fields and such, attach these to event handlers
  * Arrange your components into a hierarchy for rendering
  * Decide which components need to access which data
  * Figure out some scheme of how data will be queried from or otherwise "passed down" to each component.
  * Figure out how errors will be bubbled up to the user.
  * Decide on a paradigm for how you're going to express styles. CSS-in-js? BEM? Tailwind?
  * Go through your component hierarchy and add CSS grid or flexbox annotations to get things to match the layout you have in mind.
  * If you care about responsive design, you need to test and tweak everything for different window sizes.

This is just too much!

The essence of a web application, I believe, is the user interactions it enables. I daydream about a future in which I can get started by describing that, only.
I daydream about a future where I can start by specifying the "core essence" of the app, only. I want to ignore the particulars of the database schema, and frontend/backend hierarchy, and widget choice and layout and component hierarchy. I'll come to that stuff later. Suppose I want to build a Twitter clone, I want to say

  * let there be users
  * let there be tweets
  * tweets have body text
  * users can specify text to create a tweet
  * users can follow users
  * let there be retweets
  * users can generate a retweet from a tweet
  * users can browse a chronological feed of tweets and retweets from users they follow

and this should be enough to get me an unstylized, but functional, twitter clone. This took me eight lines of English to describe. It should require eight lines of code to specify,

Then I should be able to progressively, naturally, build on this foundation and specify more details as I choose to care about them, in an order that is natural to me. I want to say

* User's cant follow themselves
* Records persist in MySQL
* The creation timestamp only displays on hover
* Everything is themed in green and pink pastels

And I want to be able to say these things without interfering

I also shouldn't have to start from scratch when I take my web app and "port" it to a new platform. My web app, my iOS app, my Android app, my Alexa "skill", my Google Assistant Integration, my CLI, my smart TV app - although they might have substantial differences in terms of presentation and organization - should be able to share a "core" definition of user interactions. I shouldn't have to define 6 separate, standalone apps that happen to implement the same set of interactions. "React Native" has the right idea in this regard, but doesn't go nearly far enough.

And while I'm wishing, I'd like a pony too. And a lollipop!

As Alan Perlis said:

> When someone says 'I want a programming language in which I only say what I wish done,' give him a lollipop"

## What exists?

So is "let there be users"

# A higher-level programming language for the web

> A programming language is low level when its programs require attention to the irrelevant. 

I want a higher-level programming language for the web. I want a programming language in which I only say what I wish done.

Alan Perlis of ALGOL fame, the first Turing Award laureate, wrote[0]


I want that programming language. And the joke's on Alan Perlis, because I want a lollipop too.

The man also wrote[1]


Web development today, I claim, is not high level. We have tools -- frontend frameworks like React, backend frameworks like Ruby on Rails.

IAM
Management interface
Expiration
Interactive querying & exploration



Rails




I think the software world is ripe for a higher-level programming language for web development, and I suspect it will emerge from "

Programming a web application today, I claim, feels like it requires a lot of attention to the irrelevant. We need a "higher-level" programming language.

What details are "irrelevant" changes according to the lifecycle

When I'm prototyping an app, I really care how data is stored



I want to specify the look and feel of the app in general terms. 
I want to specify

Writing web apps today feels, to me, like it requires specifying a lot of irrelevant detail.




[0] epigrams
[1] automatic programming

and elsewhere he wrote[2]

> In a sense, progress in programming language design can be measured by the ratio of program text we must write which says *what* is to be done to that which says *how* it is to be done.
>
> Of course, we all know that this is a layered issue: "what" at one level must be "how" at another, presumably lower, level in the language processing hierarchy

