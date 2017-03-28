module Communities::NotifyViaEmail
  EMAIL_EVENTS = %w(outcome_created poll_created visitor_created visitor_reminded).freeze

  def notify!(event)
    visitors.where(revoked: false).where('email IS NOT NULL').each do |recipient|
      event.mailer.send(event.kind, recipient, event).deliver_now
    end if EMAIL_EVENTS.include?(event.kind)
  end
end
