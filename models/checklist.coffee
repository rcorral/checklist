Backbone = require 'backbone'
sd = require('sharify').data

module.exports = class Checklist extends Backbone.Model

    urlRoot: -> "#{sd.API_URL}/api/checklists"

    frontEndUrl: -> "/checklist/#{@id}"

    toJSON: ->
        json = super
        json.url = @frontEndUrl()
        json
