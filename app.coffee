express = require 'express'
path = require 'path'
compiler = require "#{__dirname}/lib/compiler"
stylus = require 'stylus'
http = require 'http'

module.exports = (options) ->
  app = express()

  { cwd, port } = options

  publicPath = path.join(cwd, 'public')
  srcPath = path.join(cwd, 'src')

  app.use(express.bodyParser()) # pre-parses JSON body responses
  app.use(express.errorHandler(stack: true, message: true, dump: true))
  app.use(express.favicon(path.join(publicPath, 'favicon.png')))
  app.use(express.logger(format: '[:date] [:response-time] [:status] [:method] [:url]'))
  app.use(express.static(publicPath))

  app.use(compiler(src: srcPath, dest: publicPath, enable: ['coffeescript'])) # looks for cs files to render as js

  app.use(stylus.middleware(debug: true, src: srcPath, dest: publicPath))

  app.get '/', (req, res) ->
    res.render 'index'

  app.get /^\/(.+?)\.html$/, (req, res) ->
    res.render req.params[0]


  server = http.createServer(app)
  server.listen port, ->
    console.log "Server at http://localhost:#{port}"