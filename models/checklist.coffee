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

    reset: ->
        @set Checklist::defaults

    addItem: (newItem) ->
        list = _.clone @get 'list'
        list.push newItem
        @set {list}

        # Keep in sync with server
        @save silent: true unless @isNew()

    setTitle: (title) ->
        @set {title}

    loadChecklist: (id, options={}) ->
        @clear silent: true
        @set id: id
        @fetch options
