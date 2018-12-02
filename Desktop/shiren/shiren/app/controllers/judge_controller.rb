class JudgeController < ApplicationController

  def top

  end

  def card_post
    service        = Service.new
    cards          = params[:card]
    flash[:notice] = service.cards_conditional_branch(cards)
    redirect_to("/")
  end

end
