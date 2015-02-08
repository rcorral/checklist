Util = require '../../../components/Util/index.coffee'

module.exports = class ChecklistsView extends Backbone.View

    className: 'app-checklists'

    initialize: (options) ->
        @router = options.router
        @constructor.template = require '../templates/checklists.jade'

    render: ->
        @$el.html @constructor.template @collection.forTemplate()
