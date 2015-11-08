_ = require 'lodash'
class Tags
  help:
    tag: -> ['tag <tag>', 'add tag']
    tags: -> ['tags', 'list tags']
  commands:
    tag: (tag, cb) ->
      return unless tag?
      @timer.interval.tags.push tag
      cb()

    tags: (cb) ->
      if _.isEmpty @timer.interval.tags
        cb 'no tags'
      else
        cb("\##{@timer.interval.tags.join(' #')}")

  start: (interval, cb) ->
    interval.tags = []
    cb()

module.exports = Tags
