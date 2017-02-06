class CreateReportArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :report_articles do |t|
      t.integer :report_id
      t.integer :article_id
      t.string :title
      t.date :delivery_date
      t.integer :delivery_count

      t.timestamps
    end
  end
end
