class Tag < ApplicationRecord
    enum :kind, { profession: 0, topic: 1 }
    has_many :story_tags, dependent: :destroy
    has_many :stories, through: :story_tags
end
