json.extract! story, :id, :user_id, :article_id, :title, :body, :grade, :status, :anonymous, :created_at, :updated_at
json.url story_url(story, format: :json)
