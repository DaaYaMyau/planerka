# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

@raw_text = "Молодой специалист приходит на первую работу и сталкивается с ситуациями, которые сложно оценить. Руководитель просит задержаться вечером, но переработка не оплачивается. Тестовое задание занимает несколько дней, а компания после этого не выходит на связь. На испытательном сроке обещают оформить договор позже и платят меньше, чем говорили на собеседовании. Коллеги говорят, что так принято, но трудовой кодекс считает иначе. Начальник пишет в мессенджер ночью и ждёт быстрого ответа. Обязанности растут, а зарплата остаётся прежней. Отпуск переносят, премию не выплачивают, а уволиться предлагают одним днём."
@words = @raw_text.downcase.gsub(/[—.,«»:()]/, '').gsub(/\s+/, ' ').split(' ')

@story_titles = [
  "Тестовое задание на 12 часов без оплаты",
  "HR пропал после трёх этапов собеседования",
  "Попросили выйти в выходные без доплаты",
  "На испытательном сроке не оформили договор",
  "Руководитель пишет в Telegram в 23:00",
  "Часть зарплаты платят в конверте",
  "Стажировку назвали волонтёрской и не платят",
  "Обязанности мидла за зарплату джуна",
  "Уволили одним днём по соглашению сторон",
  "Не дают отпуск в первый год работы"
]

@tags = {
  profession: [ "дизайн", "IT", "маркетинг", "аналитика", "продажи" ],
  topic: [ "переработки", "собеседование", "тестовое", "зарплата", "переписки ночью", "отпуск" ],
  stage: [ "поиск работы", "стажировка", "испытательный срок", "работа", "увольнение" ]
}

@nick_words = [ "тихий_джун", "кофейный_стажёр", "ночной_дизайнер", "уставший_аналитик", "смелый_маркетолог", "новичок", "выпускник", "практикант", "мидл_в_пути", "сонный_тестировщик" ]

@companies = [
  { name: "Облачные решения", slug: "oblachnye-resheniya", industry: "IT", website: "https://cloud.example",
    inn: "7700000001", description: "Разрабатывают облачные сервисы для бизнеса." },
  { name: "Студия «Пиксель»", slug: "pixel-studio", industry: "Дизайн", website: "https://pixel.example",
    description: "Небольшая студия: сайты, приложения, айдентика." },
  { name: "Агентство «Громко»", slug: "gromko", industry: "Маркетинг", website: "https://gromko.example",
    description: "Рекламное агентство полного цикла." },
  { name: "Банк «Надёжный»", slug: "bank-nadezhny", industry: "Финансы", inn: "7700000004",
    description: "Розничный банк с офисами в десяти городах." },
  { name: "Сеть магазинов «Корзинка»", slug: "korzinka", industry: "Ритейл",
    description: "Магазины у дома и доставка продуктов." },
  { name: "Лаборатория данных", slug: "data-lab", industry: "IT", website: "https://datalab.example",
    description: "Аналитика и машинное обучение для ритейла." },
  { name: "Маркетплейс «Полка»", slug: "polka", industry: "Ритейл", website: "https://polka.example",
    description: "Онлайн-площадка для небольших продавцов." }
]

@review_answers = {
  wish_i_knew: [
    "Что испытательный срок длится три месяца и всё это время зарплата ниже.",
    "Что задачи ставят в последний момент, а сроки не двигают.",
    "Что наставника не будет — разбираться придётся самой.",
    "Что переработки здесь норма, хотя на собеседовании говорили обратное.",
    "Что отпуск в первый год согласуют с трудом.",
    "Что премия зависит от результатов всего отдела, а не от твоих."
  ],
  suits: [
    "Тем, кто хочет быстро расти и готов много учиться сам.",
    "Тем, кому важна стабильность и понятные процессы.",
    "Тем, кто любит большие проекты и сильную команду.",
    "Студентам, которым нужен первый опыт."
  ],
  not_suits: [
    "Тем, кому нужен чёткий график без переработок.",
    "Тем, кто ждёт подробного онбординга.",
    "Тем, кто не любит много созвонов.",
    "Тем, кому важна удалёнка."
  ]
}

@reply_texts = [
  "Спасибо, что поделились. Мы пересмотрели онбординг: теперь у каждого новичка есть наставник.",
  "Спасибо за отзыв! Испытательный срок у нас действительно три месяца, это прописано в вакансии.",
  "Благодарим за честность. Переработки оплачиваются по ТК, напишите в HR — разберёмся."
]

