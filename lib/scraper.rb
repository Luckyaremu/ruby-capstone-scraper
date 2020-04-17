require 'nokogiri'
require 'httparty'
require 'rubocop'

class Bot
  # rubocop: disable Metrics/MethodLength
  # rubocop: disable Lint/UselessAssignment

  def scraper
    url = 'https://www.jumia.com.ng/smartphones/'
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    smart_phone = []
    shop_cart = parsed_page.css('a.link')
    page = 1
    per_page = shop_cart.count
    total = 1000
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

  # rubocop: enable Lint/UselessAssignment

  def export(smart_phone)
    CSV.open('smart_phone.csv', 'w') do |csv|
      csv << %w[BRAND SPECIFICATIONS PRICES]
      smart_phone.each do |smart_phone1|
        csv << [smart_phone1[:brand], smart_phone1[:specifications], smart_phone1[:price_range]]
      end
    end
  end

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
end
start = Bot.new
start.scraper

# rubocop: enable Metrics/MethodLength
