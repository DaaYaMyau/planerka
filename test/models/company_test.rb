require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  test "название и slug обязательны" do
    company = Company.new
    assert_not company.valid?
    assert_includes company.errors[:name], "Укажите название"
    assert_includes company.errors[:slug], "Укажите адрес (slug)"
  end

  test "slug уникален и только из латиницы, цифр и дефиса" do
    assert_not Company.new(name: "Копия", slug: "pixel-studio").valid?
    assert_not Company.new(name: "Кириллица", slug: "пиксель").valid?
    assert Company.new(name: "Новая", slug: "new-company-2").valid?
  end

  test "slug — в адресе страницы" do
    assert_equal "/companies/pixel-studio", Rails.application.routes.url_helpers.company_path(companies(:pixel))
  end

  test "поиск по названию без учёта регистра, в том числе для кириллицы" do
    found = Company.search(Company.all, "ПИКСЕЛЬ")
    assert_equal [ companies(:pixel) ], found
  end
end

class CompanyDetailsTest < ActiveSupport::TestCase
  test "slug придумывается из названия и не повторяется" do
    first = Company.create!(name: "Новая компания")
    second = Company.create!(name: "Новая компания")

    assert_equal "novaya-kompaniya", first.slug
    assert_match(/\Anovaya-kompaniya-\d{3}\z/, second.slug)
  end

  test "ИНН необязателен, но если указан — 10 или 12 цифр и уникален" do
    assert Company.new(name: "Без ИНН", inn: "").valid?
    assert_not Company.new(name: "Короткий", inn: "123").valid?
    assert_not Company.new(name: "Копия", inn: companies(:cloud).inn).valid?
    assert Company.new(name: "Двенадцать", inn: "770000000012").valid?
  end

  test "к сайту без http добавляется https://" do
    assert_equal "https://site.example", Company.new(website: " site.example ").website
    assert_nil Company.new(website: "").website
  end

  test "похожие компании: по части названия и по общему слову" do
    assert_includes Company.similar_to("пикс"), companies(:pixel)
    assert_includes Company.similar_to("Пиксель Студия"), companies(:pixel)
    assert_empty Company.similar_to("зерно"), "компании на модерации в подсказку не попадают"
  end
end
