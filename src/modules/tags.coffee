Utils = require '../utils'
nodeNotifier = require 'node-notifier'

class Tags
  commands:
    tag: (tag) ->
      return unless tag?
      @tags.push tag

module.exports = Tags
