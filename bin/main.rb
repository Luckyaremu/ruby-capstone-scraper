#!/usr/bin/env ruby
require 'nokogiri'
require 'httparty'
require 'rubocop'

require_relative '../lib/scraper.rb'
def initialize
  display
  @searches = 0
end

def search
  input
  p 'Search in progess...'
  sleep 1
end

private

def input
  input = gets.chomp
  while input.empty?
    puts 'Please enter a keyword'
    input = gets.chomp
  end
  puts 'Thank you!'
  @keywords = input.split(' ')
end

def display
  puts 'Welcome to jumia.com.ng'
  puts 'This website L you to find all smart-phone and tablets sold on jumia online shop.'
  puts 'Type your keywords and press enter to find out everything related to Tablet-smartphone sold on jumia.'
end
