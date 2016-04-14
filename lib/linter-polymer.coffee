{CompositeDisposable} = require 'atom'
path = require 'path'
polylint = null

module.exports = LinterPolymer =
  config:
    lintOnFly:
      title: 'Lint As You Type'
      description: 'Lint files while typing, without the need to save'
      type: 'boolean'
      default: true
      order: 1
    bowerDir:
      title: 'Bower Directory'
      description: 'Name of the bower directory'
      type: 'string'
      default: 'bower_components'
      order: 2
    allMessages:
      title: 'Display All Messages'
      description: 'Display messages for all imported files'
      type: 'boolean'
      default: false
      order: 3

  subscriptions: null

  activate: (state) ->

    @scopes = ['text.html.basic']
    @provider = {}

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.config.observe 'linter-polymer.lintOnFly',
      (lintOnFly) =>
        @lintOnFly = lintOnFly
        @provider.lintOnFly = lintOnFly
    @subscriptions.add atom.config.observe 'linter-polymer.bowerDir',
      (bowerDir) =>
        @bowerDir = bowerDir
    @subscriptions.add atom.config.observe 'linter-polymer.allMessages',
      (allMessages) =>
        @allMessages = allMessages

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  provideLinter: ->

    @provider =
      name: 'polymer'
      grammarScopes: LinterPolymer.scopes
      scope: 'file'
      lintOnFly: LinterPolymer.lintOnFly

      lint: (textEditor) =>

        # load polylint on demand
        polylint ?= require 'polylint'

        fileText = textEditor.getText()
        fileAbsPath = textEditor.getPath()
        absPath = path.dirname(textEditor.getPath())
        fileName = path.basename(textEditor.getPath())

        polylint(fileName,
          root: absPath
          redirect: LinterPolymer.bowerDir
          content: fileText
          resolver: 'permissive'

        ).then (lintErrors) ->

          errors = []

          lintErrors.forEach (warning) ->

            if !LinterPolymer.allMessages and warning.filename != fileName
              # Skip warnings from external files if requested
              return

            pointStart = [warning.location.line - 1, warning.location.column - 1]
            pointEnd = [warning.location.line - 1, warning.location.column + 5]

            errors.push
              type: if warning.fatal then 'Error' else 'Warning'
              text: warning.message
              filePath: path.normalize(absPath + '/' + warning.filename)
              range: [pointStart, pointEnd]

          return errors

        .catch (err) ->

          # Something went very wrong
          message

          if err.ownerDocument == fileAbsPath
            message = err.message
            pointStart = [err.location.line - 1, err.location.column - 1]
            pointEnd = [err.location.line - 1, err.location.column - 1]
          else
            message = 'Unknown Error'
            pointStart = [0,0]
            pointEnd = [0,1]

          return [
            type: 'Error',
            text: message,
            filePath: fileAbsPath,
            range: [pointStart, pointEnd]
          ]
