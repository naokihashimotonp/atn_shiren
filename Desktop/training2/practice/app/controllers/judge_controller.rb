class JudgeController < ApplicationController

  def top

  end

  def response_to_browser
    params
    if Service.new.cards_receiver(params).valid?
      # service        = Service.new
      flash[:notice] = service.web_app_judge(params)
      redirect_to("/")
    else
      redirect_to("/")
      flash[:notice] = "誤った値が入力されました。入力方法を確認の上、再度ご入力ください。"
    end
  end

end
