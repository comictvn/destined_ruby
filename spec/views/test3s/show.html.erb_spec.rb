require 'rails_helper'

RSpec.describe "test3s/show", type: :view do
  before(:each) do
    @test3 = assign(:test3, Test3.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
