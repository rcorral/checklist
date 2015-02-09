fs = require 'fs'
path = require 'path'

class Store

    constructor: (basePath) ->
        @basePath = basePath

        # Create directory if it doesn't exist
        unless fs.existsSync @basePath
            fs.mkdirSync @basePath

    store: (id, data, callback) ->
        fileName = path.join @basePath, "#{id}.json"
        fs.writeFile fileName, data, callback

module.exports = (path) ->
    new Store path
