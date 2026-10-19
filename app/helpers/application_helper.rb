module ApplicationHelper
  def feed_path(filters = {})
    Rails.configuration.x.teaser ? admin_stories_path(filters) : root_path(filters)
  end

  def avatar_for(user, size: 32)
    style = "width: #{size}px; height: #{size}px; border-radius: 50%; vertical-align: middle;"
    avatar = user.profile&.avatar

    if avatar&.attached? && avatar.blob.persisted?
      image_tag avatar, alt: user.display_name, style: "#{style} object-fit: cover;"
    else
      tag.span user.display_name.first.upcase,
               style: "#{style} display: inline-flex; align-items: center; justify-content: center; " \
                      "background: #e0e0e0; color: #555; font-size: #{size / 2}px;"
    end
  end
end
