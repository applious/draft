express = require 'express'
path = require 'path'
compiler = require "#{__dirname}/lib/compiler"
stylus = require 'stylus'
http = require 'http'
eco = require 'eco'
fs = require 'fs'

module.exports = (options) ->
  parseArgs = (args) ->
    args = args[2..]
    options = {}
    i = 0
    while i < args.length
      options[args[i++]] = args[i++]
    return options

  copyDirStructureSync = (srcPath, destPath) ->
    srcPathStat = fs.statSync(srcPath)
  
    try
      fs.mkdirSync(destPath, srcPathStat.mode)
    catch err
      throw err if err.code isnt 'EEXIST'
  
    filePaths = fs.readdirSync(srcPath)
  
    for filePath in filePaths
      srcFilePath = path.join(srcPath, filePath)
      fileStat = fs.statSync(srcFilePath)
  
      if fileStat.isDirectory()
        destFilePath = path.join(destPath, filePath)
        copyDirStructureSync(srcFilePath, destFilePath)

  options = parseArgs(process.argv)  
  port = options['--port'] or 8000
  directory = options['--dir'] or process.cwd()
  dest = options['--public'] or 'public'
  src = options['--src'] or 'src'
  destPath = path.resolve(directory, dest)  
  srcPath = path.resolve(directory, src)

  unless path.existsSync(srcPath)
    fs.mkdirSync(srcPath)

  copyDirStructureSync(srcPath, destPath)

  app = express()
  app.use(express.bodyParser()) # pre-parses JSON body responses
  app.use(express.errorHandler(stack: true, message: true, dump: true))
  app.use(express.favicon(path.join(destPath, 'favicon.png')))
  app.use(express.logger(format: '[:date] [:response-time] [:status] [:method] [:url]'))
  app.use(express.static(destPath))

  app.use(compiler(src: srcPath, dest: destPath, enable: ['coffeescript'])) # looks for cs files to render as js

  app.use(stylus.middleware(debug: true, src: srcPath, dest: destPath))

  app.get '/', (req, res) ->
    res.render 'index'

  app.get /^\/(.+?)\.html$/, (req, res) ->
    res.render req.params[0]


  server = http.createServer(app)
  server.listen port, ->
    console.log "Server at http://localhost:#{port}"
