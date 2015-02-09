ChecklistView = require './client/checklist'
Checklists = require '../../collections/checklists'
Checklist = require '../../models/checklist'
jade = require 'jade'
path = require 'path'
sd = require('sharify').data
storage = require('../../lib/fs-store')(path.join __dirname, 'data')
template = require '../../lib/template-skeleton'
uuid = require 'uuid'

templatePath = path.join __dirname, 'templates'
checklistsView = jade.compileFile "#{templatePath}/checklists.jade"
checklistView = jade.compileFile "#{templatePath}/checklist.jade"

module.exports.init = (app) ->
    template.register app

# Loads checklists
module.exports.checklists = (req, res) ->
    checklists = new Checklists null
    checklists.fetch
        success: ->
            res.locals.sd.checklists = checklists.toJSON()
            template.render req, res,
                appName: 'checklists'
                appView: checklistsView checklists.forTemplate()
                navbarOpts:
                    checklistsActive: true
        error: ->
            # maybe this should send user to 404?
            res.redirect '/checklists'
 
# Loads checklist
module.exports.checklist = (req, res) ->
    checklist = new Checklist id: req.params.id
    checklist.fetch
        success: ->
            res.locals.sd.checklist = checklist.toJSON()
            template.render req, res,
                appName: 'checklist'
                appView: checklistView res.locals.sd.checklist
                componentClassName: ChecklistView::componentClassName
                navbarOpts:
                    checklistActive: true
        error: ->
            res.redirect '/checklists'

# Saves checklist
module.exports.checklistStore = (req, res) ->
    id = req.body.id
    id = uuid.v4() unless id
    data =
        id: id
        title: req.body.title
        list: req.body.list
        # Could be worth storing this in UTC
        createdAt: req.body.createdAt or (new Date).getTime()

    storage.store id, JSON.stringify(data), ->
        res.send data
