DRAFT
=====

A draft site scaffold for rapid front-end development. Its a simple static node server for our front-end stack (coffee-script, stylus, eco).

Can run a static site in any directory from a single server: `draft --port 8000`


Examples
--------

* `draft`
* `draft --port 8000`
* `draft -p 80`
* `draft --port 8000 ~/Projects/MyApp/`


Expects
-------

A `public` directory with any static assets such as javascript, css
and html. A `src` directory with compilable files such as coffee-script, stylus, eco.

Eco templates should be inside a `templates` directory in `src` and
may optionally provide a parent template (`layout.eco`) to be applied
to all templates.

Example file structure:

* public/
  * index.html
  * styles/
    * home.css
  * scripts/
    * jquery.js
    * main.js
* src/
  * styles/
    * home.styl
  * scripts/
    * main.coffee
  * templates/
    * layout.eco
    * about.eco
