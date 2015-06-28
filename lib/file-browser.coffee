FileBrowserView = require './file-browser-view'
{CompositeDisposable} = require 'atom'
fs = require 'fs'
path = require 'path'

getDirectoryFiles = (directory)->
  files = fs.readdirSync(directory)
  filesInfo = [
    showedFilename: '..'
    realFilename: path.dirname(directory)
    isDir: true
  ]
  for fileName in files
    filePath = path.join(directory, fileName)
    filesInfo.push
      showedFilename: fileName
      realFilename: filePath
      isDir: fs.lstatSync(filePath).isDirectory()

  filesInfo

module.exports = FileBrowser =
  currentDirectory: null
  fileBrowserView: null
  subscriptions: null
  panel: null

  activate: (state) ->
    @currentDirectory = state.currentDirectory
    @fileBrowserView = new FileBrowserView()

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'file-browser:open': => @open()

  deactivate: ->
    @subscriptions.dispose()
    @fileBrowserView.destroy()

  serialize: ->
    currentDirectory: @currentDirectory

  open: ->
    self = @
    editor = atom.workspace.getActiveTextEditor()
    filePath = editor.getPath()
    files = getDirectoryFiles(path.dirname(filePath))

    @fileBrowserView = new FileBrowserView()
    @fileBrowserView.setFiles(files)

    pane = atom.workspace.getActivePane()
    filebrowserEditor = pane.addItem(@fileBrowserView)
    pane.activateItem(filebrowserEditor)


    filebrowserEditor.keydown (event)->
      if event.which == 13
        event.stopPropagation()
        cursor = filebrowserEditor.model.cursors[0]

        file = files[cursor.getBufferRow()]
        if file.isDir
          files = getDirectoryFiles(file.realFilename)
          self.fileBrowserView.setFiles(files)
        else
          atom.workspace.open(file.realFilename)
    return
