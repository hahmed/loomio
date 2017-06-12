class CalendarInvite
  include PrettyUrlHelper
  extend Forwardable

  def_delegators :@calendar, :to_ical

  def initialize(outcome = nil)
    @calendar = if outcome&.poll_option && outcome&.dates_as_options
      build_calendar(outcome)
    else
      Struct.new(:to_ical).new
    end
  end

  private

  def build_calendar(outcome)
    return unless outcome&.poll_option && outcome&.dates_as_options
    Icalendar::Calendar.new.tap do |calendar|
      calendar.event do |event|
        if outcome.poll_option.name.match /^\d{4}-\d{2}-\d{2}$/
          event.dtstart  = outcome.poll_option.name.to_date.beginning_of_day
          event.duration = "+P0W1D0H0M" # an all day event
        else
          event.dtstart  = Time.zone.parse(outcome.poll_option.name)
          event.duration = "+P0W0D0H#{outcome.event_duration || 60}M"
        end
        event.summary  = outcome.statement
        event.location = outcome.event_location
        event.url      = poll_url(outcome.poll)
      end
    end
  end
end