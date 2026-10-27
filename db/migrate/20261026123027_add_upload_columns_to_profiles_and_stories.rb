class AddUploadColumnsToProfilesAndStories < ActiveRecord::Migration[8.1]
  def change
    add_column :profiles, :avatar, :string
    add_column :stories, :images, :json
  end
end
