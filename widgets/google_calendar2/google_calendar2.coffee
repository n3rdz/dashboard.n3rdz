class Dashing.GoogleCalendar2 extends Dashing.Widget

  onData: (data) =>
    event = rest = null
    getEvents = (first, others...) ->
      event = first
      rest = others

    getEvents data.events...

    start = moment(event.start)
    end = moment(event.end)
    location = (event.location)
    description = (event.description)

    @set('event',event)
    
    @set('event_date', start.locale('de').format('LL'))
    @set('event_times', start.locale('de').format('LLLL') + " - " + end.locale('de').format('LT'))
    
    @set('event_location', location)
    @set('event_description', description)

    next_events = []
    for next_event in rest
      
      start = moment(next_event.start)
      end = moment(next_event.end)
      
      start_date = start.locale('de').format('L')
      start_time = start.locale('de').format('LT')
      end_time = end.locale('de').format('LT')

      
      location = location
      description = description

      next_events.push { summary: next_event.summary, start_date: start_date, start_time: start_time, end_time: end_time, location : next_event.location, description:next_event.description }
    @set('next_events', next_events)
