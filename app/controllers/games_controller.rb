require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @guess = params[:guess].upcase
    @letters = params[:letters]
    @charCount = included?
    @web = webCheck
    if @charCount && @web
      @result = "Congratulations #{@guess} is a real word!"
      @points = build_score
    elsif  @charCount  # If true assumes that the count is ok but word isn't real.
      @result = "#{@guess} is not a real word"
    else
      @result = "#{@guess} can't be built from #{@letters}"
    end


  end

  private

  def included?
    @guess.chars.all? { |letter| @guess.count(letter) <= @letters.count(letter) }
  end

  def webCheck
    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    result_serialized = open(url).read
    word = JSON.parse(result_serialized)
    word['found']
  end

  def build_score
    scrabble =
    {  "A"=>1, "B"=>3, "C"=>3, "D"=>2,
      "E"=>1, "F"=>4, "G"=>2, "H"=>4,
      "I"=>1, "J"=>8, "K"=>5, "L"=>1,
      "M"=>3, "N"=>1, "O"=>1, "P"=>3,
      "Q"=>10, "R"=>1, "S"=>1, "T"=>1,
      "U"=>1, "V"=>4, "W"=>4, "X"=>8,
      "Y"=>4, "Z"=>10
    }
    total = 0
    @guess.chars.each { |letter| total += scrabble[letter]}
    return total
  end
end
