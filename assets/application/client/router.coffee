class Router extends Backbone.Router

    routes:
        '': 'home'
        'checklists': 'checklists'

    home: -> @trigger 'navigate:home', 'home'
    checklists: -> @trigger 'navigate:checklists', 'checklists'

module.exports = Router
