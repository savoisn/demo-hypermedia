'use strict'

### Sevices ###

angular.module('app.services', ['angular-hal'])

.factory 'version', ->
  "0.1"

.factory 'api', (halClient)->
  'load' : ->
    return halClient.$get('api/')
