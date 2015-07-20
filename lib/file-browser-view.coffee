{TextEditorView} = require 'atom-space-pen-views'

module.exports =
class FileBrowserView extends TextEditorView
  getTitle: ->
    "FileBrowser"

  setFiles: (files)->
    @.addClass('file-browser')
    @setText(files.map (file)->
      if file.isDir
        "▸#{file.showedFilename}"
      else
        file.showedFilename
    .join('\n'))
