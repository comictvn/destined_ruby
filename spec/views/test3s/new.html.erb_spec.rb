require 'rails_helper'

RSpec.describe "test3s/new", type: :view do
  before(:each) do
    assign(:test3, Test3.new())
  end

  it "renders new test3 form" do
    render

    assert_select "form[action=?][method=?]", test3s_path, "post" do
    end
  end
end
