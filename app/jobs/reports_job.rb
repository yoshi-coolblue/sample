class ReportsJob < ApplicationJob
  require "csv"

  queue_as :default

  def perform(report)
    # Do something later
    begin
      report.status = :reporting
      report.save
      report.article_id_list.each do |article_id|
        sleep(10)
        summary = CSV.read("data/#{article_id}_sum.csv",'r')
        article = Article.find_by(article_id: article_id)
        report_article = ReportArticle.new(
          report_id: report.id,
          article_id: article_id,
          title: article.title,
          delivery_date: summary[0][0],
          delivery_count: summary[1][0]
        )
        report_article.save
        click_count = _read_count "data/#{article_id}_click.csv"
        #Delayed::Worker.logger.info click_count
        conv_count = _read_count "data/#{article_id}_conv.csv"
        #Delayed::Worker.logger.info conv_count
        "00".upto("23") {|tz|
          report_article_count = ReportArticleCount.new(report_article_id: report_article.id, timezone: tz.to_i)
          report_article_count.click_count = click_count[tz] unless click_count[tz].nil?
          report_article_count.conversion_count = conv_count[tz] unless conv_count[tz].nil?
          report_article_count.save
        }
      end
      report.status = :completed
    rescue => e
      Delayed::Worker.logger.error e.message
      report.status = :error
    ensure
      report.save
    end
  end

  private

  def _read_count(file_name)
    csv = CSV.read(file_name,'r')
    time_data = csv.map {|rec| rec[0].slice(11,2)}
    time_data.inject(Hash.new(0)) {|h, key| h[key] += 1; h }
  end
end
