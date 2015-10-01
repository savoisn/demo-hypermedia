

TodoService = {}
TodoService.todoUrl='/api/todo/'
TodoService.userUrl='/api/user/'
TodoService.todosUrl='/api/todos/'

TodoService.halTodos = (todos)->
  newHalTodos=[]
  for todo in todos
    newHalTodos.push TodoService.halTodo(todo)

  return {
    data:{todos}
    links:{
      self:TodoService.todosUrl
    }
    embeds:{
      "todos":newHalTodos
    }
  }


TodoService.halTodo = (todo) ->
  newHalTodo = {
    todo
    links:{
      self:TodoService.todoUrl+todo.id
      user:TodoService.userUrl+todo.user
    }
  }

module.exports = TodoService
