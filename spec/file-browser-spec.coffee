FileBrowser = require '../lib/file-browser'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "FileBrowser", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('file-browser')

  describe "when the file-browser:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.file-browser')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'file-browser:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.file-browser')).toExist()

        fileBrowserElement = workspaceElement.querySelector('.file-browser')
        expect(fileBrowserElement).toExist()

        fileBrowserPanel = atom.workspace.panelForItem(fileBrowserElement)
        expect(fileBrowserPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'file-browser:toggle'
        expect(fileBrowserPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.file-browser')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'file-browser:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        fileBrowserElement = workspaceElement.querySelector('.file-browser')
        expect(fileBrowserElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'file-browser:toggle'
        expect(fileBrowserElement).not.toBeVisible()
