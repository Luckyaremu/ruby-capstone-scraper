require './lib/scraper.rb'
require 'nokogiri'
require 'rubocop'

RSpec.describe Bot do
  describe '#extract' do
    it 'returns file with the information scraped' do
      expect(File.exist?('smart_phone.csv')).to eql(true)
    end
  end
end
