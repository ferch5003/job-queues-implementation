class JobsExamplesController < ApplicationController
  def index; end

  def execute_without_job
    p '[Execute without Job]'

    Scrappers::HackerNews.scrapper_news

    redirect_to jobs_examples_path, notice: 'CSV exported without Job successfully'
  rescue StandardError => e
    redirect_to jobs_examples_path, alert: e.to_s
  end

  def execute_with_job
    p '[Execute with Job]'

    job = ExportNewsJob.set(wait: 5.seconds).perform_later

    jid = job.provider_job_id

    p "[ExportNewsJob with ID #{jid}]"

    redirect_to jobs_examples_path, notice: 'CSV exported without Job successfully'
  rescue StandardError => e
    redirect_to jobs_examples_path, alert: e.to_s
  end
end
