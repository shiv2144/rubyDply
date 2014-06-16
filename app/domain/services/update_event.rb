class UpdateEvent
  include Wisper::Publisher

  def execute(performer, event, attributes)
    if event.update(attributes)
      broadcast(:update_event_successful, performer, event)
    else
      broadcast(:update_event_failed, performer, event)
    end
  end

end
