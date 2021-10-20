---
title: Artisanal, Machine-Generated API Libraries
class: prose
description: "Generating Stripe's seven server-side sdks"
draft: "true"
---

## My upcoming conference talk

<img src="../images/dropCapE.png" alt="E" class="dropCap" style="height: 50px; width: 50px;" />xciting news! I will be speaking [at Strangeloop](https://thestrangeloop.com/2021/artisanal-machine-generated-api-libraries.html) in a few weeks about some of my work at Stripe. The abstract:

> Stripe recently began generating API libraries in seven different programming languages, after maintaining them by hand for eight years. We wanted the generated code to offer just as good a user experience and be no less readable than the handcrafted code, while keeping breaking changes to a minimum, so we built a tool for this ourselves: a compiler of sorts. This talk is a deep dive into how we built our tool and lessons we learned along the way. 

In preparation for this talk, I submit to you this blog post.

<!--
## What is Stripe?

Stripe is a company with a public API. I generated a word cloud from the API definition, to give you a flavor of the API's subject matter, but the details of the API won't matter much for this post.

<img src="../images/stripe-wordcloud.png" style="position: relative;width: 100%" alt="word cloud featuring big words like 'payment', 'customer', 'account', 'create', 'subscription', and 'invoice'; medium words like 'currency', 'refund', 'document', and 'bill'; and small words like 'checkout', 'report', 'identify', and 'schedule'"/>
-->

## What's an API Library?

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

