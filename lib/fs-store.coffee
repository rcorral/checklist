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

    allItems: (callback) ->
        fs.readdir @basePath, (err, fileList) =>
            throw err if err

            filesData = []
            regex = /.*\.json$/
            for file in fileList
                if regex.test file
                    data = @load file.replace /\.json$/, ''
                    filesData.push data

            callback filesData

    store: (id, data, callback) ->
        fileName = @buildFileName id
        fs.writeFile fileName, JSON.stringify(data), callback

    load: (id) ->
        fileName = @buildFileName id
        data = fs.readFileSync fileName, {encoding: 'utf8'}
        JSON.parse data

module.exports = (path) ->
    new Store path
