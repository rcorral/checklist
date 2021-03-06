jade = require 'jade'
path = require 'path'
template = require '../../lib/template-skeleton'

appView = jade.renderFile path.join __dirname, 'templates/index.jade'

module.exports.init = (app) ->
    template.register app

module.exports.index = (req, res) ->
    template.render req, res,
        appName: 'home'
        appView: appView
        navbarOpts:
            homeActive: true
