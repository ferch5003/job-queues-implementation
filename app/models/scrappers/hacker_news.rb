module Scrappers
  class HackerNews
    attr_accessor :parse_page

    def initialize
      @news = []
    end

    def self.scrapper_news
      # Parse the HTML to use Nokogiri
      10.times do |index|
        url = "https://news.ycombinator.com/news?p=#{index}"
        # Open the HTML to make Nokogiri use it
        html = HTTParty.get(url)
        # Using Nokogiri to parse HTML
        @parse_page ||= Nokogiri::HTML(html)

        build_news
      end

      save_news
    end

    private

    def build_news
      @parse_page.css('.athing').each do |element|
        rank = element.css('td[1] > .rank').text.gsub(/\n/, '')
        title = element.css('td[3] > .storylink').text.gsub(/\n/, '')
        sitebit = element.css('td[3] > .sitebit > a .sitestr').text.gsub(/\n/, '')

        new_arr = [rank, title, sitebit]

        @news << new_arr unless @news.include?(new_arr)
      end
    end

    def save_news
      filename = DateTime.now.to_time.to_i

      CSV.open("#{Rails.root}/public/#{filename}.csv", 'w+') do |csv|
        @news.each { |element| csv.puts(element) }
      end
    end
  end
end
