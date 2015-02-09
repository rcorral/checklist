Backbone = require 'backbone'

module.exports = class ChecklistView extends Backbone.View

    className: 'app-checklist checklist'

    componentClassName: 'checklist'

    events:
        'click .js-save-checklist': 'handleChecklistSave'
        'keydown .js-new-item-title': 'handleKeydownAdd'
        'click .js-add-item': 'handleItemAdd'

    initialize: (options) ->
        @router = options.router
        @constructor.template = require '../templates/checklist.jade'
        @listenTo @model, 'sync change:list', @render

    handleChecklistSave: ->
        title = @$el.find('.js-checklist-title').val()
        isNew = @model.isNew()
        unless title
            return alert 'Please add a title for this checklist.'

        @model.setTitle title
        @model.save null,
            success: =>
                # Update url
                @router.navigate @model.frontEndUrl() if isNew

    handleKeydownAdd: (event) ->
        @handleItemAdd() if event.which is 13 # enter

    handleItemAdd: ->
        title = @$el.find('.js-new-item-title').val()
        done = @$el.find('.js-new-item-done').is(':checked')

        unless title
            return alert 'Please add a title to add a checklist item.'

        # Set title so that it's not lost on render
        if @model.isNew()
            checklistTitle = @$el.find('.js-checklist-title').val()
            @model.setTitle checklistTitle

        @model.addItem {title, done}

        setTimeout =>
            @$el.find('.js-new-item-title').focus()
        , 100

    render: ->
        @$el.html @constructor.template @model.toJSON()
