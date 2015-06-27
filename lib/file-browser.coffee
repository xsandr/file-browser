FileBrowserView = require './file-browser-view'
{CompositeDisposable} = require 'atom'
fs = require 'fs'
path = require 'path'

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

  getDirectoryFiles: (directory)->
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

  open: ->
    editor = atom.workspace.getActiveTextEditor()
    filePath = editor.getPath()
    @currentDirectory = path.dirname(filePath)
    files = @getDirectoryFiles(@currentDirectory)

    @fileBrowserView = new FileBrowserView()
    @fileBrowserView.setItems(files)

    pane = atom.workspace.getActivePane()
    item = pane.addItem(@fileBrowserView)
    pane.activateItem(item)
