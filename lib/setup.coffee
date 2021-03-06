#
# Sets up intial project settings, middleware, mounted apps, and
# global configuration such as overriding Backbone.sync and
# populating sharify data
#

Backbone = require 'backbone'
bodyParser = require 'body-parser'
express = require 'express'
inDevelopment = process.env.NODE_ENV is 'development'
inProduction = process.env.NODE_ENV is 'production'
livereload = require 'connect-livereload' if inDevelopment
logger = require 'morgan'
path = require 'path'
sharify = require 'sharify'

module.exports = (app) ->

    # Inject some configuration & constant data into sharify
    sd = sharify.data =
        ENV: process.env.NODE_ENV
        HOST: process.env.NODE_HOST
        PORT: process.env.NODE_PORT
    sd.APP_URL = "http://#{sd.HOST}:#{sd.PORT}"
    sd.API_URL = sd.APP_URL

    # Override Backbone to use server-side sync
    Backbone.sync = require 'backbone-super-sync'

    # Settings
    app.enable 'case sensitive routing'

    # #use
    app.use bodyParser.json()
    app.use sharify
    app.use logger if inProduction then 'prod' else 'dev'
    app.use livereload port: process.env.NODE_LIVERELOAD_PORT if inDevelopment

    # Mount apps
    app.use require '../assets/home'
    app.use require '../assets/checklist'

    # Mount static middleware for sub apps, components, and project-wide
    app.use express.static path.resolve(__dirname, '../public')

    app.use require './error-handler'
