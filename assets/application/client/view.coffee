ChecklistsView = require '../../checklist/client/checklists.coffee'
HomeView = require '../../home/client.coffee'
NavbarView = require '../../../components/navbar/client.coffee'

componentViews = {}

class ApplicationView extends Backbone.View

    initialize: ->
        router = @model.get 'router'
        @$componentsContainer = $ '.components-container'
        @$body = $ 'body'
        @$footer = $ 'footer'
        @appRendered = false

        @registerComponent 'checklists',
            klass: ChecklistsView
            options: {router}

        @registerComponent 'home',
            klass: HomeView
            options: {router}

        @navbarView = new NavbarView
            el: $ 'header'
            router: router
            model: @model

        # Listeners
        @listenTo @model, 'change:activeComponent', @renderActiveComponent
        @listenTo @model, 'change:title', @handleTitleChange

    ###
    # Event Handlers
    ###

    handleTitleChange: (model, title) ->
        $('title').html title

    ###
    # Rendering
    ###

    render: ->
        @navbarView.render()

    ###
    # Helpers
    ###

    registerComponent: (id, component) ->
        componentViews[id] = component

    getComponentView: (id) ->
        return unless id of componentViews

        component = componentViews[id]

        unless component.instance
            # Clears out server rendered app
            unless @appRendered
                @$el.empty()
                @appRendered = true

            _.defaults component,
                options: {}
            {instance, type} = @model.getComponent id
            component.options[type] = instance
            view = new component.klass component.options
            @$el.append view.el
            component.instance = view

        component.instance

    renderActiveComponent: (model, component) ->
        previousComponentID = @model.previous 'activeComponent'
        if previousComponentID?
            previousView = @getComponentView previousComponentID
            previousView.$el.hide()
            className = "#{previousView.componentClassName ? previousComponentID}-component"
            @$body.removeClass className

        view = @getComponentView component
        @$body.addClass "#{view.componentClassName ? component}-component"
        view.$el.show()
        view.render()

module.exports = ApplicationView
