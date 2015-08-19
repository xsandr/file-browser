{TextEditorView} = require 'atom-space-pen-views'

module.exports =
class FileBrowserView extends TextEditorView
  getTitle: ->
    "FileBrowser"

  setFiles: (files)->
    @.addClass('file-browser')
    @setText(files.map (file)->
      prefix = "≡ "
      if file.isDir
        prefix = "▸ "
      prefix + file.showedFilename
    .join('\n'))
