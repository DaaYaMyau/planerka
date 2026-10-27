require "test_helper"

class CompanyRepresentativeTest < ActiveSupport::TestCase
  test "подсказка: домен почты и сайт компании" do
    representative = company_representatives(:boris_pixel)
    assert representative.email_matches_website?

    representative.work_email = "boris@gmail.com"
    assert_not representative.email_matches_website?

    representative.company.website = nil
    assert_nil representative.email_matches_website?
  end

  test "подсказка: ИНН из заявки и ИНН компании" do
    representative = company_representatives(:vera_cloud)
    assert representative.inn_matches_company?

    representative.inn = "7700000009"
    assert_not representative.inn_matches_company?
  end

  test "при одобрении ИНН компании не перезаписывается, если он уже был" do
    representative = companies(:cloud).company_representatives.create!(
      user: users(:anna), position: "HR", work_email: "anna@cloud.example", inn: "7700000009"
    )
    representative.approve!

    assert_equal "7700000001", companies(:cloud).reload.inn
  end
end
