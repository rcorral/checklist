Checklists = require '../../collections/checklists'
jade = require 'jade'
path = require 'path'
sd = require('sharify').data
template = require '../../lib/template-skeleton'

templatePath = path.join __dirname, 'templates'
checklistsView = jade.compileFile "#{templatePath}/checklists.jade"

module.exports.init = (app) ->
    template.register app

module.exports.checklists = (req, res) ->
    checklists = new Checklists null
    checklists.fetch
        success: ->
            res.locals.sd.checklists = checklists.toJSON()
            console.log checklists.toJSON()
            template.render req, res,
                appName: 'checklists'
                appView: checklistsView checklists.forTemplate()
                navbarOpts:
                    checklistsActive: true
        error: ->
            # maybe this should send user to 404?
            res.redirect '/checklists'
