class JudgeController < ApplicationController

  def top

  end

  def card_post
    service = Service.new
    cards   = params[:card]
    if service.valid?(cards)
      # service        = Service.new
      flash[:notice] = service.web_app_judge(cards)
      redirect_to("/")
    else
      redirect_to("/")
      flash[:notice] = "大文字のHかSかDかCと半角の1~13までの値をご入力ください。"
    end
  end
end
