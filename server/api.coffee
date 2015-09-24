'use strict'
bodyParser = require 'body-parser'
express = require 'express'
http = require 'http'
logger = require 'morgan'
Path = require 'path'
# Notre fonction de démarrage serveur

module.exports = (port, path, callback) ->
  console.log 'starting server'
  app = express()
  server = http.createServer(app)
  # Stockage en mémoire des entrées gérées via REST
  items = []
  # Middlewares de base : fichiers statiques, logs, champs de formulaire
  app.use express.static(Path.join(__dirname, path))
  app.use logger('dev')
  app.use bodyParser.urlencoded(extended: true)
  # GET `/items` -> JSON du tableau des entrées
  app.get '/items2', (req, res) ->
    res.json items
    return
  app.get '/items', (req, res) ->
    res.json items
    return
  # POST `/items` -> Ajout d’une entrée d’après le champ `title`
  app.post '/items', (req, res) ->
    item = (req.body.title or '').trim()
    if !item
      return res.status(400).end('Nope!')
    items.push item
    res.status(201).end 'Created!'
    return
  # Mise en écoute du serveur sur le bon port, notif à Brunch une fois
  # prêts, grâce à `callback`.
  server.listen port, callback
  console.log 'listening on port : '+port
  console.log 'serving path : '+path
  return

