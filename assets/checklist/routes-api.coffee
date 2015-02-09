_ = require 'underscore'
Checklists = require '../../collections/checklists'
jade = require 'jade'
path = require 'path'
storage = require('../../lib/fs-store')(path.join __dirname, 'data')

module.exports.checklists = (req, res) ->
    storage.allItems (items) ->
        res.send items

module.exports.checklist = (req, res) ->
    if req.params.id isnt req.params.id.replace /[^a-z0-9\-]/, ''
        return res.status(400).end()

    data = storage.load req.params.id
    if data
        res.send data
    else
        res.status(404).end()
