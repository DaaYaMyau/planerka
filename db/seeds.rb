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
  topic: [ "переработки", "собеседование", "тестовое", "зарплата", "увольнение", "испытательный срок" ]
}

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
  create_articles
  create_stories(40)
end


def remove_schema_file
  FileUtils.rm_f('db/schema.rb')
  puts "Schema just removed"
end

def reset_db
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

def create_tags
  @tags.each do |kind, names|
    names.each do |name|
      tag = Tag.create!(name: name, kind: kind)
      puts "Tag '#{tag.name}' (#{tag.kind}) just created"
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
    user = User.all.sample

    story = user.stories.create!(
      title: @story_titles.sample,
      body: create_paragraph,
      grade: Story.grades.keys.sample,
      status: [ "published", "published", "published", "pending", "draft" ].sample,
      anonymous: [ true, false ].sample,
      article: [ Article.all.sample, nil ].sample
    )

    story.tags << Tag.all.sample(rand(1..3))

    puts "Story with id #{story.id} just created with #{story.tags.count} tags"
  end
end

seed
