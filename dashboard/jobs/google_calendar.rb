require 'icalendar'

ical_url = 'https://calendar.google.com/calendar/ical/4ii3po665g3s2512bkafond3dg%40group.calendar.google.com/private-1a4b8310596be245f71b6a2d69fb7050/basic.ics'
uri = URI ical_url

SCHEDULER.every '15s', :first_in => 4 do |job|
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
      summary: event.summary
    }
  end.select { |event| event[:start] > DateTime.now }

  events = events.sort { |a, b| a[:start] <=> b[:start] }

  events = events[0..5]

  send_event('google_calendar', { events: events })
end