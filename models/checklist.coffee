_ = require 'underscore'
Backbone = require 'backbone'
sd = require('sharify').data

module.exports = class Checklist extends Backbone.Model

    defaults:
        id: null
        title: ''
        list: []
        createdAt: null

    urlRoot: -> "#{sd.API_URL}/api/checklists"

    frontEndUrl: -> "/checklists/#{@id}"

    toJSON: ->
        json = super
        json.url = @frontEndUrl()
        json

    # Resets model to its defaults
    reset: ->
        @set Checklist::defaults

    # Adds an item to the current list
    addItem: (newItem) ->
        list = _.clone @get 'list'
        list.push newItem
        @set {list}

        # Keep in sync with server
        @save silent: true unless @isNew()

    ###
    Toggles done flag on list items
    @param  {Number} index The index of the item in the list
    @param  {Boolean} done Wether the item is done/not
    ###
    setDone: (index, done) ->
        return if @isNew()

        list = _.clone @get 'list'
        list[index].done = done
        @set {list}

        # Keep in sync with server
        @save silent: true

    setTitle: (title) ->
        @set {title}

    loadChecklist: (id, options={}) ->
        @clear silent: true
        @set id: id
        @fetch options
