require './lib/scraper.rb'

RSpec.describe Bot do
  describe 'export' do
    it 'returns file with the information scraped' do
      expect(File.exist?('smart_phone.csv')).to eql(true)
    end
  end
end
