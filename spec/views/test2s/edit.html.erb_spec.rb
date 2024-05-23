require 'rails_helper'

RSpec.describe "test2s/edit", type: :view do
  before(:each) do
    @test2 = assign(:test2, Test2.create!())
  end

  it "renders the edit test2 form" do
    render

    assert_select "form[action=?][method=?]", test2_path(@test2), "post" do
    end
  end
end
