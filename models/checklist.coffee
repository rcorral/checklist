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

    frontEndUrl: -> "/checklist/#{@id}"

    toJSON: ->
        json = super
        json.url = @frontEndUrl()
        json

    addItem: (newItem) ->
        list = _.clone @get 'list'
        list.push newItem
        @set {list}

    setTitle: (title) ->
        @set {title}

    loadChecklist: (id, options={}) ->
        @clear silent: true
        @set id: id
        @fetch options
