class Attendance < ApplicationRecord
  include Workflow

  belongs_to :user
  belongs_to :event

  def self.join_event(user_id, event_id, state)
    self.create(user_id: user_id, event_id: event_id, state: state)
  end

  scope :pending, -> {where(state: 'request_sent')}
  scope :accepted, -> {where(state: 'accepted')}
  scope :rejected, -> {where(state: 'rejected')}

  workflow_column :state

  workflow do
    state :request_sent do
      event :accept, :transition_to => :accepted
      event :reject, :transition_to => :rejected
    end
    state :accepted
    state :rejected
  end

end
