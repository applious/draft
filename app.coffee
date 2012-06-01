express = require 'express'
path = require 'path'
express = require 'express'
stylus = require 'stylus'
eco = require 'eco'

module.exports = (options) ->
  app = express.createServer()

  { cwd, port } = options

  app.configure ->
    public_path = path.join(cwd, 'public')
    src_path = path.join(cwd, 'src')
    @use stylus.middleware
      debug: true
      src: src_path
      dest: public_path
    @use express.compiler
      src: src_path
      dest: public_path
      enable: ['coffeescript']
    @use express.static(public_path)
    @use express.favicon(path.join(public_path, 'favicon.png'))
    @register '.eco', eco
    @set 'view engine', 'eco'
    @set 'view options', layout: 'layout'
    @set 'views', template_path = path.join(src_path, 'templates')
    @use express.errorHandler
      stack: true
      message: true
      dump: true
    @use express.logger 'dev'

  app.get '/', (req, res) ->
    res.render 'index'

  app.get /^\/(.+?)\.html$/, (req, res) ->
    res.render req.params[0]

  app.listen(port)
  console.log "listening on :#{port}..."
