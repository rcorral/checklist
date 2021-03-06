_ = require 'underscore'
jade = require 'jade'
path = require 'path'
sd = require('sharify').data

# Pre-compile navbar view
navbarPath = path.join __dirname, '../../components/navbar/navbar.jade'
navbarView = jade.compileFile navbarPath

module.exports =

    ###
    Every app is it's own express app
    This just sets configuration options
    ###
    register: (app) ->
        app.set 'views', __dirname + '/templates'
        app.set 'view engine', 'jade'


    ###
    Renders app on the server
    ###
    render: (req, res, opts) ->
        res.render 'index', _.defaults {}, opts,
            appName: ''
            description: 'Checklist single page application'
            title: 'Checklists'
            navbarView: navbarView _.defaults {}, opts.navbarOpts, {sd}
