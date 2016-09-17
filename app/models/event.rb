class Event < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :organizers, class_name: 'User', optional: true
  has_many :tags, through: :taggings

  def all_tags
    tags.map(&:name).join(", ")
  end

  def all_tags=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end
end
