{TextEditorView} = require 'atom-space-pen-views'

module.exports =
class FileBrowserView extends TextEditorView
  getTitle: ->
    "FileBrowser"

  setItems: (files)->
    @setText(files.map (file)->
      file.showedFilename
    .join('\n'))
