DRAFT
=====

A draft site scaffold for rapid front-end development. Its a simple static node server for our front-end stack (coffee-script and stylus).

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
and html. A `src` directory with compilable coffee-script and stylus files.

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