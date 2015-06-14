_ = require 'lodash'
class Tags
  commands:
    tag: (tag, cb) ->
      return unless tag?
      @interval.tags.push tag
      cb()

    tags: (cb) ->
      if _.isEmpty @interval.tags
        cb 'no tags'
      else
        cb("\##{@interval.tags.join(' #')}")

  start: (interval, cb) ->
    interval.tags = []
    cb()

module.exports = Tags
