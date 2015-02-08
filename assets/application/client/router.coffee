class Router extends Backbone.Router

    routes:
        '': 'home'
        'checklists': 'checklists'
        'checklists/create': 'checklist'
        'checklists/:id': 'checklist'

    home: ->
        @trigger 'navigate:home', 'home'

    checklists: ->
        @trigger 'navigate:checklists', 'checklists'

    checklist: (id) ->
        @trigger 'navigate:checklist', id

module.exports = Router
