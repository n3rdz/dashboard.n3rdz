class Dashing.Tweets extends Dashing.Widget

  @accessor 'quote', ->
    "“#{@get('current_comment')?.body}”"

  ready: ->
    @currentIndex = 0
    @commentElem = $(@node).find('.comment-container')
    @nextComment()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0

  startCarousel: ->
    setInterval(@nextComment, 2500)

  nextComment: =>
    comments = @get('comments')
    if comments
      @commentElem.fadeOut =>
        @currentIndex = (@currentIndex + 1) % comments.length
        @set 'current_comment', comments[@currentIndex]
        @commentElem.fadeIn()
