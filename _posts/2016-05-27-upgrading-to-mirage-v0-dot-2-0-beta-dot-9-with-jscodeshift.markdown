---
layout: post
title: "Upgrading mirage with JSCodeshift"
date: 2016-05-27 09:24:25 -0500
comments: true
categories: ember ember-cli-mirage
---

If you have been using the beta release of mirage, chances are that
you haven't made the jump from beta.7 to beta.9 because some of the
breaking deprecations.

The deprecations are not super complicated but if you have a lot of
tests files then it can be a very boring and task consuming task.

Instead of fixing my code manually, I thought about my old friend
[recast](https://github.com/benjamn/recast) to automate the whole
process , but then I remembered this "new" tool called
[jscodeshift](https://github.com/facebook/jscodeshift) which offers a
nice API on top of recast to do code modifications.

The following script help us with the first deprecation [listed
here](https://github.com/samselikoff/ember-cli-mirage/releases/tag/v0.2.0-beta.9)
which is pluralizing all the schema models. If we have something like
`schema.user.all()` or `server.schema.user.all()` then after running
the script we'll have `schema.users.all()`.

<script src="https://gist.github.com/abuiles/f15539c683e2121a3027b220073569b0.js"></script>

To run the script we need to install the following npm packages:

```
npm install -g jscodeshift
npm install inflected
```

For the second breaking deprecation which was calling `.models` on
`Collections`, I decided not to use
codeshift since it would be faster for me to just use perl:

```
find . -type f | xargs perl -pi -e 's/all\(\)\.length/all\(\)\.models\.length/g'
find . -type f | xargs perl -pi -e 's/all\(\)\.forEach/all\(\)\.models\.forEach/g'
```

I hope you find this useful and if come up with a `codeshift` solution
please let me know and I'll link it here.


**[Do you Want to learn about JSONAPI? Check out my book JSONAPI By Example.](https://leanpub.com/json-api-by-example)**
