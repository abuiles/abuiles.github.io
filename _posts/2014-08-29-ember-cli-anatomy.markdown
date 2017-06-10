---
layout: post
title: "ember-cli Anatomy"
date: 2014-08-29 13:30:05 -0500
comments: true
categories: ember-cli ember-cli-101 ember.js
---
Every new developer coming to Ember.js is probably using ember-cli,
but I've noticed that most of the time they are not fully aware of
ember-cli's main components and how they interact together so I took
this from my [ember-cli-101](https://leanpub.com/ember-cli-101) book
where I try to explain it.

`ember-cli` is a `Node.js` command line application sitting on top of
other libraries.

Its main component is [Broccoli](https://github.com/broccolijs/broccoli), which allows us to have fast builds,
`Broccoli` is a builder designed with the goal of keeping builds as
fast as possible (currently there are some issues on Mac which slows down the build time but there is work in progress to fix it).

When we run `ember server`, `Broccoli` compiles our project and put it
in a directory where it can be served using
[`Express.js`](http://expressjs.com/) which is a `Node.js` library.
`Express` is not only used to served files but also to extend
`ember-cli` functionality using its `middlewares`, an example of this
is the `http-proxy` which supports the `--proxy` option, allowing us
to develop against our development backend.

Testing is powered by `QUnit` and `Testem`, we can always navigate to
`http:/localhost:4200/tests` and our test will be run automatically.
We can also run Testem in `CI` or `--development` mode with the `ember
test` command. Currently there is just support for `QUnit` through an
`ember-cli add-on`, we will probably see support for other testing
frameworks and runners as people get familiar with the add-on system.

`ember-cli` uses it's [own
resolver](https://github.com/stefanpenner/ember-jj-abrams-resolver)
and has a different naming convention to `Ember.js's` defaults.

`ember-cli` makes us write our application using `ES6 Modules`, then the code gets transpiled (compiled)[1] to `AMD`[2] and finally it is loaded with `loader.js` which is a minimalist `AMD` loader.

If you want to use coffee script you can use it but it is encouraged
to use plain JS and ES6 where possible.

Finally we need to cover `Broccoli`'s plugins because without them,
`Broccoli` wouldn't be as helpful. Every transformation that your
files are going through, are done with a `Broccoli` plugin, e.g.
transpiling, minifying, finger-printing, uglifying. You can have your
own `Broccoli` plugins and plug it wherever you want in the build
process.


** [Learn how to write apps with Ember.js and ember-cli](https://leanpub.com/ember-cli-101) with my [ember-cli-101 book](https://leanpub.com/ember-cli-101).**


- [1]: The transpiring process is done with [es6-module-transpiler](https://github.com/esnext/es6-module-transpiler).
- [2]: To know more about `AMD` checkout [their wiki](https://github.com/amdjs/amdjs-api/wiki/AMD)