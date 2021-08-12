---
title: Make your (typed) Javascript write itself
class: prose
description: "Use discriminated unions and exhaustiveness checking to level up your Javascript"
draft: "false"
---

I love Javascript. And Javascript loves me.

Our love is an old one. My friends often ask me, Richard, after all these years, how do you and Javascript keep things fresh? And the answer is, lately, static types systems. Mostly Flow, but some Typescript, too.

There's really two approaches to types in Javascript:

You can take the cautious approach: you can write whatever Javascript you would write anyway, and sprinkle some types on top. Perfectly valid. You'll catch some bugs. You'll get better IDE support. Your next refactor probably will be a little easier. You'll inject some new life into your relationship with Javascript.

Or, you can be bold and daring. You can let the types completely change how you write Javascript. You can begin writing Javascript that would be enormously silly in a world without a type checker. It will be like a whole new programming language. You'll fall in love all over again.

Or something like that. Melodrama aside, I want to write about one technique in particular. I extensively use a feature in Flow and Typescript called "discriminated unions with exhaustiveness checking". You might even say that I organize my code around this feature. The resulting code can look odd if you aren't familiar with this style of programming. You probably won't be, if you come to typed Javascript from a dynamically typed language, since discriminated unions make less sense in that context. You are likely not familiar even if you come from a statically typed language like Java, C#, or Go. They don't support discriminated unions.

I learned about discriminated unions from hipster programming languages, like Purescript, Elm, and Haskell. Other hipster languages have them too -- Scala, Rust, F#, and Ocaml, but I haven't written those very much. They are also called "tagged unions" or "sum types" or "algebraic data types". All these phrases refer to essentially the same idea.

The Typescript docs and the Flow docs both describe their support for discriminated unions, and exhaustively checking them, but it's mentioned deep in the annals of the docs, as if it's some obscure, advanced feature.

## What is "discriminated unions with exhaustiveness checking"?

High-level, it is a way for you to ask your type checker "make sure I have explicitly handled all the cases". There's two parts to this:
  * "make sure I have explicitly handled" = "exhaustiveness checking"
  * "all the cases" = "discriminated union"

## Exhaustiveness checking

Some hipster languages do exhaustiveness checking for you by default. In Flow/Typescript, though, you have to ask the type checker for it explicitly, and the way you do that is a little peculiar. You have to implement a function (I call it `exhaustive`) that has an impossible input type. Then, you call this function from places in your code that should be impossible to reach. The type checker will do a flow analysis. It will succeed if it can confirm the impossible function will never be called - otherwise it will report a type error.

Here's an example in Flow:

```flow
type JSON =
  | boolean
  | number
  | string
  | Map<string, JSON>;

type Impossible = true & false;
const exhaustive = (x: Impossible): any => {
  throw new Error('This code should have been unreachable');
}
const prettyPrint = (json: JSON): string => {
  if (typeof json === 'boolean') {
    if (json === true) {
      return '#t';
    }
    return '#f';
  }
  if (typeof json === 'number') {
    return Math.round(json * 1000) / 1000;
  }
  if (typeof json === 'string') {
    if (json.length > 25) {
      return '"<blah blah blah>"';
    }
    return `"${json}"`;
  }
  return exhaustive(json);
};
```

This code will fail the type checker, because we forgot the `Map<string, JSON>` case. Flow will report

> Cannot call `exhaustive` with `json` bound to `x` because `Map` is incompatible with string literal 'impossible'.

But if we fix it
```diff
       return '"<blah blah blah>"';
     }
     return `"${json}"`;
   }
+  if (typeof json === 'object') {
+    return '[Object object]'
+  }
   return exhaustive(json);
 };
```

it will pass the type checker.

## Discriminated Unions

In the previous example, "all the cases" meant "the different strings `typeof` can return". But `typeof` is not very flexible. 

For instance, `typeof` can't distinguish between key-value objects and arrays.

```javascript
console.log(typeof {foo: 'bar'}) // 'object'
console.log(typeof [1, 2, 3]) // 'object'
```

What if we wanted to define our own set of cases, and separate arrays out into their own case?

Recall our `JSON` type from the previous example:
```flow
type JSON = boolean | number | string | Map<string, JSON>;
```

