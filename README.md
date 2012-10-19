DRAFT
=====

A draft site scaffold for rapid front-end development. Its a simple static node server for our front-end stack (coffee-script and stylus).

Can run a static site in any directory from a single server: `draft --port 8000`

Options
-------
* --port (number)   // the port number, defaults to 8000
* --dir (string)    // the directory path, defaults to the directory you are in
* --src (string)    // the source folder, defaults to 'src'
* --public (string) // the public folder, defaults to 'public'

Examples
--------

* `draft`
* `draft --port 8000`
* `draft --src bin --public www`
* `draft --dir /Projects/MyApp/ --port 8000`
* `sudo draft --port 80`

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