'use strict'

app = require '../server/api'
console.log 'coucou2'
console.log app
app 3333, 'public', (ret)->
  console.log ret
