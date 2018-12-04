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

  it "straight__flush_score" do
    service = Service.new
    hand    = "straight_flush"
    expect(service.score?(hand)).to eq(9)
  end

  it "four_of_a_kind_score" do
    service = Service.new
    hand    = "four_of_a_kind"
    expect(service.score?(hand)).to eq(8)
  end

  it "full_house_score" do
    service = Service.new
    hand    = "full_house"
    expect(service.score?(hand)).to eq(7)
  end

  it "flush_score" do
    service = Service.new
    hand    = "flush"
    expect(service.score?(hand)).to eq(6)
  end

  it "straight_score" do
    service = Service.new
    hand    = "straight"
    expect(service.score?(hand)).to eq(5)
  end

  it "three_of_a_kind_score" do
    service = Service.new
    hand    = "three_of_a_kind"
    expect(service.score?(hand)).to eq(4)
  end

  it "two_pairs_score" do
    service = Service.new
    hand    = "two_pairs"
    expect(service.score?(hand)).to eq(3)
  end

  it "one_pair_score" do
    service = Service.new
    hand    = "one_pair"
    expect(service.score?(hand)).to eq(2)
  end

  it "high_card_score" do
    service = Service.new
    hand    = "high_card"
    expect(service.score?(hand)).to eq(1)
  end

  it "best?_all_different" do
    # 全て異なる役の場合
    service = Service.new
    score1  = 9
    score2  = 8
    score3  = 7
    expect(service.best?(score1, score2, score3)).to eq(best_hand = [true, false, false])
  end

  it "best?_two_same_pattern1" do
    # 2つの役が同じ∧残りの1つの役よりも強いの場合
    service = Service.new
    score1  = 9
    score2  = 9
    score3  = 7
    expect(service.best?(score1, score2, score3)).to eq(best_hand = [true, true, false])
  end

  it "best__two_same_pattern2" do
    # 2つの役が同じ∧残りの1つの役よりも弱いの場合
    service = Service.new
    score1  = 9
    score2  = 8
    score3  = 8
    expect(service.best?(score1, score2, score3)).to eq(best_hand = [true, false, false])
  end


  it "best__all_same" do
    # 全て同じ役の場合
    service = Service.new
    score1  = 9
    score2  = 9
    score3  = 9
    expect(service.best?(score1, score2, score3)).to eq(best_hand = [true, true, true])
  end
  
end
