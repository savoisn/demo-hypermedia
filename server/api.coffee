'use strict'
bodyParser = require 'body-parser'
express = require 'express'
hal = require 'express-hal'
http = require 'http'
logger = require 'morgan'
Path = require 'path'
_ = require 'lodash'
TodoService = require './services/todoService'
# Notre fonction de démarrage serveur

module.exports = (port, path, callback) ->
  console.log 'starting server'
  app = express()
  app.use(hal.middleware)


  server = http.createServer(app)
  # Stockage en mémoire des entrées gérées via REST
  items = []
  # Middlewares de base : fichiers statiques, logs, champs de formulaire
  console.log "serving path : "+path, Path.join(__dirname, '../'+path)
  app.use express.static(Path.join(__dirname, '../'+path))
  app.use logger('dev')
  #app.use bodyParser.urlencoded(extended: true)
  app.use bodyParser.json()
  # GET `/items` -> JSON du tableau des entrées
  app.get '/api/items1', (req, res) ->
    res.hal({
      data:{monitem:{size:'large', type:'fake'}},
      links:{
        self:'/items1',
        next:'items1?page=2',
        find:{href: "/items1{?id}", templated: true}
      }
      embeds:{
        "orders":[
          {
            data:{
                total:    30.00,
                currency: "USD",
                status:   "shipped"
            },
            links: {
                self:     "/orders/123",
                basket:   "/baskets/98712",
                customer: "/customers/7809"
            }
          },
          {
            data: {
                total:    20.00,
                currency: "USD",
                status:   "processing"
            },
            links: {
                self:     "/orders/124",
                basket:   "/baskets/97213",
                customer: "/customers/12369"
            }
          }
        ]
      }
    })
    return

  app.get '/api/',(req,res) ->
    res.json ({
      "_links": {
        self: {
          "href": "/"
        }
        "todos": {
          "templated": true,
          "href": '/todos{?search}'
        }
        "todo": {
          "templated": true,
          "href": '/todo{/id}'
        }
      }
    })
    return
  lastTodoId=4
  todos = [
    {
      id:1
      text:"first todo"
      done:false
      user:235
    }
    {
      id:2
      text:"second todo"
      done:false
      user:345
    }
    {
      id:3,
      text:"third todo"
      done:false
      user:456
    }
    {
      id:4
      text:"forth todo"
      done:false
      user:567
    }
  ]

  app.get '/api/todo',(req,res) ->
    res.json ({
      "_links": {
        self: {
          "href": "/todo"
        }
      }
      "matodo":{
        "name":"coucou"
        "date":"20150612"
      }
    })
    return

  app.get '/api/todos',(req,res) ->
    res.hal TodoService.halTodos(todos)
    return

  app.post '/api/todo', (req, res) ->
    console.log req.body
    todo = req.body
    if !todo.text? or !todo.done?
      return res.status(400).end('Nope!')
    lastTodoId++
    todo.id=lastTodoId
    todos.push todo
    res.status(201).end 'Created!'
    return

  app.delete '/api/todo/:id', (req, res) ->
    todoId = parseInt(req.params.id)
    if !todoId
      return res.status(400).end('Nope!')
    _.remove(todos, {'id': todoId})
    res.status(201).end 'Deleted!'
    return

  app.get '/api/items', (req, res) ->
    res.json items
    return
  # POST `/items` -> Ajout d’une entrée d’après le champ `title`
  app.post '/api/items', (req, res) ->
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

