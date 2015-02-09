Util = require '../../../components/Util/index.coffee'

module.exports = class ChecklistsView extends Backbone.View

    className: 'app-checklists'

    events:
        'click .js-view-checklist': 'handleViewChecklist'
        'click .js-create-checklist': 'handleCreateChecklist'

    initialize: (options) ->
        @router = options.router
        @constructor.template = require '../templates/checklists.jade'
        @listenTo @collection, 'sync', @render

    render: ->
        @$el.html @constructor.template @collection.forTemplate()

    handleViewChecklist: (e) ->
        e.preventDefault()
        id = $(e.currentTarget).data 'id'
        checklist = @collection.get id
        @router.navigate checklist.frontEndUrl(), trigger: true
        Util.scrollToTop()

    handleCreateChecklist: ->
        @router.navigate 'checklists/create', trigger: true
        false
