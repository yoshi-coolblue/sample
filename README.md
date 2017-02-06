＝＝ 概要

配信したメルマガ記事の配信数やクリック、コンバージョン数をグラフ（レポート）化するアプリケーションです。
メルマガ記事の一覧からグラフ化したい記事を選択してsubmitするとオンバッチ処理がCSVデータを取得して
集計処理を行います。
集計処理が完了すると、グラフ（レポート画面）が表示できる様になります。
コーディングスタイルなどの確認用にデザインやチェック処理、テストコードなどは省略しています。

== 開発環境

以下の環境で開発しています。

* OS mac
* ruby 2.2.3
* DB mysql 5.7

== 起動

* 初回のみ
bin/rake db:reset

* 起動
bin/delayed_job start
bin/rails s -b 0.0.0.0

== CSVデータ作成

DB作成、Rails起動後に以下のバッチでCSVデータを作成します。

* mkdir data
* bin/rails runner Tasks::MakeDatas.execute
