{CompositeDisposable} = require 'atom'

module.exports = SublimeWordNavigation =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-text-editor',
      'sublime-word-navigation:move-to-beginning-of-word': => @moveToBeginningOfWord()
      'sublime-word-navigation:move-to-end-of-word': => @moveToEndOfWord()
      'sublime-word-navigation:select-to-beginning-of-word': => @selectToBeginningOfWord()
      'sublime-word-navigation:select-to-end-of-word': => @selectToEndOfWord()
      'sublime-word-navigation:delete-to-beginning-of-word': => @deleteToBeginningOfWord()
      'sublime-word-navigation:delete-to-end-of-word': => @deleteToEndOfWord()

  deactivate: ->
    @subscriptions.dispose()

  getEditor: ->
    atom.workspace.getActiveTextEditor()

  getCursor: ->
    @getEditor().getLastCursor()

  getSelection: ->
    @getEditor().getLastSelection()

  moveToBeginningOfWord: ->
    cursor = @getCursor()
    beginningOfWordPosition = cursor.getBeginningOfCurrentWordBufferPosition({
      includeNonWordCharacters: false
    })
    if cursor.isAtBeginningOfLine()
      cursor.moveUp()
      cursor.moveToEndOfLine()
    else if beginningOfWordPosition.row < cursor.getBufferPosition().row
      cursor.moveToBeginningOfLine()
    else
      cursor.setBufferPosition(beginningOfWordPosition)

  moveToEndOfWord: ->
    cursor = @getCursor()
    endOfWordPosition = cursor.getEndOfCurrentWordBufferPosition({
      includeNonWordCharacters: false
    })
    if cursor.isAtEndOfLine()
      cursor.moveDown()
      cursor.moveToBeginningOfLine()
    else if endOfWordPosition.row > cursor.getBufferPosition().row
      cursor.moveToEndOfLine()
    else
      cursor.setBufferPosition(endOfWordPosition)

  selectToBeginningOfWord: ->
    @getSelection().modifySelection => @moveToBeginningOfWord()

  selectToEndOfWord: ->
    @getSelection().modifySelection => @moveToEndOfWord()

  deleteToBeginningOfWord: ->
    @getEditor().mutateSelectedText (selection) =>
      if selection.isEmpty()
        selection.modifySelection => @moveToBeginningOfWord()
      selection.deleteSelectedText()

  deleteToEndOfWord: ->
    @getEditor().mutateSelectedText (selection) =>
      if selection.isEmpty()
        selection.modifySelection => @moveToEndOfWord()
      selection.deleteSelectedText()