@articles = [
  { title: "Переработки: когда за них обязаны платить", slug: "pererabotki", summary: "Что считается сверхурочной работой и как её оплачивают." },
  { title: "Неоплачиваемое тестовое: законно ли это", slug: "testovoe", summary: "Где граница между тестовым заданием и бесплатной работой." },
  { title: "Испытательный срок: ваши права", slug: "ispytatelnyy-srok", summary: "Договор, зарплата и увольнение на испытательном сроке." },
  { title: "Увольнение по соглашению сторон", slug: "uvolnenie", summary: "Можно ли отказаться и что обязаны выплатить." },
  { title: "Зарплата в конверте: чем это грозит сотруднику", slug: "zarplata-v-konverte", summary: "Риски серой зарплаты для работника." }
]


def seed
  remove_schema_file
  reset_db
  create_users
  create_tags
  update_profiles
  create_articles
  create_companies
  create_stories(40)
  attach_story_images
  create_votes
  create_comments
  create_bookmarks
  create_reviews
  create_representatives
  create_replies
  create_subscriptions(15)
  print_summary
end


def remove_schema_file
  FileUtils.rm_f('db/schema.rb')
  puts "Schema just removed"
end

def reset_db
  if ActiveStorage::Blob.table_exists?
    ActiveStorage::Blob.find_each { |blob| blob.service.delete(blob.key) }
  end
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
end


def create_sentence
  sentence_words = []

  (10..20).to_a.sample.times do
    sentence_words << @words.sample
  end

  sentence_words.join(' ').capitalize + '.'
end

def create_paragraph
  sentences = []

  (3..6).to_a.sample.times do
    sentences << create_sentence
  end

  sentences.join(' ')
end


def create_users
  admin = User.create!(email: "admin@planerka.ru", password: "testtest", is_admin: true)
  puts "Admin created with id #{admin.id}"

  10.times do |i|
    user = User.create!(email: "user_#{i}@email.com", password: "testtest")
    puts "User created with id #{user.id}"
  end
end

def update_profiles
  User.find_by!(is_admin: true).profile.update!(nickname: "модератор")

  User.where(is_admin: false).find_each do |user|
    nickname = "#{@nick_words.sample}_#{rand(10..99)}"
    nickname = "#{@nick_words.sample}_#{rand(10..99)}" while Profile.exists?(nickname: nickname)

    user.profile.update!(
      nickname: nickname,
      bio: create_sentence,
      grade: Profile.grades.keys.sample,
      profession: Tag.profession.sample
    )

    if rand < 0.5
      path = Dir[Rails.root.join("db/seeds/avatars/*.png")].sample
      user.profile.avatar.attach(io: File.open(path), filename: File.basename(path), content_type: "image/png")
    end

    puts "Profile '#{nickname}' updated for user #{user.id}"
  end
end

def create_tags
  @tags.each do |kind, names|
    names.each_with_index do |name, i|
      tag = Tag.create!(name: name, kind: kind, color: kind == :profession ? Tag::COLORS[i] : nil)
      puts "Tag '#{tag.name}' (#{tag.kind}, #{tag.color || "no color"}) just created"
    end
  end
end

def create_articles
  @articles.each do |data|
    article = Article.create!(
      title: data[:title],
      slug: data[:slug],
      summary: data[:summary],
      body: create_paragraph
    )
    puts "Article with id #{article.id} just created"
  end
end

def create_stories(quantity)
  quantity.times do
    user = User.where(is_admin: false).sample

    story = user.stories.create!(
      title: @story_titles.sample,
      body: create_paragraph,
      grade: [ *Story.grades.keys, nil ].sample,
      status: [ "published", "published", "published", "pending", "draft" ].sample,
      anonymous: [ true, false ].sample,
      article: [ Article.all.sample, nil ].sample,
      company: [ Company.published.sample, nil, nil ].sample,
      created_at: rand(1..60).days.ago - rand(0..23).hours
    )

    story.tags << Tag.profession.sample(1) + Tag.topic.sample(rand(1..2)) + Tag.stage.sample(rand(0..1))

    puts "Story with id #{story.id} just created with #{story.tags.count} tags"
  end
end

