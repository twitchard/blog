---
title: Artisanal, Machine-Generated API Libraries
class: prose
description: "Generating Stripe's seven server-side sdks"
draft: "true"
---

## My upcoming conference talk

<img src="../images/dropCapE.png" alt="E" class="dropCap" style="height: 50px; width: 50px;" />xciting news! I will be speaking [at Strangeloop](https://thestrangeloop.com/2021/artisanal-machine-generated-api-libraries.html) in a few weeks about some of my work at Stripe. The abstract:

> Stripe recently began generating API libraries in seven different programming languages, after maintaining them by hand for eight years. We wanted the generated code to offer just as good a user experience and be no less readable than the handcrafted code, while keeping breaking changes to a minimum, so we built a tool for this ourselves: a compiler of sorts. This talk is a deep dive into how we built our tool and lessons we learned along the way. 

My process for writing presentations is fickle. I need a flash of inspiration. Typically, I think of some gimmick I think is clever or funny and I build the presentation around that. That hasn't happened yet and time is ticking. 

As a technique to search for inspiration, I present to you this blog post, a prototype of my conference talk.

## What is Stripe?

Stripe is a company with a public API. The details of  the API don't matter too much for my purposes here, but here's a word cloud I generated from the API definition to give you a general flavor.

<img src="../images/stripe-wordcloud.png" style="position: relative;width: 100%" alt="word cloud featuring big words like 'payment', 'customer', 'account', 'create', 'subscription', and 'invoice'; medium words like 'currency', 'refund', 'document', and 'bill'; and small words like 'checkout', 'report', 'identify', and 'schedule'"/>

## What is an API Library?

Stripe has seven API libraries: stripe-ruby, stripe-python, stripe-php, stripe-node, stripe-java, stripe-dotnet, and stripe-go.

I'm sure you're wondering "Richard, which is your favorite library?". That's a ridiculous question: I love them all equally.

What do these libraries do? Primarily, the aim is to make invoking an endpoint on Stripe API as simple as invoking a method in your programming language of choice.

Here's an example of invoking the `POST /v1/coupons` endpoint in stripe-php.

```php
$stripe = new \Stripe\StripeClient(
  'sk_test_xyz'
);
$stripe->coupons->create([
  'percent_off' => null,
  'duration' => 'repeating',
  'duration_in_months' => 3,
]);
```

It's a simple purpose. But this is software; every simple purpose turns out to be more involved than you might expect.

## What are the three aspects of an API library?

I like to divide the responsibilities of an API library into three categories: transport, vocabulary, and ergonomics.

A message to the Stripe API looks like this:

```txt
POST /v1/coupons HTTP/1.1
Authorization: Bearer sk_test_xyz
Accept: application/json
Content-Type: application/x-www-form-urlencoded
Content-Length: 70
User-Agent: Stripe/v1 NodeBindings/8.174.0
Host: localhost:4444
Connection: keep-alive

percent_off=0.1&duration=repeating&duration_in_months=3&metadata[foo]=bar
```

A response from the Stripe API looks like this:

```txt
HTTP/1.1 200 OK
Server: nginx
Date: Sat, 11 Sep 2021 20:38:39 GMT
Content-Type: application/json
Content-Length: 334
Connection: keep-alive
stripe-version: 2019-02-19

{
  "id": "hxPDwuVz",
  "object": "coupon",
  "amount_off": null,
  ...
}
```

