require "rails_helper"

RSpec.describe Service do

  it "valid?" do
    service = Service.new
    cards   = "ｆう"
    expect(service.valid?(cards)).to eq(false)
  end

  it "duplication" do
    service = Service.new
    cards   = "H1 S1 D2 H1 H5"
    expect(service.cards_conditional_branch(cards)).to eq("カードが重複しています。重複がないようにご入力ください。")
  end

  it "straight_flush_true" do
    service = Service.new
    cards   = "H1 H2 H3 H4 H5"
    expect(service.web_app_judge(cards)).to eq("straight_flush")
  end

  it "four_of_a_kind" do
    service = Service.new
    cards   = "H1 S1 D1 C1 H5"
    expect(service.web_app_judge(cards)).to eq("four_of_a_kind")
  end

  it "full_house" do
    service = Service.new
    cards   = "H2 S2 D2 C1 H1"
    expect(service.web_app_judge(cards)).to eq("full_house")
  end

  it "flush" do
    service = Service.new
    cards   = "H1 H3 H11 H10 H5"
    expect(service.web_app_judge(cards)).to eq("flush")
  end

  it "straight" do
    service = Service.new
    cards   = "H1 S2 D3 D4 H5"
    expect(service.web_app_judge(cards)).to eq("straight")
  end

  it "three_of_a_kind" do
    service = Service.new
    cards   = "H1 S1 D1 C11 H5"
    expect(service.web_app_judge(cards)).to eq("three_of_a_kind")
  end

  it "two_pairs" do
    service = Service.new
    cards   = "H1 S1 D2 C2 H5"
    expect(service.web_app_judge(cards)).to eq("two_pairs")
  end

  it "one_pair" do
    service = Service.new
    cards   = "H1 S1 D13 C11 H5"
    expect(service.web_app_judge(cards)).to eq("one_pair")
  end

  it "high_card" do
    service = Service.new
    cards   = "H11 S10 D1 C13 H5"
    expect(service.web_app_judge(cards)).to eq("high_card")
  end


end
