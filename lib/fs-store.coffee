fs = require 'fs'
path = require 'path'

class Store

    constructor: (basePath) ->
        @basePath = basePath

        # Create directory if it doesn't exist
        unless fs.existsSync @basePath
            fs.mkdirSync @basePath

    buildFileName: (id) ->
        path.join @basePath, "#{id}.json"

    store: (id, data, callback) ->
        fileName = @buildFileName id
        fs.writeFile fileName, data, callback

    load: (id, callback) ->
        fileName = @buildFileName id
        fs.readFile fileName, {encoding: 'utf8'}, callback

module.exports = (path) ->
    new Store path
