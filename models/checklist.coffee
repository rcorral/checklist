Backbone = require 'backbone'
sd = require('sharify').data

module.exports = class Checklist extends Backbone.Model

    defaults:
        id: null
        title: null
        list: []

    urlRoot: -> "#{sd.API_URL}/api/checklists"

    frontEndUrl: -> "/checklist/#{@id}"

    toJSON: ->
        json = super
        json.url = @frontEndUrl()
        json

    loadChecklist: (id, options={}) ->
        @clear silent: true
        @set id: id
        @fetch options
