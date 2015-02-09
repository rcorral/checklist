class HomeView extends Backbone.View

    className: 'app-home'

    events:
        'click .js-create-checklist': 'handleCreateChecklist'

    initialize: (options) ->
        @router = options.router
        @constructor.template = require './templates/index.jade'

    render: ->
        @$el.html @constructor.template()

    ###
    # Handlers
    ###

    handleCreateChecklist: ->
        @router.navigate 'checklists/create', trigger: true
        false

module.exports = HomeView
