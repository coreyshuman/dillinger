
'use strict'

app = require('../dillinger')

module.exports = app.factory 'documentsService',
  ($rootScope, Sheet) ->

    currentDocument =
      title: ""
      body: ""
      id: null
    files = []

    service =
      currentDocument: {}
      files: []
      getItem: (item) ->
        service.files[service.files.indexOf(item)]
      getItemByIndex: (index) ->
        service.files[index]
      getItemById: (id) ->
        tmp = null
        angular.forEach service.files, (file) ->
          if file.id is id
            tmp = file
        tmp
      addItem: (item) ->
        service.files.push item
      removeItem: (item) ->
        service.files.splice(service.files.indexOf(item), 1)
      createItem: (props) ->
        new Sheet(props)
      size: ->
        service.files.length
      getItems: ->
        service.files
      removeItems: ->
        service.files = []
        service.currentDocument = {}
        false
      setCurrentDocument: (item) ->
        service.currentDocument = item
      getCurrentDocument: ->
        service.currentDocument
      setCurrentDocumentTitle: (title) ->
        service.currentDocument.title = title
      getCurrentDocumentTitle: ->
        service.currentDocument.title
      save: ->
        sessionStorage.setItem('files', angular.toJson(service.files))
        sessionStorage.setItem('currentDocument', angular.toJson(service.currentDocument))
      init: ->
        service.files           = angular.fromJson(sessionStorage.getItem('files')) or []
        service.currentDocument = angular.fromJson(sessionStorage.getItem('currentDocument')) or {}
        unless service.files?.length
          item = @createItem()
          @addItem(item)
          @setCurrentDocument(item)
          @save()

    service.init()

    return service

