---
title: Discriminated Unions and Exhaustiveness Checking
class: prose
description: "Use discriminated unions and exhaustiveness checking to level up your Javascript"
draft: "false"
---

<img src="../images/dropCapF.png" alt="F" class="dropCap"/>low and Typescript have a feature called "discriminated unions with exhaustiveness checking". I use this feature extensively. The resulting code can look odd if you aren't familiar with this style of programming, but I think any Typed Javascript developer really should learn about this to really take full advantage of the type system. 

Discriminated unions aren't that well-known. You won't have encountered them in a dynamically typed language, of course, and the most popular statically typed languages Java, C#, or Go don't support them. The [Typescript docs](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-func.html#discriminated-unions) and the [Flow](https://flow.org/blog/2015/07/03/Disjoint-Unions/) docs both describe their support for discriminated unions, and exhaustively checking them, but it's mentioned deep in the annals of the docs, as if it's some obscure, advanced feature. Myself, I learned about discriminated unions from hipster programming languages, like Purescript, Elm, and Haskell. Other hipster languages have them too -- Scala, Rust, F#, and Ocaml, but I haven't written those very much. They are also called "tagged unions" or "sum types" or "algebraic data types". These phrases have slightly different meanings, but refer to approximately the same language feature.

In any case, I think you should know how to program this way, so I wrote this post to briefly explain what this technique is, and why you might use it.

---

## What is "discriminated unions with exhaustiveness checking?"

High-level, *exhaustiveness checking* is a way for you to ask your type checker "make sure I have explicitly handled all the cases." And *discriminated unions* are a way for you to define what the cases are that you want the type checker to enforce that you handle.

## Exhaustiveness checking

While some hipster languages do exhaustiveness checking for you by default, in Flow/Typescript, though, you sometimes have to ask the type checker explicitly for an exhaustiveness check, and the way you do that is a little peculiar. You have to implement a function (I call it `exhaustive`) that has an impossible input type. Then, you call this function from places in your code that should be impossible to reach. The type checker will do a flow analysis. It will succeed if it can confirm the impossible function will never be called - otherwise it will report a type error.

Here's an example in Flow:

```javascript
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
```javascript
type JSON = boolean | number | string | Map<string, JSON>;
```

The "discriminated union" version of this type would be
```javascript
type TaggedJSON = 
  | {tag: 'boolean', value: boolean}
  | {tag: 'number', value: number}
  | {tag: 'string', value: string}
  | {tag: 'object', value: Map<string, TaggedJSON>}
```

The `tag` property here is called the "tag" or "discriminant" or the "sentinel". The name of the property doesn't have to be `tag`, it can be anything. A popular choice is `kind`. My primary codebase these days uses `shape`. The important thing is that the tag be present and unique for every branch of the union.

Here is how the analog `prettyPrint` would look:

```javascript
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
   | {tag: 'object', value: Map<string, TaggedJSON>}
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

Discriminated unions are, in a way, the *transpose* of interfaces. With interfaces - you add a new *operation* to your interface and you get a type error in all the *data types* of that interface that haven't implemented that operation yet. With discriminated unions, you add a new *data type* to your interface, and you get a type error in all the *operations* that haven't added support for that data type yet.

Here's what `prettyPrint` would look like if we encoded the problem with interfaces instead of discriminated unions

```javascript
type JSONInterface = interface {
    prettyPrint: () => string
}

class JSONBool implements JSONInterface {
  value: boolean
  prettyPrint = () => {
      if (this.value === true) {
          return '#t'
      }
      return '#f'
  }
}

class JSONNumber implements JSONInterface {
  value: number
  prettyPrint = () => {
      return (Math.round(this.value * 1000) / 1000).toString()
  }
}

class JSONString implements JSONInterface {
  value: string
  prettyPrint = () => {
      if (this.value.length > 25) {
          return `${this.value}`
      }
      return this.value
  }
}

class JSONObject implements JSONInterface {
  value: Map<String, JSON>
  prettyPrint = () => {
      return '[Object object]'
  }
}

class JSONArray implements JSONInterface {
    value: Array<JSONInterface>
    prettyPrint = () => {
       return `[${this.value.map(j => j.prettyPrint()).join(', ')}]`
    }
}
```

(See it in [Try Flow](https://flow.org/try/#0PQKgBAAgZgNg9gdzCYAoVAXAngBwKZgBSAygPIByAkgHYZ4BOUAhgMYEC8YAlrQ822ADeqMKLA56eDNgAK9HhgBcYABQBKMOwB8YAM4Z51AOaoAvuhYwmu3UTLkAQnDgxuAWxww8bvLVskKGjpGVgJhUQA3JhgAVzxlACNnLyZqEXFJaSw5BU1VDW0hdLFuKFUMAAsuXQA6KNiOdk4DOI1wko7MmPpqMAByAGIMPuKxcw6wLp7+gagR0XNzVEtrf3tyGLcEhndPb18MNcDeEIF2+rjlak3t+nSJKVlDDDz1TR12kqnelQBZJkqNXocBi1AAJipKtU6tE4sgwABGAAMKI0wERKKRahqGDgxAMPCM6nSiwsVhsdgo+MMRl2Xh8fkpVBO-DC6Qu8T0BOM90yT1ynDehU+Yi4ZUhVVqHJqXmMlTAOgATABWNqjCbfMAAAwAJIIoVLYXhTFr1WBxp0pN1egaYQ0SWYyasmaQEgArPAsF5cDz0g5HZnBVlFSJG5T-HAAHmphIANEytLzHtlnq8Ch8zZq+gBtV0er1gODuz0YAC683NjuW5IDAEF6PQmFg6ftGQFA3xQiGxBzlPXG1hI+2gp22ImSsB0Q8sjlaGn3t3RJOvlbplrs3rbdK3EwcCo3Qu3TVp-zaOpsW64DwVH14301KZS6aJ+jFkA))

On paper, anything that you can express with a discriminated union, you can express with a group of classes that implement an interface.

In practice, though, in most domains it is more natural to use discriminated unions. Interfaces are best when the *operations you are going to perform* are the known quantity, and the *shapes of the data you will operate upon* are the things you are going to discover, or leave open for extension. Discriminated unions work best when the *shapes of the data* are known, and the operations you will perform are the things you are going to discover and extend as you write the program.

Most programs have known inputs and known outputs, and their job is to transform inputs into outputs. Especially programs like web applications, or compilers.

In any case, I think discriminated unions are *particularly* useful when you're manipulating tree-like data structures -- like the DOM, JSON or an AST. They're also good for representing state machines.

I also think they're also good for representing state machines. Compare

```javascript
// Not a discriminated union, just a grab-bag of properties that might be set.
type HTTPResponse = {|
  status: 'sent' | 'received' | 'error' | 'done'
  url: string,
  verb: 'GET' | 'POST',
  errorMessage?: string,
  headers?: {[string]: string},
  statusCode?: number
|}

// A discriminated union that will help prevent users of this data
// type from assuming that "headers" or "statusCode" are set, when
// in many cases they might not be.

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

Go forth and use discriminated unions!