The "discriminated union" version of this type would be
```flow
type TaggedJSON = 
  | {tag: 'boolean', value: boolean}
  | {tag: 'number', value: number}
  | {tag: 'string', value: string}
  | {tag: 'object', value: Map<string, JSON>}
```

The `tag` property here is called the "tag" or "discriminant" or the "sentinel". The name of the property doesn't have to be `tag`, it can be anything. A popular choice is `kind`. My primary codebase these days uses `shape`. The important thing is that the tag be present and unique for every branch of the union.

Here is how the analog `prettyPrint` would look:

```flow
const taggedPrettyPrint = (json: TaggedJSON): string => {
  if (json.tag === 'boolean') {
    if (json.value === 'true') {
      return '#t'
    }
    return '#f'
  }
  if (json.tag === 'number') {
    return (Math.round(json.value * 1000) / 1000).toString()
  }
  if (json.tag === 'string') {
    if (json.value.length > 25) {
      return '"<blah blah blah>"'
    }
    return `"${json.value}"`
  }
  if (json.tag === 'object') {
    return '[Object object]'
  }
  return exhaustive(json.tag)
}
```

Now, we can distinguish our array case if we want to

```diff
 type TaggedJSON = 
   | {tag: 'boolean', value: boolean}
   | {tag: 'number', value: number}
   | {tag: 'string', value: string}
   | {tag: 'object', value: Map<string, JSON>}
+  | {tag: 'array', value: Array<TaggedJSON>}
```

Then, Flow will report a type error

> Cannot call `exhaustive` with `json.tag` bound to `x` because  string literal `array` is incompatible with  string literal `impossible`

And then we handle it

```diff
     return '[Object object]';
   }
+  if (json.tag === 'array') {
+    return `[${json.value.map(taggedPrettyPrint).join(', ')}]`;
+  }
   return exhaustive(json.tag);
```

## Why?

First, calling `exhaustive` feels kind of nifty when you're just writing the function for the first time. Gives you a little endorphin rush. It's like writing "QED" at the end of a proof. It might help you catch silly mistakes.

Where it really shines, though, is when you're adding a case to data type that's used in many functions scattered throughout your codebase. Imagine we had all these functions

```flow
const parseConfig = (json: TaggedJSON): Config => {
  ...
  return exhaustive(json.tag)
};

const toYaml = (json: TaggedJSON): string => {
  ...
  return exhaustive(json.tag)
};

const validateAgainstJSONSchema = (json: TaggedJSON, schema: JSONSchema) => {
  ...
  return exhaustive(json.tag)
};
```


## What is programming like this good for?

I think this style of programming is *very* good in situations where you're manipulating some tree-like data structure. If you're manipulating JSON, the DOM, a programming language, where each "node" of the tree can be any of several different types, discriminated unions are a good choice. ([Not everybody agrees](https://buttondown.email/nelhage/archive/tagged-unions-are-overrated/))

I also think it's good for representing state machines. Compare

```flow
type HTTPResponse = {|
  status: 'sent' | 'received' | 'error' | 'done'
  url: string,
  verb: 'GET' | 'POST',
  errorMessage?: string,
  headers?: {[string]: string},
  statusCode?: number
|}
type TaggedHTTPResponse =
  | {|
      tag: 'sent',
      url: string,
      verb: 'GET' | 'POST'
    |}
  | {|
      tag: 'connectionError',
      url: string,
      verb: 'GET' | 'POST',
      errorMessage: string,
    |}
  | {|
      tag: 'received',
      url: string,
      verb: 'GET' | 'POST'
      headers: {[string]: string},
      statusCode: number,
    |}
  | {|
      tag: 'readError',
      url: string,
      verb: 'GET' | 'POST',
      headers: {[string]: string},
      statusCode: number,
      errorMessage: string,
    |}
  | {|
    tag: 'done',
    url: string,
    verb: 'POST',
    headers: {[string]: string},
    statusCode: number,
    body: string
  |}
```

Modelling the HTTPResponse state machine as a tagged union makes it a lot easier to prevent e.g. assuming that `statusCode` or `body` exists when it doesn't, yet.


