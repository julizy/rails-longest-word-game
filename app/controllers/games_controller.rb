require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    generate_grid
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    @message = message(@word, @grid)
  end

  private

  def generate_grid
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def word_anal(attempt)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def message(attempt, grid)
    if included?(attempt.upcase, grid)
      if word_anal(attempt)
        ['Congratulations!', 'is a valid English word!']
      else
        ['Sorry but', 'does not seem to be a valid english word...']
      end
    else
      ['Sorry but', "can't be built out of #{grid.gsub('[', '').gsub(']', '').gsub('"', '')}"]
    end
  end
end
