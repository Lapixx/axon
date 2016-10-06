StatusMessage = require './StatusMessage'
{CompositeDisposable} = require 'atom'

module.exports = Axon =
  axonStatus: null
  axonStatusTimer: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      'axon:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    if @axonStatus
        @toggle()

  serialize: ->
    axonViewState: @axon.serialize()

  refreshStatus: ->
      editor = atom.workspace.getActiveTextEditor()
      # chrs = editor.getText().length
      wrds = editor.getText().split(/\s+/).length
      mins = Math.floor(wrds / 275) + 1
      displayText = "This is a  #{mins} minute read."
      @axonStatus.setText(displayText)

  toggle: ->

    if @axonStatus
      @axonStatus.destroy()
      @axonStatus = null
      clearInterval(@axonStatusTimer)
      @axonStatusTimer = null
    else
      @axonStatus = new StatusMessage("")
      @refreshStatus()
      @axonStatusTimer = setInterval((-> this.refreshStatus()).bind(this), 5000)
