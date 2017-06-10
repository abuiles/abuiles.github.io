---
layout: post
title: "Working with JavaScript plugins in ember-cli"
date: 2014-10-03 12:09:10 -0500
comments: true
categories: Ember.js ember-cli ember-cli-101 JavaScript
---



In this post we'll use momentjs to write an Ember helpers called
`formatted-date` which we'll be using in our templates to render
dates as `September 28, 2014` instead of `Sun Sep 28 2014 04:58:30
GMT-0500`

** This post is extracted from my Ember.js book: [ember-cli-101](https://leanpub.com/ember-cli-101)**

## Installing moment

ember-cli uses Bower to manage frontend dependencies (we can also use
addons but that's a different story), the simplest way to consume a
library is to add it via bower and then use `app.import` in our
`Brocfile.js`.

Assuming you have ember-cli already install, create a project doing `ember new deps-demo`.


Once npm is done, install `moment` with

{% highlight bash %}
$ bower install moment --save
{% endhighlight %}

The option `--save` adds the dependency to our `bower.json`, we
should find something similar to `"moment": "~2.8.3"` (the version
might be different).

Next, let's import `moment`, to know which file to import we can go
to `bower_components/moment/` and we'll see that it has a
`moment.js` file which is the non-minified version of the library or
we can point to any of the version under the directory `min/`, for
now let's use the non-minified.


Let's add the following to our `Brocfile.js`:

```
app.import('bower_components/moment/moment.js');
```

Next, if we start our application with `ember server`, and navigate to
[http://localhost:4200](http://localhost:4200), open the console and
type "moment", we should have access to the `moment` object.

With that we have successfully included our first JavaScript plugin,
but there are some gotchas we need to be aware of.

## It's a global!

ember-cli fosters the use of `ES6 Modules`, so it feels like giving a
step backwards if we add a library and then use it through its global,
right?.

The sad news is that not all libraries are written in such way that
they can be consumed easily via a modules loader, and even so if there is
an `AMD` definition included in the library not all of them are
compatible with the modules loader used by `ember-cli`.


For example, `moment` includes an `AMD` version

{% highlight javascript %}
...
} else if (typeof define === 'function' && define.amd) {
    define('moment', function (require, exports, module) {
        if (module.config && module.config() && module.config().noGlobal === true) {
            // release the global variable
            globalScope.moment = oldGlobalMoment;
        }

        return moment;
    });
{% endhighlight %}


But unfortunately the stable version of loader.js doesn't support that
yet.

Other libraries do the following:

{% highlight JavaScript %}
define( [], function() {
	return lib;
});
{% endhighlight %}

That's is known as an anonymous module and even though it's syntax is
valid, loader.js doesn't support that either since it expects
named modules.

This whole problem is not really ember-cli's fault but the fact
everyone is building their libraries in different formats making hard
for consumers to use.

On the ember-cli side there is work in progress so in a near future
people will be able to use `moment` or other JavaScript libraries via
`import` but the integration is not ready yet. See
[ember-cli#2177](https://github.com/stefanpenner/ember-cli/issues/2177)
for more info.

So, what can we do about it?

## Wrapping globals

Instead of consuming globals directly let's wrap then in a helper
module which will help us foster the use of modules and also update or
replace easily `moment` once we have a way to load it via the module
loader.

First, let's create an utils file called `date-helpers`:

{% highlight bash %}
$ ember g util date-helpers
installing
  create app/utils/date-helpers.js
installing
  create tests/unit/utils/date-helpers-test.js
{% endhighlight %}

Replace `app/utils/date-helpers.js` with the following:

{% highlight javascript %}
function formatDate(date, format) {
  return window.moment(date).format(format);
}

export default {
  formatDate
}
{% endhighlight %}


Here we are wrapping the call to `moment#format` in the function
`format` which we can consume doing `import { formatDate } from
'utils/date-helpers';`, with that we are back to our idea of using
modules, and also we'll have the facility to update easily `moment`
when our loader is ready to load it.

Also if we decide to stop using `moment` and replace it with any
other library which does the same, we don't need to change our
consuming code since it doesn't care how `format-date` is being
implemented.

## Writing an Ember helper: formatted-date.

Helpers are pieces of code that help us augment our templates, in this
case we want to write a helper to have a a date as a formatted string.

`ember-cli` includes a generator for helpers too, so let's create
`formatted-date` with the command `ember g helper formatted-date`, and
then modify `app/helpers/formatted-date` so it consumes our format
function.

{% highlight javascript %}
import Ember from 'ember';

// We are consuming the function defined in our utils/date-helpers.
import { formatDate } from '../utils/date-helpers';

export default Ember.Handlebars.makeBoundHelper(function(date, format) {
  return formatDate(date, format);
});
{% endhighlight %}

Once we have our helper defined, we can use it in our templates like

{% raw %}
```html
{{formatted-date createdAt 'LL'}}
```
{% endraw %}

# Wrapping up

This is the first one of a 3 series articles on consuming JavaScript
libraries, here we cover the first scenario about consuming libraries
which distribution can't be consumed with loader.js. Next we'll
explore and understand how to consume libraries distributed in AMD.

**[Getting started with Ember.js? I'm writing an Ember.js book, learn Ember.js and ember-cli](https://leanpub.com/ember-cli-101) with [ember-cli-101](https://leanpub.com/ember-cli-101).**

**Looking for an Ember.js Coach? [Hire me](http://blog.abuiles.com/emberjs-consulting/)  and I'll help your team stay in the flow with my unlimited support plan**
