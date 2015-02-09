_ = require 'underscore'
Checklists = require '../../collections/checklists'
jade = require 'jade'
path = require 'path'
storage = require('../../lib/fs-store')(path.join __dirname, 'data')

module.exports.checklists = (req, res) ->
    res.send {}

module.exports.checklist = (req, res) ->
    if req.params.id isnt req.params.id.replace /[^a-z0-9\-]/, ''
        return res.status(400).end()

    storage.load req.params.id, (error, data) ->
        if not error and data
            res.send JSON.parse data
        else
            res.status(404).end()
