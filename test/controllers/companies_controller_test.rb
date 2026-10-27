require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company = companies(:cloud)
  end

  test "гость видит список компаний" do
    get companies_url

    assert_response :success
    assert_includes response.body, companies(:cloud).name
    assert_includes response.body, companies(:pixel).name
  end

  test "поиск по названию" do
    get companies_url, params: { q: "пиксель" }

    assert_includes response.body, companies(:pixel).name
    assert_not_includes response.body, companies(:cloud).name
  end

  test "фильтр по сфере" do
    get companies_url, params: { industry: "IT" }

    assert_includes response.body, companies(:cloud).name
    assert_not_includes response.body, companies(:pixel).name
  end

  test "на странице компании только опубликованные отзывы в формате вопрос → ответ" do
    get company_url(@company)

    assert_response :success
    assert_includes response.body, "Что хотели бы знать заранее?"
    assert_includes response.body, reviews(:anna_published).wish_i_knew
    assert_includes response.body, "Кому подойдёт?"
    assert_includes response.body, reviews(:boris_anonymous).wish_i_knew

    get company_url(companies(:pixel))
    assert_not_includes response.body, reviews(:anna_pending).wish_i_knew
  end

  test "на странице компании только опубликованные истории о ней" do
    get company_url(@company)

    assert_includes response.body, "Истории, связанные с компанией"
    assert_includes response.body, stories(:published).title
    assert_not_includes response.body, stories(:pending).title
  end

  test "анонимный отзыв без имени автора" do
    get company_url(@company)

    assert_includes response.body, "Анонимно"
    assert_not_includes response.body, profiles(:boris).nickname
  end

  test "гость видит ссылку на вход вместо формы" do
    get company_url(@company)
    assert_includes response.body, "Войдите, чтобы оставить отзыв"
  end

  test "в списке и поиске только опубликованные компании" do
    get companies_url
    assert_not_includes response.body, companies(:coffee).name
  end

  test "если ничего не нашлось — предлагаем добавить компанию" do
    get companies_url, params: { q: "Рога и копыта" }

    assert_includes response.body, "Ничего не нашлось"
    assert_includes response.body, new_company_path(name: "Рога и копыта")
  end

  test "компанию на модерации видят только автор и админ" do
    get company_url(companies(:coffee))
    assert_redirected_to new_user_session_url

    sign_in users(:anna)
    get company_url(companies(:coffee))
    assert_redirected_to root_url

    sign_in users(:boris)
    get company_url(companies(:coffee))
    assert_response :success
    assert_includes response.body, "Компания на проверке у модератора"
  end

  test "пользователь добавляет компанию — она уходит на модерацию" do
    sign_in users(:anna)

    assert_difference("Company.count") do
      post companies_url, params: { company: { name: "Студия Ромашка", industry: "Дизайн", website: "romashka.example",
                                               status: "published", inn: "7700000099", slug: "hack" } }
    end

    company = Company.last
    assert company.pending?, "статус должен быть pending, даже если прислали published"
    assert_equal users(:anna), company.created_by
    assert_equal "studiya-romashka", company.slug, "slug придумывается из названия"
    assert_nil company.inn, "ИНН обычный пользователь не вводит"
    assert_equal "https://romashka.example", company.website
    assert_redirected_to company_url(company)
  end

  test "отзыв о своей компании на модерации можно оставить сразу, о чужой — нельзя" do
    sign_in users(:boris)
    assert_difference("Review.count") do
      post company_reviews_url(companies(:coffee)), params: { review: { wish_i_knew: "Что смены по 12 часов" } }
    end

    sign_in users(:anna)
    assert_no_difference("Review.count") do
      post company_reviews_url(companies(:coffee)), params: { review: { wish_i_knew: "Текст" } }
    end
  end

  test "подсказка похожих компаний" do
    get similar_companies_url, params: { name: "пиксель" }

    assert_response :success
    assert_includes response.body, "Возможно, вы имели в виду"
    assert_includes response.body, companies(:pixel).name
  end

  test "в подсказке нет компаний на модерации" do
    get similar_companies_url, params: { name: "Зерно" }
    assert_not_includes response.body, companies(:coffee).name
  end

  test "админ видит новые компании и одобряет их" do
    sign_in users(:admin)

    get profile_url
    assert_includes response.body, companies(:coffee).name

    patch company_url(companies(:coffee)), params: { company: { status: "published", inn: "7700000005" } }
    coffee = companies(:coffee).reload
    assert coffee.published?
    assert_equal "7700000005", coffee.inn
  end

  test "админ отклоняет новую компанию, в списке её нет" do
    sign_in users(:admin)

    patch company_url(companies(:coffee)), params: { company: { status: "rejected" } }
    assert companies(:coffee).reload.rejected?

    get companies_url
    assert_not_includes response.body, companies(:coffee).name
  end

  test "обычный пользователь не может править компанию" do
    sign_in users(:boris)

    patch company_url(companies(:coffee)), params: { company: { name: "Взлом" } }
    assert_not_equal "Взлом", companies(:coffee).reload.name
  end

  test "админ создаёт, правит и удаляет компанию" do
    sign_in users(:admin)

    post companies_url, params: { company: { name: "Новая", slug: "novaya", industry: "IT" } }
    assert_redirected_to company_url(Company.find_by(slug: "novaya"))

    patch company_url(@company), params: { company: { industry: "Облака" } }
    assert_equal "Облака", @company.reload.industry

    assert_difference("Company.count", -1) do
      delete company_url(@company)
    end
  end
end
