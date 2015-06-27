FileBrowserView = require './file-browser-view'
{CompositeDisposable} = require 'atom'

module.exports = FileBrowser =
  fileBrowserView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @fileBrowserView = new FileBrowserView(state.fileBrowserViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @fileBrowserView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'file-browser:open': => @open()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @fileBrowserView.destroy()

  serialize: ->
    fileBrowserViewState: @fileBrowserView.serialize()

  open: ->
    editor = atom.workspace.getActiveTextEditor()
    alert editor.getPath()
