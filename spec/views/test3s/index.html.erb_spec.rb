require 'rails_helper'

RSpec.describe "test3s/index", type: :view do
  before(:each) do
    assign(:test3s, [
      Test3.create!(),
      Test3.create!()
    ])
  end

  it "renders a list of test3s" do
    render
  end
end
