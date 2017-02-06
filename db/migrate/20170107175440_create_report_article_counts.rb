class CreateReportArticleCounts < ActiveRecord::Migration[5.0]
  def change
    create_table :report_article_counts do |t|
      t.integer :report_article_id
      t.integer :timezone
      t.integer :click_count
      t.integer :conversion_count

      t.timestamps
    end
  end
end
