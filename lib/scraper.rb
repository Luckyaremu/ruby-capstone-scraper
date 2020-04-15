#!/usr/bin/env ruby
# require_relative '../bin/main.rb'

class Bot
  def feedback
    puts 'All data has been exported to smart_phone.csv'
    puts 'The prices are shown in Nigeria Naira'
    puts 'Thank you for choosing us'
    puts 'Goodbye'
  end

  def added(shop)
    puts "Added phone brand #{shop[:brand]}"
    puts 'Scraping all smart phone ********'
    puts ''
  end

  # rubocop: disable Metrics/MethodLength

  def scraper
    url = 'https://www.jumia.com.ng/smartphones/'
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    smart_phone = []
    shop_cart = parsed_page.css('a.link')
    page = 1
    per_page = shop_cart.count
    total = 100 # parsed_page.css('span.total-products').text.split(' ')[0].split('').drop(1).join('').to_i #1978058
    last_page = (total / per_page)
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
          export(smart_phone)
          smart_phone << shop
          added(shop)
        end
        page += 1
      end
    end
    feedback
  end

  def export(smart_phone)
    CSV.open('smart_phone.csv', 'w') do |csv|
      smart_phone.each do |smart_phone1|
        csv << [smart_phone1]
      end
    end
  end
end
start = Bot.new
start.scraper
# end
# rubocop: enable Metrics/MethodLength
