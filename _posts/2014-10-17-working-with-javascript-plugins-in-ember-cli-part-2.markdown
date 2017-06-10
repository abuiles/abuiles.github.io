---
layout: post
title: "Working With JavaScript Plugins in Ember-cli: Part 2"
date: 2014-10-17 09:16:04 -0500
comments: true
categories: Ember.js ember-cli ember-cli-101 JavaScript addons
---

On [part 1 of Working With JavaScript Plugins in
ember-cli](/blog/2014/10/03/working-with-javascript-plugins-in-ember-cli/)
, we explore how to work with JavaScript plugins which are still
distributed as globas and came up with a pattern for wrapping up
globals while using the module system.

In this article, we'll explore how to work with libraries which
include a named AMD distribution.

## Working with libraries with named AMD distributions.

Before the addons system exist the easiest way to distribute
JavaScript libraries to be consume in ember-cli was to have a distribution
with a named-AMD version, then importing such library using `app.import`
and whitelisting the library's exports.

On of the libraries distributed in this way is
[ic-ajax](https://github.com/instructure/ic-ajax/tree/v2.0.1/lib) an
"Ember-friendly `jQuery.ajax` wrapper", if we navigate to the
[lib/main.js](https://github.com/instructure/ic-ajax/blob/master/lib/main.js)
we'll notice that the source of the application is written with
`ES6` syntax but it is
[distributed](https://github.com/instructure/ic-ajax/tree/v2.0.1/dist)
in different formats so you can consume it like a global or in a
module format.

As mentioned in the previously post `loader.js` doesn't work with anonymous AMD
distributions so if we want to include `ic-ajax` we need to use the
`named-amd` output.

Let's create a new ember-cli project like `ember new amd-example`

Once the project has been created, let's go to the directory and run the following command

{% highlight bash %}
npm uninstall ember-cli-ic-ajax --save-dev
{% endhighlight %}

The library we just removed is an `ember-cli addon` which wraps all
the steps we are about to do but we won't be using it since we are
interested in learning how things are working under the hood and what
are we gaining when using the addon.

Next we need to add the library to bower, we can do so with `bower
install ic-ajax --save`, once installed let's import it in our
`Brocfile.js` as follows:

 {% highlight JavaScript %}
app.import('bower_components/ic-ajax/dist/named-amd/main.js');
{% endhighlight %}

`ic-ajax` default export is the `request` function which allows us to
make request and manage them as if they were promises, we'll use
`request` to pull data from our backend.

We'll be using ember-cli's `proxy` to connect to a public API from my [Ember.js book: ember-cli 101](https://leanpub.com/ember-cli-101), pull some data and then render it in the index template.

Let's start by creating an index route with the following command: `ember g route index` and then put the following content in `app/routes/index.js`:

{% highlight JavaScript %}
import Ember from 'ember';

//
// Here we are importing the default export from ic-ajax and assigning it to
// the variable request
//

import request from 'ic-ajax';

export default Ember.Route.extend({
  model: function()  {
    //
    // We'll be loading a collection from a resource called friends, it will
    // response with a JSON array which main key is friends
    //
    // We can see this response going to http://api.ember-cli-101.com/api/friends
    //

    return request('/api/friends').then(function(data){
      return {
        friendsCount: data.friends.length
      };
    });
  }
});
{% endhighlight %}

And then replace `app/templates/index.hbs` so it uses
`friendsCount`:

{% raw %}
```html
<h1>Total friends in api.ember-cli-101.com {{friendsCount}}</h1>
```
{% endraw %}

The previous code is correct but we'll see an error when running ember server, try the following:

{% highlight bash %}
$ ember server --proxy http://api.ember-cli-101.com
version: 0.0.46
Proxying to http://api.ember-cli-101.com
Livereload server on port 35729
Serving on http://0.0.0.0:4200
ENOENT, no such file or directory '/borrowers/tmp/tree_merger-tmp_dest_dir-KIfHrFRc.tmp/ic-ajax.js'
Error: ENOENT, no such file or directory '/borrowers/tmp/tree_merger-tmp_dest_dir-KIfHrFRc.tmp/ic-ajax.js'
...
{% endhighlight %}

At the beginning of the article we mentioned that part of the process
on consuming named AMD libraries was to use `app.import` and
`whitelist` the library's exports without explaining what we meant
with the later.

During the build process all our files under `app/` go through a
transformation step where the `ES6 Modules` are converted to `AMD format`,
when something like the following is found `import request from
'ic-ajax';` internally the tool in charge of transpiling the code,
checks if that is something already registered in the module system
and if not it tries to find the module and convert it to the proper
format, in the previous scenario it will try to find a file called
`ic-ajax.js`, but since it is a library we are including externally
such file doesn't exist hence causing the build to fail.

Whitelisting in this context means telling the tool in charge of
transforming our `ES6 Modules` to `AMD` that whenever `import request from
'ic-ajax'` is found, then assume is already included so it doesn't
try to resolve it.

To do so we pass an option called exports to `app.import` which
whitelist `ic-ajax` and and its `exports`. The exports are also used to whitelist variables in `JSHint`.

In the `Brocfile.js`, let's replace the call to `import` with the
following:

{% highlight JavaScript %}
app.import('bower_components/ic-ajax/dist/named-amd/main.js', {
  exports: {
    'ic-ajax': [
      'default',
      'defineFixture',
      'lookupFixture',
      'raw',
      'request',
    ]
  }
});
{% endhighlight %}

If we run `ember server --proxy http://api.ember-cli-101.com` we'll see that everything works and we'll see the friends count in our index visiting
[http://localhost:4200/](http://localhost:4200/)

### ember-cli-ic-ajax

We started the chapter by removing `ember-cli-ic-ajax` which is an
addon wrapping the call to import and include the exports for us, if
we inspect the
[index file in the addon](https://github.com/rwjblue/ember-cli-ic-ajax/blob/master/index.js#L18),
we'll notice that it has almost the same things we added to our
`Brocfile.js`.

Now that we understand how importing `named AMD libraries` works, we can
remove the `import` for `ic-ajax` from the `Brocfile.js` and use
it via the `addon`, let's run the following commands and then stop and
start the server, everything should work:

{% highlight bash %}
$ bower uninstall ic-ajax --save
$ npm i ember-cli-ic-ajax --save
{% endhighlight %}

### Protip

Did you know ember-cli has an `.ember-cli` file where you can specify the default value for some commands? Instead of passing `--proxy` all the time to our `ember server` command, we can edit the `.ember-cli` to include the proxy option as follows:

{% highlight javascript %}
{
  "disableAnalytics": false,
  "proxy": "http://api.ember-cli-101.com"
}
{% endhighlight %}

With that we can run `ember server` and it will read the `--proxy` option from the `.ember-cli` file.

**[Getting started with Ember.js? I'm writing an Ember.js book, learn Ember.js](https://leanpub.com/ember-cli-101) with [ember-cli-101](https://leanpub.com/ember-cli-101). Ping me on #ember-cli-101 in Freenode if you have any question about it**