require "rails_helper"


RSpec.describe JudgeController do

  it "JudgeController" do
    judge_controller = JudgeController.new
    # params          = { cards: ["C7 C6 C5 C4 C3"] }
    # post "card_post", params
    post "card_post", { :params => { :card => "C7 C6 C5 C4 C3" } }
    expext(judge_controller.card_post).to eq("ストレートフラッシュ")
  end

  # it "HomeController" do
  #   home_controller = HomeController.new
  #
  # end


end

