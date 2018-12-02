require "rails_helper"


RSpec.describe JudgeController do

  it "JudgeController" do
    post "card_post", params = { :card => "C7 C6 C5 C4 C3" }
    expect(response).to redirect_to("/")
  end

end

