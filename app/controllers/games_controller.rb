class GamesController < ApplicationController
  require "open-uri"
  require "json"

  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split("")
    if valid_word?(@word, @letters) && english_word?(@word)

      # Calculate the score for the word
      score = calculate_score(@word)
      # Update the session to include the new score
      session[:score] ||= 0
      session[:score] += score

      @result = "Congratulations! #{@word} is a valid English word!"
    elsif valid_word?(@word, @letters)
      @result = "Sorry, but #{@word} does not seem to be a valid English word."
    else
      @result = "Sorry, but #{@word} can't be built out of #{@letters}"
    end

    # Store the grand total score
    @grand_total = session[:score]
  end

  private

  def valid_word?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response_serialized = URI.open(url).read
    response = JSON.parse(response_serialized)
    return response["found"]
  end

  def calculate_score(word)
    word.length
  end
end
