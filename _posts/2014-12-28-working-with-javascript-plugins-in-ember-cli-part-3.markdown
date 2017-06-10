---
layout: post
title: "Working With JavaScript Plugins in Ember-cli: Part 3"
date: 2014-12-28 09:17:46 -0500
comments: true
categories: Ember.js ember-cli ember-cli-101 JavaScript addons
---
On [part 1 of Working With JavaScript Plugins in
ember-cli](/blog/2014/10/03/working-with-javascript-plugins-in-ember-cli/)
, we explore how to work with JavaScript plugins which are still
distributed as globas and came up with a pattern for wrapping up
globals while using the module system.

On [part 2](/blog/2014/10/17/working-with-javascript-plugins-in-ember-cli-part-2/)
we explored how to work with libraries including a a named AMD
distribution via `app.import`.

In this article, we'll explore how to work with libraries via npm and
browserify.

## ember-browserify

[Browserify](http://browserify.org/) is a Node library which allows us
to consume other Node libraries in the Browser using CommonJS (which
is Node's module system), what this means is that we can install
libraries like MomentJS using npm and then consume them in the browser
via browserify. But wait, to use Browserify we actually need to
install the library and create a "bundle" with our
dependencies, normally we'll run something like `browserify main.js -o
bundle.js` and then use `bundle.js` via a script tag `<script
src="bundle.js"></script>`.

As we can imagine this can get tricky and hard to manage in our
ember-cli application, but thanks to
[Edward Faulkner](https://github.com/ef4) there is addon which allow
us to consume libraries from npm with browserify without needing us to
worry about the bundling process, it is called [ember-browserify](https://github.com/ef4/ember-browserify).

### Using ember-browserify

First we need to install the addon, which we can do running `ember
install`:

```
$ ember install:addon ember-browserify
```

Once the addon has been installed, we are going to use it to consume
MomentJS from npm in our `data-helpers` file.

Before doing that, let's make sure we have removed `moment` from our
`bower.json` and also that we have removed
`app.import('bower_components/moment/moment.js');` from the
`Brocfile`.

Next, let's install moment via npm, which we can do with `npm install
moment --save-dev`.

Once it has been installed we can consume it from npm thanks to
ember-browserify just doing `import moment from 'npm:moment';`.

Let's use it in our `date-helpers` so `formatDate` uses `moment`.

{% highlight javascript %}
import moment from 'npm:moment';

function formatDate(date, format) {
  return moment(date).format(format);
}

export {
  formatDate
};
{% endhighlight %}

And that's it, we are now consuming MomentJS via browserify just as if
it was other module in our application.

**[Learning Ember.js? Get my book or enroll in my upcoming workshops.](https://leanpub.com/ember-cli-101)
