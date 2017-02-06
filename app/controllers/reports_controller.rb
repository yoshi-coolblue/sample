class ReportsController < ApplicationController
  def index
    @reports = Report.all.order("created_at desc")
  end

  def new
    @articles = Article.all
    @report = Report.new
  end

  def create
    report = Report.new(report_params)
    report.article_id_list = params[:article_id]
    report.status = :reseved
    if report.save
      ReportsJob.perform_later(report)
    end
    redirect_to :action => "index"
  end

  def show
    @report = Report.find_by(id: params[:id])
    report_articles = @report.report_articles
    xdata = []
    ids = []
    total_count = 0
    report_articles.each do |ra|
      xdata << "#{ra.title}:#{ra.delivery_date}"
      ids << ra.id
      total_count += ra.delivery_count
    end
    #xdata = report_articles.map{|ra| "#{ra.title}:#{ra.delivery_date}"}
    delivery_count = report_articles.map{|ra| ra.delivery_count}
    p xdata
    p delivery_count
    @report_articles_graph = LazyHighCharts::HighChart.new('report_articles_graph') do |f|
      f.title(text: 'メルマガ別配信数')
      f.xAxis(categories: xdata)
      f.series(name: '配信数', data: delivery_count, type: "column")
    end
    timezone = []
    0.upto(23){|n| timezone << n}
    #ids = report_articles.map{|ra| ra.id}
    #total_count =
    count_data = ReportArticleCount.select("timezone,SUM(click_count) as click_count,SUM(conversion_count) as conversion_count")
    .where(report_article_id: ids).group(:timezone).order(:timezone)
    p count_data
    p total_count
    click_count = count_data.map{|rac| rac.click_count}
    conv_count = count_data.map{|rac| rac.conversion_count}
    p click_count
    p conv_count
    @timezone_graph = LazyHighCharts::HighChart.new('timezone_graph') do |f|
      f.title(text: '時間帯別集計')
      f.xAxis(categories: timezone)
      f.series(name: 'クリック数', data: click_count)
      f.series(name: 'コンバージョン数', data: conv_count)
    end
  end

  def destroy
    report = Report.find_by(id: params[:id])
    report.destroy
    redirect_to :action => "index"
  end
  private

  def report_params
    params.require(:report).permit(:name)
  end
end