def attach_story_images
  paths = Dir[Rails.root.join("db/seeds/images/*")]

  Story.published.sample(6).each do |story|
    paths.sample(rand(1..2)).each do |path|
      story.images.attach(io: File.open(path), filename: File.basename(path))
    end
  end

  puts "Images attached to #{Story.joins(:images_attachments).distinct.count} stories"
end

def create_votes
  Story.published.each do |story|
    User.where(is_admin: false).sample(rand(3..8)).each do |user|
      story.votes.create!(user: user, verdict: Vote.verdicts.keys.sample)
    end
  end

  puts "Votes created: #{Vote.count}"
end

def create_comments
  Story.published.each do |story|
    rand(0..5).times do
      story.comments.create!(user: User.where(is_admin: false).sample, body: create_sentence)
    end
  end

  puts "Comments created: #{Comment.count}"
end

def create_companies
  @companies.each do |data|
    company = Company.create!(data.merge(status: "published"))
    puts "Company '#{company.name}' just created"
  end

  Company.create!(name: "Кофейня «Зерно»", industry: "Общепит", created_by: User.where(is_admin: false).first)
  puts "Pending company created"
end

def create_reviews
  Company.published.find_each do |company|
    User.where(is_admin: false).sample(rand(1..4)).each_with_index do |user, i|
      company.reviews.create!(
        user: user,
        wish_i_knew: @review_answers[:wish_i_knew].sample,
        suits: [ @review_answers[:suits].sample, nil ].sample,
        not_suits: [ @review_answers[:not_suits].sample, nil ].sample,
        grade: [ *Review.grades.keys, nil ].sample,
        anonymous: [ true, false, false ].sample,
        status: i.zero? ? "published" : [ "published", "published", "published", "pending" ].sample
      )
    end
  end

  puts "Reviews created: #{Review.count} (published: #{Review.published.count})"
end

def create_representatives
  users = User.where(is_admin: false).order(:id).last(4)

  [
    [ users[0], "oblachnye-resheniya", "HR-менеджер", "hr@cloud.example", "7700000001", "approved" ],
    [ users[1], "data-lab", "Руководитель отдела", "lead@datalab.example", "7700000006", "approved" ],
    [ users[2], "gromko", "Маркетолог", "gromko.marketing@gmail.com", nil, "pending" ],
    [ users[3], "pixel-studio", "Дизайнер", "designer@pixel.example", "7700000099", "rejected" ]
  ].each do |user, slug, position, work_email, inn, status|
    representative = Company.find_by!(slug: slug).company_representatives.create!(
      user: user, position: position, work_email: work_email, inn: inn,
      proof: "Ссылка на страницу команды на сайте компании."
    )
    representative.approve! if status == "approved"
    representative.rejected! if status == "rejected"
  end

  puts "Representatives created: #{CompanyRepresentative.count} (approved: #{CompanyRepresentative.approved.count})"
end

def create_replies
  CompanyRepresentative.approved.each do |representative|
    representative.company.reviews.published.first(2).each do |review|
      review.create_reply!(user: representative.user, body: @reply_texts.sample)
    end
  end

  review = Review.joins(:reply).first
  review.update!(wish_i_knew: "#{review.wish_i_knew} Дополню: после разговора с HR стало понятнее.", edited_after_reply: true)

  puts "Replies created: #{ReviewReply.count}"
end

def create_subscriptions(quantity)
  quantity.times do |i|
    subscribed_at = rand(1..30).days.ago
    Subscription.create!(email: "subscriber_#{i + 1}@example.ru", consent: "1",
                         created_at: subscribed_at, consented_at: subscribed_at)
  end

  puts "Subscriptions created: #{Subscription.count}"
end

def print_summary
  puts
  puts "=== Готово ==="
  puts "Админ: admin@planerka.ru / testtest"
  puts "Пользователи: #{User.count} (обычные user_0..user_9@email.com, пароль testtest)"
  puts "Истории: #{Story.count} (опубликовано #{Story.published.count}, на модерации #{Story.pending.count})"
  puts "Голоса: #{Vote.count}, комментарии: #{Comment.count}, закладки: #{Bookmark.count}"
  puts "Компании: #{Company.count}, отзывы: #{Review.count}, представители: #{CompanyRepresentative.count}, ответы: #{ReviewReply.count}"
  puts "Подписчики: #{Subscription.count}"
end

def create_bookmarks
  User.where(is_admin: false).find_each do |user|
    user.bookmarked_stories << Story.published.sample(rand(0..4))
  end

  puts "Bookmarks created: #{Bookmark.count}"
end

seed
