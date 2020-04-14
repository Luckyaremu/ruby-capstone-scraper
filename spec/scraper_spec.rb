require './lib/scraper.rb'
# equire 'nokogiri'

RSpec.describe Bot do
  describe '#scraper?' do
    it 'returns a list with products and its prices' do
      expect(shop_cart).to eql('name, specification and price')
    end
  end
  describe '#extract?'
  it 'returns file with the information scraped' do
    expect(File.exist?('smart_phone.csv')).to eql(true)
  end
end
