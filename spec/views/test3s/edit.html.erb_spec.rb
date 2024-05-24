require 'rails_helper'

RSpec.describe "test3s/edit", type: :view do
  before(:each) do
    @test3 = assign(:test3, Test3.create!())
  end

  it "renders the edit test3 form" do
    render

    assert_select "form[action=?][method=?]", test3_path(@test3), "post" do
    end
  end
end
