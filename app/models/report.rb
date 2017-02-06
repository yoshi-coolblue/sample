class Report < ApplicationRecord
  has_many :report_articles, dependent: :destroy
  serialize :article_id_list

  def reportable?
    %w(completed).include?(self.status)
  end
end
