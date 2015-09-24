'use strict'

### Controllers ###

angular.module('app.controllers', [])

.controller('AppCtrl', [
  '$scope'
  '$location'
  '$resource'
  '$rootScope'
  'api'

($scope, $location, $resource, $rootScope, api) ->

  $scope.reload = ->
    api.load().then (data) ->
      data.$get('todos')
    .then (todo)->
      if todo?
        $scope.todos=todo.todos

  $scope.reload()
  $scope.$on 'reload_todos', (event, args)->
    console.log 'event received '+args
    if args is 0
      $scope.reload()

  $scope.todos = [
    text: "learn angular"
    done: true
  ,
    text: "build an angular app"
    done: false
  ]
  # Uses the url to determine if the selected
  # menu item should have the class active.
  $scope.$location = $location
  $scope.$watch('$location.path()', (path) ->
    $scope.activeNavId = path || '/'
  )

  # getClass compares the current url with the id.
  # If the current url starts with the id it returns 'active'
  # otherwise it will return '' an empty string. E.g.
  #
  #   # current url = '/products/1'
  #   getClass('/products') # returns 'active'
  #   getClass('/orders') # returns ''
  #
  $scope.getClass = (id) ->
    if $scope.activeNavId.substring(0, id.length) == id
      return 'active'
    else
      return ''


])

.controller('MyCtrl1', [
  '$scope'

($scope) ->
  $scope.onePlusOne = 2
])

.controller('MyCtrl2', [
  '$scope'

($scope) ->
  $scope
])

.controller('TodoCtrl', [
  '$scope'
  'api'

($scope,api) ->

  $scope.addTodo = ->
    api.load().then (data) ->
      data.$post('todo', null ,{text:$scope.todoText,done:false})
    .then (todo)->
      $scope.$emit 'reload_todos',0
      console.log 'created'
      $scope.todoText = ""

  $scope.remaining = ->
    count = 0
    angular.forEach $scope.todos, (todo) ->
      count += (if todo.done then 0 else 1)

    count

  $scope.archive = ->
    oldTodos = $scope.todos
    $scope.todos = []
    asyncCounter=0
    angular.forEach oldTodos, (todo) ->
      if todo.done
        asyncCounter++
        api.load().then (data) ->
          data.$del('todo',{id:todo.id})
        .then (todo)->
          $scope.$emit 'reload_todos',--asyncCounter

])

