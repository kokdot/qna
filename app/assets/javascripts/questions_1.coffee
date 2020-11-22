# App.cable.subscriptions.create('QuestionChannel', {
#   connected: ->
#     console.log 'Connected!'
#     @perform 'follow'
#   ,
#   received: (data) ->
#     console.log 'received', data
# })
