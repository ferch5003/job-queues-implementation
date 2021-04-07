module Scrappers
  class HackerNews
    attr_accessor :parse_page
    @news = []

    def self.scrapper_news
      p '[Getting news to go]'
      15.times do |index|
        page = index + 1
        p "Page #{page}"
        url = "https://news.ycombinator.com/news?p=#{page}"
        # Open the HTML to make Nokogiri use it
        html = HTTParty.get(url)
        # Using Nokogiri to parse HTML
        @parse_page = Nokogiri::HTML(html.body)

        build_news
      end

      save_news
      p '[Exported your daily news!]'
    rescue StandardError => e
      p "There\'s an error, check it out: #{e}"
    end

    class << self
      private

      def build_news
        @parse_page.css('.athing').each do |element|
          p element
          rank = element.css('td[1] > .rank').text.gsub(/\n/, '')
          title = element.css('td[3] > .storylink').text.gsub(/\n/, '')
          sitebit = element.css('td[3] > .sitebit > a .sitestr').text.gsub(/\n/, '')

          new_arr = [rank, title, sitebit]

          @news << new_arr unless @news.include?(new_arr)
        end
      end

      def save_news
        filename = DateTime.now.to_time.to_i

        CSV.open("#{Rails.root}/storage/news/#{filename}.csv", 'w+') do |csv|
          @news.each { |element| csv.puts(element) }
        end
      end
    end
  end
end
