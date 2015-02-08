class HomeView extends Backbone.View

    className: 'app-home'

    initialize: (options) ->
        @constructor.template = require './templates/index.jade'

    render: ->
        @$el.html @constructor.template()

module.exports = HomeView
