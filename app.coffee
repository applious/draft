express = require 'express'
path = require 'path'
express = require 'express'
stylus = require 'stylus'
eco = require 'eco'
fs = require 'fs'

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

module.exports = (options) ->
  app = express.createServer()

  { cwd, port, src, dest } = options

  app.configure ->
    destPath = path.join(cwd, dest)
    srcPath = path.join(cwd, src)

    unless path.existsSync(srcPath)
      fs.mkdirSync(srcPath)

    copyDirStructureSync(srcPath, destPath)

    @use stylus.middleware
      debug: true
      src: srcPath
      dest: destPath
    @use express.compiler
      src: srcPath
      dest: destPath
      enable: ['coffeescript']
    @use express.static(destPath)
    @use express.favicon(path.join(destPath, 'favicon.png'))
    @register '.eco', eco
    @set 'view engine', 'eco'
    @set 'view options', layout: 'layout'
    @set 'views', path.join(srcPath, 'templates')
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
