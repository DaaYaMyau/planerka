class Article < ApplicationRecord
    has_many :stories, dependent: :nullify
end
