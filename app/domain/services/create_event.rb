class CreateEvent
  include Wisper::Publisher

  def execute(performer, attributes)
    event = performer.company.events.new(attributes)
    if event.save
      broadcast(:create_event_successful, performer, event)
    else
      broadcast(:create_event_failed, performer, event)
    end
  end

private

end
