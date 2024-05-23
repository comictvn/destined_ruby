require 'rails_helper'

RSpec.describe "test2s/show", type: :view do
  before(:each) do
    @test2 = assign(:test2, Test2.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
