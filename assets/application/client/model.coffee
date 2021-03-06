Checklists = require '../../../collections/checklists.coffee'
Checklist = require '../../../models/checklist.coffee'
sd = require('sharify').data
Util = require '../../../components/Util/index.coffee'

components = {}

class ApplicationModel extends Backbone.Model

    initialize: ->
        router = @get 'router'
        @listenTo router, 'navigate:home', @handleComponent
        @listenTo router, 'navigate:checklists', @handleChecklists
        @listenTo router, 'navigate:checklist', @handleChecklist
        @listenTo @, 'change:activeComponent', @handleActiveComponentChange

        @registerComponent 'checklists',
            collectionKlass: Checklists
            models: sd.checklists

        @registerComponent 'checklist',
            modelKlass: Checklist
            attributes: sd.checklist
            options:
                parse: true

        @registerComponent 'home',
            modelKlass: Backbone.Model

    start: ->
        Backbone.history.start pushState: true

    registerComponent: (id, component) ->
        components[id] = component

    getComponent: (id) ->
        return unless id of components

        component = _.defaults components[id],
            models: null
            attributes: {}
            options: {}

        unless component.instance
            if component.collectionKlass
                klass = component.collectionKlass
                arg1 = component.models
            else
                klass = component.modelKlass
                arg1 = component.attributes

            component.instance = new klass arg1, component.options

        instance: component.instance
        type: if component.collectionKlass then 'collection' else 'model'

    # Renders a component that doesn't need any special treatment
    handleComponent: (component) ->
        {instance} = @getComponent component
        @set
            activeComponent: component
            title: Util.capitalize component

    handleChecklists: (id) ->
        @handleComponent id
        {instance} = @getComponent id
        instance.fetch()

    handleChecklist: (id) ->
        {instance} = @getComponent 'checklist'
        fn = =>
            @set
                activeComponent: 'checklist'
                title: instance.get 'title'
        if id
            instance.loadChecklist id, success: fn
        else
            instance.reset()
            fn()

    handleActiveComponentChange: ->
        previousComponentID = @previous 'activeComponent'
        if previousComponentID?
            previousComponent = @getComponent previousComponentID
            if previousComponent.type is 'model'
                previousComponent.instance.set 'isActive', false

        currentComponentID = @get 'activeComponent'
        activeComponent = @getComponent currentComponentID
        if activeComponent.type is 'model'
            activeComponent.instance.set 'isActive', true

module.exports = ApplicationModel
