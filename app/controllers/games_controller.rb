require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { Array('a'..'z').sample }

    session[:score] = 0 if session[:score].nil?
  end

def word_in_grid(attempt, grid)
  attempt_letters = attempt.downcase.split("")
  attempt_letters.all? do |letter|
    grid.delete_at(grid.index(letter) || grid.length) if grid.include?(letter)
  end
end

def result_calculus(attempt, grid, result)
  url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
  hash_serialized = open(url).read
  word_hash = JSON.parse(hash_serialized)
  if word_hash["found"] && word_in_grid(attempt, grid)
    result[:score] = attempt.length * 10
    result[:message] = "CONGRATULATION"
    session[:score] += result[:score]
  elsif word_in_grid(attempt, grid) == false
    result[:score] = 0
    result[:message] = "Sorry but this word can't be built from the letters"
  else
    result[:score] = 0
    result[:message] = "Sorry but this is not an english word"
  end
  result
end

  def score

    result = {}
    @true_or_false = word_in_grid(params[:answer], params[:letters].split(""))
    @calculus = result_calculus(params[:answer], params[:letters].split(""), result)
    @attempt = params[:answer]
  end
end
