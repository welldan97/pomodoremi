class Tags
  commands:
    tag: (tag) ->
      return unless tag?
      @tags.push tag

  start: (interval, cb) ->
    interval.tags = []

module.exports = Tags
