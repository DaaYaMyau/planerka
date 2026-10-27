require "test_helper"

class CompanyRepresentativesControllerTest < ActionDispatch::IntegrationTest
  test "гость не может подать заявку" do
    get new_company_company_representative_url(companies(:cloud))
    assert_redirected_to new_user_session_url
  end

  test "пользователь подаёт заявку" do
    sign_in users(:anna)

    get company_url(companies(:pixel))
    assert_includes response.body, "Я представляю эту компанию"

    assert_difference("CompanyRepresentative.count") do
      post company_company_representatives_url(companies(:pixel)),
           params: { company_representative: { position: "HR", work_email: "anna@pixel.example", inn: "7700000003", status: "approved" } }
    end

    representative = CompanyRepresentative.last
    assert representative.pending?, "статус должен быть pending, даже если прислали approved"
    assert_equal users(:anna), representative.user
  end

  test "повторную заявку нельзя подать, пока есть рассматриваемая" do
    sign_in users(:boris)

    get company_url(companies(:pixel))
    assert_includes response.body, "Ваша заявка представителя на рассмотрении"

    assert_no_difference("CompanyRepresentative.count") do
      post company_company_representatives_url(companies(:pixel)),
           params: { company_representative: { position: "HR", work_email: "boris@pixel.example" } }
    end
    assert_includes response.body, "Вы уже подали заявку на эту компанию"
  end

  test "обычный пользователь не видит чужие заявки и не может их одобрить" do
    sign_in users(:anna)

    get company_representative_url(company_representatives(:boris_pixel))
    assert_redirected_to root_url

    patch company_representative_url(company_representatives(:boris_pixel)), params: { status: "approved" }
    assert company_representatives(:boris_pixel).reload.pending?
  end

  test "админ видит подсказки и одобряет заявку, ИНН записывается в компанию" do
    sign_in users(:admin)

    get profile_url
    assert_includes response.body, "Заявки представителей"

    get company_representative_url(company_representatives(:boris_pixel))
    assert_includes response.body, "✓ совпадают (pixel.example)"
    assert_includes response.body, "при одобрении запишем ИНН из заявки"

    patch company_representative_url(company_representatives(:boris_pixel)), params: { status: "approved" }
    assert company_representatives(:boris_pixel).reload.approved?
    assert_equal "7700000002", companies(:pixel).reload.inn
  end

  test "админ отклоняет заявку" do
    sign_in users(:admin)

    patch company_representative_url(company_representatives(:boris_pixel)), params: { status: "rejected" }
    assert company_representatives(:boris_pixel).reload.rejected?
  end

  test "у подтверждённой компании — отметка «Компания на Планёрке ✓»" do
    get company_url(companies(:cloud))
    assert_includes response.body, "Компания на Планёрке ✓"

    get company_url(companies(:pixel))
    assert_not_includes response.body, "Компания на Планёрке ✓"
  end

  test "представитель правит описание, сайт, сферу и ИНН, но не название" do
    sign_in users(:vera)

    patch company_url(companies(:cloud)), params: { company: { description: "Новое описание", industry: "Облака",
                                                              name: "Взлом", status: "pending" } }

    cloud = companies(:cloud).reload
    assert_equal "Новое описание", cloud.description
    assert_equal "Облака", cloud.industry
    assert_equal "Облачные решения", cloud.name
    assert cloud.published?
  end

  test "представитель не может удалить компанию и отзывы" do
    sign_in users(:vera)

    assert_no_difference([ "Company.count", "Review.count" ]) do
      delete company_url(companies(:cloud))
      delete company_review_url(companies(:cloud), reviews(:anna_published))
    end
  end

  test "представитель чужой компании её не правит" do
    sign_in users(:vera)

    patch company_url(companies(:pixel)), params: { company: { description: "Взлом" } }
    assert_not_equal "Взлом", companies(:pixel).reload.description
  end
end
