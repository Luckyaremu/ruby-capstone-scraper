#!/usr/bin/env ruby
require_relative '../bin/main.rb'
require 'nokogiri'
require 'httparty'
require 'rubocop'

class Bot
  def feedback
    puts 'All data has been exported to smart_phone.csv'
    puts 'The prices are shown in Nigeria Naira'
    puts 'Thank you for choosing us'
    puts 'Goodbye'
  end

  # rubocop: disable Metrics/MethodLength

  def scraper
    url = 'https://www.jumia.com.ng/smartphones/'
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    smart_phone = []
    shop_cart = parsed_page.css('a.link') # data for 40 phone
    page = 1
    per_page = shop_cart.count # 40
    total = 1000 # parsed_page.css('span.total-products').text.split(' ')[0].split('').drop(1).join('').to_i #1978058
    last_page = (total / per_page) # 26 pages
    begin
      while page <= last_page
        pargination_url = "https://www.jumia.com.ng/mobile-phones/tecno/?page=#{page}"
        puts pargination_url
        puts "page: #{page}"
        puts ''
        pargination_unparsed_page = HTTParty.get(pargination_url)
        pargination_parsed_page = Nokogiri::HTML(pargination_unparsed_page)
        pargination_shop_cart = pargination_parsed_page.css('a.link')
        shop_cart.each do |shop_cart1|
          shop = {
            brand: shop_cart1.css('span.brand').text,
            specifications: shop_cart1.css('span.name').text,
            price_range: shop_cart1.css('span.price').text
          }
          CSV.open('smart_phone.csv', 'w') do |csv|
            smart_phone.each do |smart_phone1|
              csv << [smart_phone1]
            end
          end
          smart_phone << shop
          puts "Added phone brand #{shop[:brand]}"
          puts 'all techno phones available on Jumia Nigeria is been scrapped'
          puts ''
        end
        page += 1
      end
    end
    feedback
  end
end
start = Bot.new
start.scraper
# rubocop: enable Metrics/MethodLength
