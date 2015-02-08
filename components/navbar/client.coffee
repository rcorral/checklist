class NavbarView extends Backbone.View

    events:
        'click .js-route': 'handleRouteClick'

    initialize: (options) ->
        @constructor.template ?= require './navbar.jade'

        @model = options.model
        @listenTo @model, 'change:activeComponent', @render

        @$header = $ 'header'
        @$header.empty()

    render: ->
        activeComponent = @model.get 'activeComponent'

        context = {}
        context["#{activeComponent}Active"] = true
        @$header.html @constructor.template context
        @setElement $ 'header nav'

    handleRouteClick: (e) ->
        $el = $ e.currentTarget
        @model.get('router').navigate $el.attr('href'),
            trigger: true
        false

module.exports = NavbarView
