ApplicationModel = require './model.coffee'
ApplicationView = require './view.coffee'
ApplicationRouter = require './router.coffee'

module.exports.init = ->
    model = new ApplicationModel
        router: new ApplicationRouter()

    view = new ApplicationView
        model: model
        el: $ '.app-wrapper'

    model.start()
    view.render()
