# README

## Time-Cardリンク
http://3.115.169.232/

## テストアカウント
- 一般（テスト）
  - アドレス： general_user@gmail.com
  - パスワード: general00
- 管理者（テスト）
  - アドレス: admin_user@gmail.com
  - パスワード: admin000

## 機能概要
このアプリは勤怠管理を目的として作成したアプリです。
出勤、退勤を記録したり、閲覧や編集ができます。
随時追加機能を実装していく予定ですが、現在は下記の機能が実際に使えます。

### ユーザー登録、ログイン機能
ユーザー登録やログイン機能を実装済み。
全ての機能はログインが必須です。Time-Cardのページに飛ぶと最初にログイン画面が表示されます。

### ホーム画面
全てのページへのリンクがボタンとして表示されています。
ホーム画面から全てのページへアクセスできます。

### 勤怠打刻
勤怠打刻のページで出勤、退勤処理ができます。
検索formに名前を入力するとヒットしたユーザー情報が表示。
名前の右に出るボタンを押すことで、出勤、退勤処理ができます。
（少なくともテストアカウントの2つが存在しているので、「テスト」や「一般」などで検索すればユーザー表示確認ができます）

### 自分の勤怠確認
自分の勤怠確認ページで勤怠の確認ができます。
ログインしているユーザーの勤怠のみ確認できます。
（一般の2020年2月の勤怠を入力済みです。一般アカウントでログインし確認できます。）

### 勤怠確認と修正
勤怠確認と修正のページで全てのユーザーの勤怠を確認と修正ができます。
自分の勤怠確認ページと似たページですが、時間表示部がformになっており、修正もできます。

## 追加予定機能
まだ完成していませんが、これから実装予定の機能を書いておきます。

### 権限管理機能
現在ログインしたユーザーが全ての機能を使用できてしまいます。
勤怠確認と修正の機能などは一部の権限をもったユーザーしか使えないようにします。

### 給与計算
時給など登録し、給与計算して表示させる機能を追加します。

### 自動確認機能
例えば退勤忘れのユーザーを自動で検索して教えてくれる機能を追加します。
