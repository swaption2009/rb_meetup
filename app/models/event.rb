class Event < ApplicationRecord
  belongs_to :organizers, class_name: 'User', optional: true
end
