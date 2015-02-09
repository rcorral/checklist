Util = {}

Util.capitalize = (str) ->
    str.replace /(^\s*)(\S)(.*)$/g, (match, whitespace, firstLetter, rest) ->
         whitespace + firstLetter.toUpperCase() + rest

Util.scrollToTop = (position=0) ->
    $('html, body').animate
        'scrollTop': position
    , 'fast', 'swing'

module.exports = Util
