Backbone = require 'backbone'
Checklist = require '../models/checklist.coffee'
sd = require('sharify').data

module.exports = class Checklists extends Backbone.Collection

    url: -> "#{sd.API_URL}/api/checklists"

    model: Checklist

    forTemplate: ->
        checklists: @toJSON()
        sd: sd
