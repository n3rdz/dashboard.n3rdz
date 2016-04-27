class Dashing.SAD_Clock extends Dashing.Widget

  ready: ->
    setInterval(@startTime, 500)

  startTime: =>
    now = moment()
    time = now.locale('de').format('HH:mm:ss')
    date = now.locale('de').format('dddd Do MMMM')
    
    @set('date', date)
    @set('time', time)