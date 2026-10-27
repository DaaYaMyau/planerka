class AddVotesCountToStories < ActiveRecord::Migration[8.1]
  def change
    add_column :stories, :votes_count, :integer, default: 0, null: false

    reversible do |direction|
      direction.up do
        Story.reset_column_information
        Story.find_each { |story| Story.reset_counters(story.id, :votes) }
      end
    end
  end
end
