require 'icalendar'
require 'active_support/all'

ical_url = 'https://calendar.google.com/calendar/ical/jungesangebotvonardundzdf%40gmail.com/private-67e9ccd9bfdb073f01b6f6717783a593/basic.ics'
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

  send_event('google_calendar', { events: events })
end
