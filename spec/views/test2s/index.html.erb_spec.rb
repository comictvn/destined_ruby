require 'rails_helper'

RSpec.describe "test2s/index", type: :view do
  before(:each) do
    assign(:test2s, [
      Test2.create!(),
      Test2.create!()
    ])
  end

  it "renders a list of test2s" do
    render
  end
end
