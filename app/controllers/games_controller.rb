require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    @letters = params[:letters].split(" ")
    @word = params[:word]
    @result = if !can_be_built?(@word, @letters)
                "Sorry but #{@word.upcase} can't be built out of #{@letters.join(", ")}"
              elsif !english_word?(@word)
                "Sorry but #{@word.upcase} is not an English word"
              else
                "Congratulations! #{@word.upcase} is a valid English word!"
              end
  end

  private

  def can_be_built?(word, letters)
    word.upcase.chars.all? { |letter| word.upcase.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word.downcase}"
    response = URI.open(url).read
    result = JSON.parse(response)
    result["found"]
  end
end
