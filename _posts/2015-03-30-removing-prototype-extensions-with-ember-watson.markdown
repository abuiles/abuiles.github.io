---
layout: post
title: "Removing prototype extensions with ember-watson"
date: 2015-03-30 10:34:20 -0500
comments: true
categories: ember-cli ember-cli-addons ember
---
If you follow Ember folks on twitter you might have noticed that a
bunch of them keep talking about something called prototype extensions
and disabling them. What's that? without getting into much details is
what allow us to set observers or computed properties calling
`.observes` or `property` at the end of a function.

Recently a pull request [1] was open by Stefan Penner to encourage the
use of decorator styles for declaring observers and computed
properties, in means that instead of declaring our computed properties
and observers like:

{% highlight JavaScript %}
fullName: function() {
  // make fullName
}.property('model.firstName', 'model.lastName'),
doSomething: function() {
  // do something
}.observes('model.firstName', 'model.lastName')
{% endhighlight %}

We'll use the following syntax

{% highlight JavaScript %}
fullName: Ember.computed('model.firstName', 'model.lastName', function() {
  // make fullName
}),
doSomething: Ember.observer('model.firstName', 'model.lastName', function() {
  // do something
})
{% endhighlight %}

If you are like "OMG! that Stefan guy is crazy! I have like 1000
computed properties and observers" then no worries, good tool
[ember-watson](https://github.com/abuiles/ember-watson) got you
covered.

Thanks to [@kamal](twitter.com/kamal) we can update our code
automatically running the following commands:

{% highlight bash %}
npm install ember-watson@latest --save-dev
ember watson:convert-prototype-extensions
{% endhighlight %}

**Also, if you have 1000 observers then think you have $10000 in debt
(more about that later).**

**[Do you want to learn Ember with a private tutor? Get my living book Ember CLI 101 and keep your Ember knowledge up to date](https://leanpub.com/ember-cli-101)**

[1] - https://github.com/emberjs/guides/pull/110
