class ExportNewsJob < ApplicationJob
  queue_as :lower_priority

  def perform
    p '[Performing the Job]'
    Scrappers::HackerNews.scrapper_news
  rescue StandardError => e 
    p "Error in the Job: #{e}"
  end
end
