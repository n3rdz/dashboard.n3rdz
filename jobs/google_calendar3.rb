require 'icalendar'

ical_url = 'https://calendar.google.com/calendar/ical/r149rbm2tmjubreoior388ka84%40group.calendar.google.com/private-5a4d1a4405c262a69397d4539dc98209/basic.ics'
uri = URI ical_url

SCHEDULER.every '15s', :first_in => 0 do |job|
  parsed_url = URI.parse(ical_url)
http = Net::HTTP.new(parsed_url.host, parsed_url.port)
http.use_ssl = (parsed_url.scheme == "https")
req = Net::HTTP::Get.new(parsed_url.request_uri)
result = http.request(req).body.force_encoding('UTF-8')
  calendars = Icalendar.parse(result)
  calendar = calendars.first

  events = calendar.events.map do |event|
    {
      start: event.dtstart,
      end: event.dtend,
      summary: event.summary,
      location: event.location,
      description: event.description
    }
  end.select { |event| event[:start] > DateTime.now }

  events = events.sort { |a, b| a[:start] <=> b[:start] }

  events = events[0..8]

  send_event('google_calendar3', { events: events })
end
