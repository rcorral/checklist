class Router extends Backbone.Router

    routes:
        '': 'home'

    home: -> @trigger 'navigate:home', 'home'

module.exports = Router
