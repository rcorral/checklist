Checklist = require '../../models/checklist'
sinon = require 'sinon'
sd = require('sharify').data

describe 'Checklist', ->

    sd.API_URL = 'http://example.com'

    it 'uses API_URL as url', ->
        checklist = new Checklist
        checklist.urlRoot().should.equal "#{sd.API_URL}/api/checklists"

    it 'builds #frontEndUrl from ID', ->
        checklist = new Checklist id: 'hello-world'
        checklist.frontEndUrl().should.equal "/checklists/#{checklist.id}"

    describe '#reset', ->

        it 'resets attributes', ->
            checklist = new Checklist
                id: 'hello-world'
                createdAt: (new Date).getTime()
                title: 'Hello world!'
                list: [{title: 'a', done: false}]
            checklist.reset()
            checklist.attributes.should.eql Checklist::defaults

    describe '#toJSON', ->

        before ->
            @attributes =
                id: 'hello-world'
                createdAt: (new Date).getTime()
                title: 'Hello world!'
                list: [{title: 'a', done: false}]
            checklist = new Checklist @attributes
            @json = checklist.toJSON()

        it 'is an object', ->
            @json.should.be.an.instanceOf Object

        it 'contains frontEndUrl', ->
            @json.url.should.be.equal "/checklists/#{@attributes.id}"

    describe '#loadChecklist', ->

        beforeEach ->
            @checklist = new Checklist id: 'hello-world', title: 'something else'
            @checklist.fetch = ->

        it 'clears all attributes', ->
            @checklist.loadChecklist null
            @checklist.has('id').should.not.be.ok
            @checklist.has('title').should.not.be.ok

        it 'sets id as new id', ->
            @checklist.loadChecklist 'my-new-id'
            @checklist.get('id').should.equal 'my-new-id'
            @checklist.id.should.equal 'my-new-id'

        it 'fetches checklist from server', ->
            @checklist.fetch = sinon.spy()
            @checklist.loadChecklist null
            @checklist.fetch.calledOnce.should.be.ok
