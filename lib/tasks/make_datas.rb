require "#{Rails.root}/app/models/article"
require "csv"

def initializers

end

class Tasks::MakeDatas
  def self.execute
    articles = Article.all
    date = Time.zone.now
    send_times = {}
    send_counts = {}
    click_counts = {}
    articles.each do |article|
      CSV.open("data/#{article.article_id}_sum.csv",'w') do |f|
        f << [date.to_s]
        n = rand(1000..30000)
        f << [n]
        send_times[article.article_id] = date
        send_counts[article.article_id] = n
      end
      date = date + 24 * 60 * 60
    end
    articles.each do |article|
      CSV.open("data/#{article.article_id}_click.csv",'w') do |f|
        click_count = (send_counts[article.article_id] * rand(0.1..0.35)).to_i
        click_time = send_times[article.article_id]
        p "click #{click_time},#{click_count}"
        click_count.times {
          f << [click_time]
          click_time = click_time + rand(60..600)
        }
        click_counts[article.article_id] = click_count
      end
    end
    articles.each do |article|
      CSV.open("data/#{article.article_id}_conv.csv",'w') do |f|
        conv_count = (click_counts[article.article_id] * rand(0.1..0.35)).to_i
        conv_time = send_times[article.article_id]
        p "conversion #{conv_time},#{conv_count}"
        conv_count.times {
          f << [conv_time]
          conv_time = conv_time + rand(60..600)
        }
      end
    end
  end



end
