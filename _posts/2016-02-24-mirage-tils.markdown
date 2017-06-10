---
layout: post
title: "Mirage TILs"
date: 2016-02-24 11:36:38 -0500
comments: true
categories: ember ember-cli-mirage
---
This is not a post about tumor infiltrating lymphocytes (TILs). But
rather about the things I learn while moving all our acceptance tests
to Mirage.

The last time I looked at it was over a year ago, so I
was super impressed with all the new stuff [Sam has been working
on](https://github.com/samselikoff/ember-cli-mirage/blob/master/CHANGELOG.md). An
ORM, DB, request shortcuts, OMG so many cool stuff!

As part of the migration process I started to document the things that
I was learning and shared them with [my team](<https://envoy.com>) so
it was easier for everyone to pick up.

Without further ado, the following list compiles a bunch of things I
wanted to do and how I did it using ember-cli-mirage 0.2.0-beta.5.

<div id="table-of-contents">
<h3>TILs</h3>
<div id="text-table-of-contents">
<ul>
<li><a href="#orgheadline2">1. How can I check the serialized version of a model?</a>
<ul>
<li>
<ul>
<li><a href="#orgheadline1">1.0.1. What is this useful for?</a></li>
</ul>
</li>
</ul>
</li>
<li><a href="#orgheadline3">2. How do I make assertions in a request and build a new model with the serializer?</a></li>
<li><a href="#orgheadline4">3. Polymorphic models</a></li>
<li><a href="#orgheadline5">4. How to return a  204?</a></li>
<li><a href="#orgheadline8">5. Stop settings expectations inside requests.</a>
<ul>
<li><a href="#orgheadline6">5.1. before</a></li>
<li><a href="#orgheadline7">5.2. after</a></li>
</ul>
</li>
<li><a href="#orgheadline9">6. Stop matching against your "API format"</a></li>
</ul>
</div>
</div>

## How can I check the serialized version of a model?<a id="orgheadline2"></a>

    server.get('api/employee's, function(schema, request) {
      employee = schema.employee.find(1);
      this.serializerOrRegistry.serialize(employee, request);

      return foo;
    });

### What is this useful for?<a id="orgheadline1"></a>

As I was getting started with mirage, this was super helpful for
debugging, but also, at this point I'm not sure how to include
meta-data in the response, and one of our endpoints returns pagination
in the meta key. What I did was generate the payload and then add meta
manually.

    this.get('api/employees', function(schema, request) {
      let employees = schema.employee.all();
      let response =  this.serializerOrRegistry.serialize(employees, request);

      response.meta = {
        total: employees.length,
        totalPages: 1
      };


      return new Mirage.Response(200, {}, response);
    });

## How do I make assertions in a request and build a new model with the serializer?<a id="orgheadline3"></a>

As I was moving away from a mix of Factory Guy and Pretender, we had a
bunch of request where we were matching that it was "done" and then
returning a new model.

<https://github.com/samselikoff/ember-cli-mirage/issues/556>

    // import the following from mirage

    import BaseShorthandRouteHandler from 'ember-cli-mirage/route-handlers/shorthands/base';

    server.post('/api/employees', function(schema, request) {
      assert.ok(true, 'did post');

      let handler = new BaseShorthandRouteHandler(schema, this.serializerOrRegistry);

      return schema.employee.create(handler._getAttrsForRequest(request, 'employee'));
    })

## Polymorphic models<a id="orgheadline4"></a>

Let's say you have the models "car" and "motorcycle" which inherit
from "vehicle" and you want to return all available "vehicles" through
the end-point \`/api/vehicles\`. The following can help you.

    this.get('/api/vehicles', function(schema, request) {
      // fetch all the cars, it returns a mirage collection
      let collection = schema.car.all();

      // push all the motorcycles into the mirage collection
      collection.push(...schema.motorcycle.all());

      // Make sure there is a serializer for vehicle `ember g mirage-serializer vehicle`
      // since we are using JSONAPI, it will use the model.type to create the
      // final response.
      //
      // This will probably work only with JSONAPI :P

      collection.modelName = 'vehicle';

      return collection;
    });

## How to return a  204?<a id="orgheadline5"></a>

    server.delete('/api/employees/:id', function() {
      return new Mirage.Response(204);
    });

## Stop settings expectations inside requests.<a id="orgheadline8"></a>

Sam recommends to let mirage shortcut do their job and then match
against mirage's DB. Let's see an example.

### before<a id="orgheadline6"></a>

    andThen(function(){
      server.patch('/api/employee/1', function(schema, request) {
        var data = JSON.parse(request.requestBody).data;
        assert.equal(data.attributes.name, 'Sam', 'name is Sam');

        return new Mirage.Response(204);
      });
    });
    click('thing that fires post');

### after<a id="orgheadline7"></a>

The snippet above is removed letting mirage takes care of the patch
via shortcuts.

    andThen(function(){
      assert.equal(
        server.schema.employee.find(1).name,
        'tom',
        'Name is Tom'
      );
    });
    click('thing that fires put');
    andThen(function(){
      assert.equal(
        server.schema.employee.find(1).name,
        'Sam',
        'Name was updated to Sam'
      );
    });

Now we check against mirage's db that it was updated.

There are scenarios where we might still need to intercept the request
and do something inside of it, but for most of the cases we can let
mirage do its magic.

## Stop matching against your "API format"<a id="orgheadline9"></a>

Let's say we still want to have assertions inside requests. It is
common to see tests that depend on the API format, this can be really
problematic if we decide to change the format of our API. suppose we
are using AMS and have something like the following:

    server.post('/api/employees', function(schema, request){
      var employee = JSON.parse(request.requestBody).employee;

      assert.equal(employee.name, 'Sam Selikoff', 'foo woot buu');
      assert.equal(employee.phone_number, '+14159353143', 'number is persisted');

      // ...
    });

And then decide to move to JSON API.

    server.post('/api/employees', function(schema, request){
      var employee = JSON.parse(request.requestBody).data;

      assert.equal(employee.attributes.name, 'Sam Selikoff', 'foo woot buu');
      assert.equal(employee.attributes['phone-number'], '+14159353143', 'number is persisted');

      // ...
    });

But then realized everyone have been wrong and SOAP was actually what
we needed. If you have only 1 tests then this is not a problem but if
you have a lot of tests updating this is not a fun task.

Since mirage works with serializers, we can use that instead and then
stop worrying about the format of the payload. The following can be
used to achieve the same as the previous test, but this we don't care
if we are are using JSON API, AMS or SOAP.

    import BaseShorthandRouteHandler from 'ember-cli-mirage/route-handlers/shorthands/base';

    server.post('/api/employees', function(schema, request){
      let handler = new BaseShorthandRouteHandler(schema, this.serializerOrRegistry);
      let employee = handler._getAttrsForRequest(request, 'employee');

      // employee has been normalized to mirage's DB format.

      assert.equal(employee.name, 'Sam Selikoff', 'foo woot buu');
      assert.equal(employee.phoneNumber, '+14159353143', 'number is persisted');

      // ...
    });


## Wrapping Up

I hope you find this useful, and if you have your own mirage tricks,
let me know, I'll love to have them in my org-mode file
[here](<https://gist.github.com/abuiles/4a672ccc8b5371c09ea7>).

If you have problems with mirage, don't try to call Sam to that
number, I made that up. Hopefully we'll find soon who owns
\\#ember-cli-mirage on the Ember slack and make it public so we can all
talk about our ups and downs.

Finally, if you enjoy talking about APIs, IPAs, Ember and want to work
with me, at Envoy we are always hiring, check out [our jobs
page](<https://envoy.com/jobs/>).