ONE_MIN_IN_MS = 60 * 1000
module.exports =
 toMs: (mins) -> mins * ONE_MIN_IN_MS
 toMin: (ms) -> ms / ONE_MIN_IN_MS
