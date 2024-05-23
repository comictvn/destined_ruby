require 'rails_helper'

RSpec.describe "test2s/new", type: :view do
  before(:each) do
    assign(:test2, Test2.new())
  end

  it "renders new test2 form" do
    render

    assert_select "form[action=?][method=?]", test2s_path, "post" do
    end
  end
end
