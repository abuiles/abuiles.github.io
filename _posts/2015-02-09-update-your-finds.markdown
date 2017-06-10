---
layout: post
title: "Update your finds"
date: 2015-02-09 11:40:52 -0500
comments: true
categories: Ember Ember-Data
---

A couple of months ago I wrote a post about `store.find` (
[Understading Ember-Data
Store#find](/blog/2014/11/04/understading-ember-data-store-find/)), in
that post I covered the different scenarios to use it and how it would
behave depending on the parameters.

Turns out that post will become useless soon thanks to the following
PR on Ember-Data https://github.com/emberjs/data/pull/2728.

The gist of it is:

1. If we want to fetch a record by id we'll use `store.find('friend', id)`
2. If we want to fetch all the records for a given type, we'll use `store.findAll('friend')`
3. If we want to fetch all records using query paremeters then we'll use `store.findQuery('friend', {good: true}`


We don't need to way until the PR has been merged to start updating
our code since `findAll` and `findQuery` are already part of the
store! They were only marked as private and used internally by `find`.

If you have been using Ember-Data for a while I understand this might
be annoying for you, but on the other side this is a step more towards
1.0 and having a better API,so, update your finds!

**[Getting started with Ember? I'm the author of a living book on Ember, learn Ember and ember-cli](https://leanpub.com/ember-cli-101) with [ember-cli-101](https://leanpub.com/ember-cli-101).**