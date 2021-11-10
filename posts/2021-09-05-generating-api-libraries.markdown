---
title: Artisanal, Machine-Generated API Libraries
class: prose
description: "Generating Stripe's seven server-side sdks"
draft: "true"
---

Stripe has seven server-side libraries. For about two years, I've been on the team that maintains them, and I've worked on the tool we wrote to generate the definitions inside them. In this post, I will tell you about my opinions and experiences relating to this.

I gave a [conference talk](https://www.youtube.com/watch?v=mgRreyw-Nlg) about this subject earlier this month at my favorite developer conference, [Strange Loop](https://thestrangeloop.com/), but a couple weeks later I'm left feeling that this wasn't really enough to do justice to the material. I want to tackle the subject again in blog post form.

## What's an API Library?

Stripe, like a lot of organizations, has an API. The premise of Stripe's API is that you make HTTP requests to it, and then Stripe will give you a JSON response, and also do cool things for you.

We also have seven official API libraries, in seven different programming languages. The job of an API library is make interacting with the HTTP API feel natural in the target programming language. For example, if you're a Java user, and you want to create a customer record on the Stripe API, you shouldn't feel like you are sending an HTTP POST request to the /v1/customers endpoint with a url-encoded "email=richard@example.com" in the body, keep alive enabled, retries enabled for 5xx level errors, over a tcp socket with a read timeout of 15 seconds. You should feel like you are the `.create` method of `stripe-java`'s `Customer` class, with an parameter called "email".

Each API library contains "core" code that handles the general logic of things like HTTP, form encoding, JSON deserialization, and even higher-level things such as pagination. Each API library also contains "definitional" code. For every HTTP endpoint on the Stripe API, there is a method in the API library. For every resource in the Stripe API, there is a class in the API library. For statically-typed libraries, for every property on a resource in the Stripe API is a property on the class for that resource in the API library. This "definitional" code is very boilerplatey.

## Generating "artisanal" API libraries

At Stripe, we maintained the definitional code in our API libraries for ~8 years. This took a lot of effort, was somewhat error-prone, and it was hard to do in a consistent way. So about two years ago, we began working on a tool to generate this code.

The goal wasn't to generate *any* API library for Stripe. We didn't want to hammer our users with a bunch of breaking changes. The goal was to generate more or less the libraries that already existed. We wanted the code to remain "artisanal." We didn't want to generate a library that looks like it was written by a machine. Source code is a form of documentation -- if a user is having a problem with the library, it's nice if they can go to the source code, find something readable there, and are able to do some investigation of their own before hopefully filing a useful bug report.

Towards that end, we wanted to have our cake and eat it too. We wanted to generate our code with a script, but still maintain a lot of control over the generated output. We wanted to be able to selectively preserve historical inconsistencies in our library so that the generated version could be more backwards-compatible with what we had manually maintained for years.

This is not a universal goal. If you're just starting out writing a new library today without eight years of history to contend with, you probably don't need the same level of control. You can likely get by with a much simpler tool than what I describe in this post, and you can probably find it off the shelf. Things will be great for you. Your library can be simple and consistent from day one.

## Two approaches

Every good blog post needs a villain. In this blog post, the villain is what I will call "the template approach" to API library generation.

The template approach is based on a central principle







For Stripe, the essential purpose of our API libraries is to make calling an HTTP method of the Stripe API as easy as calling a method in your programming language of choice. (There's also webhooks, but that's safe to ignore for my purposes here.)

Stripe has seven API libraries: stripe-ruby, stripe-python, stripe-php, stripe-node, stripe-java, stripe-dotnet, and stripe-go. 

Briefly put, these libraries aim to make invoking an (HTTP) endpoint of Stripe API as simple as invoking a method in your programming language of choice, and provide a few niceties on top of that.

In this example, I use stripe-php to call the `POST /v1/customers` endpoint, and the `POST /v1/setup_intents` endpoint.

```php
$stripe = new \Stripe\StripeClient(
  'sk_test_xyz'
);

$customer = $stripe->customers->create([
  "email" => "jane.doe@example.com"
]);

$intent = $stripe->setupIntents->create([
  "customer" => $customer->id
]);
```

## Maintaining API Libraries

<!--

## Responsibilities of an API Library.

I like to divide the responsibilities of an API library into three categories: transport, definitions, and ergonomics.

**Transport** is how to talk to the API. It encompasses concerns such as:

  * Making HTTP requests.
  * Retrying HTTP requests.
  * Providing an idempotency key (for preventing duplicates)
  * Setting headers like 'user-agent' or 'stripe-version'.
  * Parsing JSON
  * Verifying webhooks

**Definitions** is what to say to the API. In encompasses concerns as:

  * What resources are there?
  * What properties are on those resources?
  * What methods are there?
  * What parameters are on those resources.

Finally, **ergonomics** makes it easier to talk to the API. It encompasses such concerns as:

  * Auto-pagination helpers, so getting the next page from a list endpoint is as easy as using a for loop.
  * Supporting promises and callbacks in Javascript, or providing sync and async versions of each method in C#.

-->

## Maintaining an API Library

