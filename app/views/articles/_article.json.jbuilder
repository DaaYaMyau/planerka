json.extract! article, :id, :title, :slug, :summary, :body, :created_at, :updated_at
json.url article_url(article, format: :json)
