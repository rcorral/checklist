_ = require 'underscore'
jade = require 'jade'
Checklists = require '../../collections/checklists'

module.exports.checklists = (req, res) ->
    res.send {}

module.exports.checklist = (req, res) ->
    return res.status(400).end() if req.params.id isnt req.params.id.replace /[^a-z0-9\-]/, ''

    res.send {id: '0-0-0-0', title: 'first list', list: []}
