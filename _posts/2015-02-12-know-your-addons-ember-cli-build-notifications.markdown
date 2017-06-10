---
layout: post
title: "Know your addons: ember-cli-build-notifications"
date: 2015-02-12 11:29:12 -0500
comments: true
categories: ember-cli ember-cli-addons ember
---
As today [emberaddons.com](http://www.emberaddons.com) registers 602
(and growing) ember-cli addons distributed via NPM, this means that
addons and ember-cli are starting to become the de-facto tools to
share and build  application code.

Addons allows us to do a bunch of different things and it seems to me
that people are not fully aware of all the scenarios where they can be
used. If your answer to any of the following question is yes, then use an addon.

<br/>

- Do you want to write a component that can be used in thousands of different apps?
- Do you want to plug in the build system and do something cool with the result?
- Do you want to extend the generators?
- Do you want to share parts of your code between different apps?

<br/>

If you know that I wrote a book about Ember (and ember-cli), you might
be thinking: "ok, now you are going to tell me that if I want to
learn all this then I should buy your book" No! I'm not [*](#learn-ember)!

This post is actually to introduce a new experiment I want to start
called "Know your addons", I'll be covering different addons that I
find useful and go a bit into their implementation and mention things
that you could find worthwhile.

## ember-cli-build-notifications

I'd like to start with
[ember-cli-build-notifications](https://www.npmjs.com/package/ember-cli-build-notifications)
an useful addon to display notifications when there is a build error.

![ember-cli-build-notifications](https://s3.amazonaws.com/f.cl.ly/items/3m0843433l1F0J0m1M3p/example.png)

### How?

Philip Dudley is the creator of this addon and the code can be found in [GitHub](https://github.com/pdud/ember-cli-build-notifications).

The important file to look at for this addon is the [index.js](https://github.com/pdud/ember-cli-build-notifications/blob/master/index.js) which is the main entry point for the addon.

{% highlight javascript %}
/* jshint node: true */
'use strict';

var notifier = require('./lib/notify');

module.exports = {
  name: 'ember-cli-build-notifications',

  buildError: function(error) {
    notifier.notify({
      title: 'Build Failed',
      subtitle: error.file,
      message: error.toString()
    });
  }
};
{% endhighlight %}


When installed in your ember-cli project's `package.json`, it will be
identified as add addon because of the keyword `"ember-addon"` Once it
loads, Philip is using the [buildError
hook](https://github.com/ember-cli/ember-cli/blob/6c66d2f28ade2e3c58974c353498048a8a55ef4a/ADDON_HOOKS.md#builderror)
which gets called every time the build errors and then as soon as it
gets called it uses his notify implementation to show us the message. Clever right?

So the next time your boss forces you to notify them every time that crazy ember-cli build fails, you can write your own addon which will use the `buildError` to automate the process:

{% highlight javascript %}
/* jshint node: true */
'use strict';

var bossNotifier = require('./lib/notifier');

module.exports = {
  name: 'boss-notifier',

  buildError: function(error) {
    bossNotifier.notify({
      title: 'The build failed, it was not my fault',
      subtitle: error.file,
      message: error.toString()
    });
  }
};
{% endhighlight %}

**<a name="learn-ember"></a>Actually you should :), Learn Ember with my book, check it out [leanpub.com/ember-cli-101](https://leanpub.com/ember-cli-101) or [subscribe to my list for the free webinars](/ember-rails)**
