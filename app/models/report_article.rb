class ReportArticle < ApplicationRecord
  belongs_to :report
  has_many :report_article_counts, dependent: :destroy
end
