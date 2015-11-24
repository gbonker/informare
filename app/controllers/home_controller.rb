class HomeController < ApplicationController
  # authorize_resource
  $quote
  def game
  	@threeCandidates = Candidate.all.sample(3)
  	@quote = Candidate.getQuote(@threeCandidates.sample)
    $quote = @quote
    @title = "Directions: Match the Quote and Candidate"
  end

  def exploreIssues
    @issues = Issue.all.shuffle
    @title = "Good work! You have explored xx issues."
  end

  def manageLikedQuotes
    @title = "Manage Your Quotes"
    if logged_in?
      @quotes = current_user.likedQuotes
    end
  end

  def issueInfoTemplate
    @issue = Issue.find(params[:issue_id])
    @quotes = Quote.for_issue(params[:issue_id]).shuffle
    @title = @issue.title
    # limit quotes to ones that haven't been liked by user
  end

  def checkAnswer
  	@correct = params[:user_answer_id].to_s == $quote.candidate_id.to_s
    
    if logged_in?
      current_user.number_of_questions_answered += 1
      current_user.save!
    end
  	if !@correct
  		@response = Candidate.getCorrectMessage($quote.candidate_id)
      if logged_in?
        current_user.current_streak = 0
        current_user.save!
      end
  	else
  		@response = "Correct!"
  		if logged_in?
	  		current_user.current_streak += 1
        current_user.number_of_questions_correct += 1
	  		current_user.save!
	  	end
  	end
  	redirect_to game_path(correct: @correct), notice: @response
  end

  def likeQuote
    @quoteID = params[:quote]
    if logged_in?
      @like = LikedQuote.create(user_id: current_user.id, quote_id: @quoteID)
      @like.save!
      redirect_to issue_info_path(issue_id: params[:issue_id])
    else
      redirect_to issue_info_path(issue_id: params[:issue_id]), alert: "Log in to like quotes."
    end

  end

  def sources
    @sources = Quote.getSources
  end
end
