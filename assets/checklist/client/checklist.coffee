Backbone = require 'backbone'

module.exports = class ChecklistView extends Backbone.View

    className: 'app-checklist'

    componentClassName: 'checklist'

    initialize: (options) ->
        @router = options.router
        @constructor.template = require '../templates/checklist.jade'
        @listenTo @model, 'sync', @render

    render: ->
        @$el.html @constructor.template @model.toJSON()
