---
layout: post
title: "Upgrading your ember CLI QUnit tests in less than 5 minutes"
date: 2015-02-25 08:56:31 -0500
comments: true
categories: ember-cli ember-cli-addons ember
---

Recently ember CLI updated its tests blueprints to match QUnit's 2.0
upcoming syntax. Meaning that if we wanted to live on the edge we would need to update our existing tests to match such changes or ignore the changes to [tests/.jshintrc](https://github.com/ember-cli/ember-cli/pull/3197/files#diff-26f52f3fec353435f47247381c4f1189L12) and continue using globals.

As an early adopter I decided to upgrade my test, the first time I
went old school with `perl` and `xargs` running commands like:

```
find  . -type f | xargs perl -pi -e "s/ deepEqual\(/assert\.deepEqual(/g"
find . -type f | xargs perl -pi -e "s/'\, function\(\)/', function\(assert\)/g"a
```

The command above worked fine on the first try but it was mostly
because I run it on a personal project and I knew that nothing else
would match something like `'\, function\(\)/` when referring to
`test('foo', function() { ..`.

Part of my consulting work is helping my client's teams stay in the flow
while also living on the edge, if there is an ember CLI release, they
wanted it. If there is an Ember or Ember-Data release, they want it.

So naturally they also wanted to upgrade to ember-cli 0.2.0-beta.1,
but the regular expressions were not working properly for all scenarios.

Instead of wasting time making my regex work for every different
situation I decided to take a different approach and write an addon to
do the work for me without relying on regular expressions but,
manipulating the syntax tree directly with
[recast's](https://github.com/benjamn/recast) help.

The basic idea is that once the addon is installed I could then do
something like `ember watson:upgrade-qunit-tests` and get the job done.

## Enter ember-watson

[ember-watson](https://github.com/abuiles/ember-watson) is a doctor tool distributed as an addon or CLI which you
can use to help you fix different parts of your code.

Right now it only includes the command `upgrade-qunit-tests` which
will fix your QUnit tests to have the right syntax.

To use with `ember CLI` run `npm install ember-watson@latest --save-dev` and
then you can do `ember watson:upgrade-qunit-tests` getting all your tests
fixed.

If you are not using `ember CLI` you can use it too, check the instruction [here](https://github.com/abuiles/ember-watson#using-without-ember-cli).

## What's next for ember-watson?

Next I'd like to add support to [update Ember Data
finds](blog/2015/02/09/update-your-finds/) so we don't have to worry
about changes on the API, I think this one will be a bit more trickier
but not impossible, if you want to contribute you can find the repo in
[https://github.com/abuiles/ember-watson](https://github.com/abuiles/ember-watson).

**[Did you find this useful? Learn Ember and support my work at the same time buying my living book Ember CLI 101](https://leanpub.com/ember-cli-101).**