#!/usr/bin/env ruby

require_relative '../bin/main.rb'

class Bot
  def feedback
    puts 'All data has been exported to smart_phone.csv'
    puts 'The prices are shown in Nigeria Naira'
    puts 'Thank you for choosing us'
    puts 'Goodbye'
  end

  def extract(smart_phone)
    CSV.open('smart_phone.csv', 'w') do |csv|
      smart_phone.each do |_smart_phone|
        csv << [smart_phone]
      end
    end
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
    total = 80 # parsed_page.css('span.total-products').text.split(' ')[0].split('').drop(1).join('').to_i #1978058
    last_page = (total / per_page) # 500000
    begin
    while page <= last_page
      pargination_url = "https://www.jumia.com.ng/smartphones/?page=#{page}"
      puts pargination_url
      puts "page: #{page}"
      puts ''
      pargination_unparsed_page = HTTParty.get(pargination_url)
      pargination_parsed_page = Nokogiri::HTML(pargination_unparsed_page)
      pargination_shop_cart = pargination_parsed_page.css('a.link')
      shop_cart.each do |shop_cart|
        shop = {
          brand: shop_cart.css('span.brand').text,
          specifications: shop_cart.css('span.name').text,
          price_range: shop_cart.css('span.price').text
        }
        extract(smart_phone)
        smart_phone << shop
        puts "Added phone brand #{shop[:brand]}"
        puts 'Exporting smart phones ************'
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
