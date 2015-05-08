SublimeWordNavigation = require '../lib/sublime-word-navigation'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe 'SublimeWordNavigation', ->
  editor = null
  editorElement = null

  beforeEach ->
    waitsForPromise ->
      atom.workspace.open()
    waitsForPromise ->
      atom.packages.activatePackage('sublime-word-navigation')
    runs ->
      editor = atom.workspace.getActiveTextEditor()
      editorElement = atom.views.getView(editor)

  # move-to-beginning-of-word
  describe 'sublime-word-navigation:move-to-beginning-of-word', ->
    describe 'when the event is triggered', ->
      it 'moves to the beginning of the next word, skipping any non-word characters', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToEndOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-beginning-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-beginning-of-word'

        expect(editor.getCursorBufferPosition().toString()).toEqual('(0, 8)')

    describe 'when the event is triggered, cursor is not at beginning of line, and beginning of word is on previous line', ->
      it 'moves to the beginning of the current line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveDown()
        editor.moveToBeginningOfLine()
        editor.moveRight()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-beginning-of-word'

        expect(editor.getCursorBufferPosition().toString()).toEqual('(1, 0)')

    describe 'when the event is triggered, cursor is at beginning of line, and beginning of word is on previous line', ->
      it 'moves to the end of the previous line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveDown()
        editor.moveToBeginningOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-beginning-of-word'

        expect(editor.getCursorBufferPosition().toString()).toEqual('(0, 7)')

  # move-to-end-of-word
  describe 'sublime-word-navigation:move-to-end-of-word', ->
    describe 'when the event is triggered', ->
      it 'moves to the end of the next word, skipping any non-word characters', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToBeginningOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-end-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-end-of-word'

        expect(editor.getCursorBufferPosition().toString()).toEqual('(0, 7)')

    describe 'when the event is triggered, cursor is not at end of line, and end of word is on next line', ->
      it 'moves to the end of the current line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveUp()
        editor.moveToEndOfLine()
        editor.moveLeft()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-end-of-word'

        expect(editor.getCursorBufferPosition().toString()).toEqual('(0, 7)')

    describe 'when the event is triggered, cursor is at end of line, and end of word is on next line', ->
      it 'moves to the beginning of the next line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveUp()
        editor.moveToEndOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:move-to-end-of-word'

        expect(editor.getCursorBufferPosition().toString()).toEqual('(1, 0)')

  # select-to-beginning-of-word
  describe 'sublime-word-navigation:select-to-beginning-of-word', ->
    describe 'when the event is triggered', ->
      it 'selects to the beginning of the next word, skipping any non-word characters', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToEndOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-beginning-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-beginning-of-word'

        expect(editor.getSelectedText()).toEqual('baz-qux')

    describe 'when the event is triggered, cursor is not at beginning of line, and beginning of word is on previous line', ->
      it 'selects to the beginning of the current line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveDown()
        editor.moveToBeginningOfLine()
        editor.moveRight()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-beginning-of-word'

        expect(editor.getSelectedText()).toEqual('b')

    describe 'when the event is triggered, cursor is at beginning of line, and beginning of word is on previous line', ->
      it 'selects to the end of the previous line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveDown()
        editor.moveToBeginningOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-beginning-of-word'

        expect(editor.getSelectedText()).toEqual('\n')

  # select-to-end-of-word
  describe 'sublime-word-navigation:select-to-end-of-word', ->
    describe 'when the event is triggered', ->
      it 'selects to the end of the next word, skipping any non-word characters', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToBeginningOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-end-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-end-of-word'

        expect(editor.getSelectedText()).toEqual('foo-bar')

    describe 'when the event is triggered, cursor is not at end of line, and end of word is on next line', ->
      it 'selects to the end of the current line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveUp()
        editor.moveToEndOfLine()
        editor.moveLeft()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-end-of-word'

        expect(editor.getSelectedText()).toEqual('r')

    describe 'when the event is triggered, cursor is at end of line, and end of word is on next line', ->
      it 'selects to the beginning of the next line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveUp()
        editor.moveToEndOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:select-to-end-of-word'

        expect(editor.getSelectedText()).toEqual('\n')

  # delete-to-beginning-of-word
  describe 'sublime-word-navigation:delete-to-beginning-of-word', ->
    describe 'when the event is triggered', ->
      it 'deletes to the beginning of the next word, skipping any non-word characters', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToEndOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'

        expect(editor.getText()).toEqual('foo-bar-')

    describe 'when the event is triggered and text is selected', ->
      it 'deletes the selected text', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToEndOfLine()
        editor.selectLeft(4)

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'

        expect(editor.getText()).toEqual('foo-bar-baz')

    describe 'when the event is triggered, cursor is not at beginning of line, and beginning of word is on previous line', ->
      it 'deletes to the beginning of the current line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveDown()
        editor.moveToBeginningOfLine()
        editor.moveRight()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'

        expect(editor.getText()).toEqual('foo-bar\naz-qux')

    describe 'when the event is triggered, cursor is at beginning of line, and beginning of word is on previous line', ->
      it 'deletes to the end of the previous line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveDown()
        editor.moveToBeginningOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-beginning-of-word'

        expect(editor.getText()).toEqual('foo-barbaz-qux')

  describe 'sublime-word-navigation:delete-to-end-of-word', ->
    describe 'when the event is triggered', ->
      it 'deletes to the end of the next word, skipping any non-word characters', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToBeginningOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'
        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'

        expect(editor.getText()).toEqual('-baz-qux')

    describe 'when the event is triggered and text is selected', ->
      it 'deletes the selected text', ->
        editor.setText('foo-bar-baz-qux')
        editor.moveToBeginningOfLine()
        editor.selectRight(4)

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'

        expect(editor.getText()).toEqual('bar-baz-qux')

    describe 'when the event is triggered, cursor is not at end of line, and end of word is on next line', ->
      it 'deletes to the end of the current line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveUp()
        editor.moveToEndOfLine()
        editor.moveLeft()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'

        expect(editor.getText()).toEqual('foo-ba\nbaz-qux')

    describe 'when the event is triggered, cursor is at end of line, and end of word is on next line', ->
      it 'deletes to the beginning of the next line', ->
        editor.setText('foo-bar\nbaz-qux')
        editor.moveUp()
        editor.moveToEndOfLine()

        atom.commands.dispatch editorElement, 'sublime-word-navigation:delete-to-end-of-word'

        expect(editor.getText()).toEqual('foo-barbaz-qux')
