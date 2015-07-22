FileBrowserView = require './file-browser-view'
{CompositeDisposable} = require 'atom'
fs = require 'fs'
path = require 'path'

getDirectoryFiles = (directory)->
  files = fs.readdirSync(directory)
  folderList = [
    showedFilename: '..'
    realFilename: path.dirname(directory)
    isDir: true
  ]
  fileList = []
  for fileName in files
    filePath = path.join(directory, fileName)
    item =
      showedFilename: fileName
      realFilename: filePath
      isDir: fs.lstatSync(filePath).isDirectory()
    if item.isDir then folderList.push item else fileList.push item

  folderList.concat fileList

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
    @subscriptions.add atom.commands.add 'atom-workspace', 'file-browser:search': => @search()

  deactivate: ->
    @subscriptions.dispose()
    @fileBrowserView.destroy()

  serialize: ->
    currentDirectory: @currentDirectory

  open: ->
    self = @
    editor = atom.workspace.getActiveTextEditor()
    filePath = atom.project.rootDirectories[0].path + '/.'
    if editor
      filePath = editor.getPath()

    @currentDirectory = path.dirname(filePath)
    files = getDirectoryFiles(@currentDirectory)

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
        self.currentDirectory = file.realFilename
        if file.isDir
          files = getDirectoryFiles(file.realFilename)
          self.fileBrowserView.setFiles(files)
        else
          atom.workspace.open(file.realFilename)
      if event.which == 8
        event.stopPropagation()
        previousDirectory = self.currentDirectory
        self.currentDirectory = path.dirname(self.currentDirectory)
        files = getDirectoryFiles(self.currentDirectory)
        row = files.map (i) ->
          i.realFilename
        .indexOf previousDirectory
        self.fileBrowserView.setFiles(files)

        cursor = filebrowserEditor.model.cursors[0]
        cursor.moveToTop()
        cursor.moveDown(row)
    return

  search: ->
    return if atom.workspace.getActiveTextEditor()
    target = atom.views.getView(atom.workspace.getActivePane().activeItem)
    target.dataset.path = @currentDirectory
    atom.commands.dispatch target, 'project-find:show-in-current-directory'
