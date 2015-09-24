'use strict'

app = require '../server/api'
console.log 'coucou2'
console.log app
app 3030, 'public', (ret)->
  console.log ret
