express = require 'express'
app = module.exports = express()

# Routes
routes = require './routes'
routes.init app
app.get '/checklists', routes.checklists
app.get '/checklists/:checklist', routes.checklist

# API Routes
routesAPI = require './routes-api'
app.get '/api/checklists/', routesAPI.checklists
app.get '/api/checklists/:id/', routesAPI.checklist
