---
layout: post
title: "Understading Ember-Data Store#find"
date: 2014-11-04 08:55:22 -0500
comments: true
categories: Ember.js Ember-Data
---
###Update: Don't worry about this, `store.find` has been simplified, read [Update your finds](/blog/2015/02/09/update-your-finds/).

<br/>
<br/>

`Store#find` (inject as `this.store.find`) is one of those methods in Ember-Data which
confuses people, especially since it behaves very different depending
on the parameters passed-in.

This article try to demystify `store.find` and explain how it will
behave accordingly to the parameters.

Let's have its definition on top and then use it as reference:

{% highlight javascript %}
find: function(type, id, preload) {
    Ember.assert("You need to pass a type to the store's find method", arguments.length >= 1);
    Ember.assert("You may not pass `" + id + "` as id to the store's find method", arguments.length === 1 || !Ember.isNone(id));

    if (arguments.length === 1) {
      return this.findAll(type);
    }

    // We are passed a query instead of an id.
    if (Ember.typeOf(id) === 'object') {
      return this.findQuery(type, id);
    }

    return this.findById(type, coerceId(id), preload);
}
{% endhighlight %}


We can use `find` to load a single record or a collection of records.

If you want to run the commands in the article, you can download the
following ember-cli application https://github.com/abuiles/borrowers and then
run `ember server` it will proxy all the API request to a public
API.

{% highlight bash %}
$ git clone https://github.com/abuiles/borrowers
$ cd borrowers
$ npm install && bower install
{% endhighlight %}


#### Scenario #1: Loading a collection

If we call `find` only with a model's name then it will make a request
to load a list of records of that type, the following is an example of
such request:

{% highlight javascript %}
friends =  $E.store.find('friend')

XHR finished loading: GET "http://localhost:4200/api/v2/friends".
{% endhighlight %}

First, in case you are wondering what `$E` is, I'm grabbing an
instance of the application router using the `ember-inspector`.

If we want to send query parameters with our request, we can pass an
object as second argument and every key on the object will be included
as parameter:

{% highlight javascript %}
friends =  $E.store.find('friend', {hasArticles: true, sort_by: 'created_at'})

XHR finished loading: GET "http://localhost:4200/api/v2/friends?hasArticles=true&sort_by=created_at".
{% endhighlight %}

In the previous request we asked `find` to load all the articles,
sending as parameters the key `hasArticles` and `sort_by`.

Like
[all](http://emberjs.com/api/data/classes/DS.Store.html#method_all)
and
[filter](http://emberjs.com/api/data/classes/DS.Store.html#method_filter)
the result from `find` is a `live array` too. When called it will make
a request to the server and then the collection will be updated if
more records are added or removed from the store.

I've seen people using the private methods `findQuery` and `findByIds`
like:

{% highlight javascript %}
   // Using the private function store.findQuery
   model: function (params) {
      return this.store.findQuery('friend', {hasArticles: true, sort_by: 'created_at'});
   }

   // Using the private funcion findByIds
   model: function (params) {
      return this.store.findByIds('friend', [1,2,3]);
   }
{% endhighlight %}


We should never rely on private functions, they are marked private for
a reason. Although [Igor Terzic](https://twitter.com/terzicigor)
pointed that `findQuery` might be marked as private by mistake.

We can achieve the same result using the method `find`:

{% highlight javascript %}
   model: function (params) {
      // bad
      // return this.store.findQuerygo('friend', {hasArticles: true, sort_by: 'created_at'});

      // Good
      return this.store.find('friend', {hasArticles: true, sort_by: 'created_at'})
   }

   model: function (params) {
      // bad
      // return this.store.findByIds('friend', [1,2,3]);

      // good
      return this.store.find('friend', {ids: [1,2,3]});
   }
{% endhighlight %}


#### Scenario #2: Loading a single record

We can also use `find` to load an specific record, to do that we'll
only need to pass the record `id` as second argument:

{% highlight javascript %}
$E.store.find('friend', 15)
XHR finished loading: GET "http://localhost:4200/api/v2/friends/15".
{% endhighlight %}

In the previous example we are loading the friend with id 15, the
`store` will only make a request to the server if the friend is not
available in the store, to understand this, let's go to
http://localhost:4200/friends and then on the console try the following:

{% highlight javascript %}
id = $E.store.all('friend').get('firstObject').id
$E.store.find('friend', id)
{% endhighlight %}

If we open our network tab, we'll see that the store didn't make any request
this time, the reason is that we asked for a friend which was already
loaded into the store.

Is important to mention that **find**, **all** and **filter** return
promises, when testing on the browser's console we don't have to worry
about it, but if we want to use the result in our application then we
need to keep this in mind.


**[Want to learn Ember.js? Enroll in my upcoming Ember.js workshop by buying my book](https://leanpub.com/ember-cli-101?utm_source=ed-store)**
