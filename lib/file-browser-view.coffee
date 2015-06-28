{TextEditorView} = require 'atom-space-pen-views'

module.exports =
class FileBrowserView extends TextEditorView
  getTitle: ->
    "FileBrowser"

  setFiles: (files)->
    @setText(files.map (file)->
      if file.isDir
        "▸#{file.showedFilename}"
      else
        file.showedFilename
    .join('\n'))
