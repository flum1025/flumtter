flumtter2
===========

##What is it?

ターミナルでTwitterができる。そう、ふらんったーならね。  
サーバーのメンテ中にもTwitter、環境の構築中にもTwitter。いつでもどこでも手放せない最高のクライアントをどうぞ。  
ターミナルなので仕事中、講義中でもTwitterやってるとはバレません！  
SSH接続中にも、GUI環境が無いCUIなOSでもTwitterができます。  
マルチアカウント対応、update_name搭載  
ふぁぼられRTの通知機能もあります。  
Tweetdeckとほぼキー操作が同じなのでいつものように直感的に操作することができます。  
サブウィンドウ出力なのでTLが見にくくなったりすることはありません。  
ユーザーページの閲覧、メンションやふぁぼ一覧などといった一般的なクライアントで使える機能はほぼ対応しています。  
UNIX系OSや""Windows""にも対応！  
  
  
##How to Use(Windowsの方は先に下のEnvironmental constructionを実行してください。)
'twitter','sqlite3','oauth'のgemがインストールされてない場合はflumtter.rbを実行する前に予めflumtterディレクトリに移動し、bundle installを実行してください。
自動でgemがインストールされます。
```
$ git clone https://github.com/flum1025/flumtter.git
$ cd flumtter
$ ruby flumtter.rb #(Windowsの方はruby flumtter_4win.rb)

```
  
```
【Keyboard shortcuts】  
・r #Reply  
・t #Retweet  
・f #Favorite  
・n #New tweet  
・d #Direct message  
・p #User profile  
・m #Mention  
・o #Paku-ru  
・u #Change profile  
・e #Exit  
・c #Clear the terminal screen  
・z #Forced termination and clear the terminal screen  
・s #Setting menu  
・a #Account change  
・? #Help  
・q #Open new terminal  
```
  
基本的にコマンドを入力することで詳細入力のページに飛べますが、  
TLをみながら操作したい人のために入力画面に飛ばずに操作する機能も実装しています。  
急いで入力する人の方が多そうなのでコマンドやスペースには大文字や小文字、全角半角どれでも反応します。  
ただし画面上に入力文字は表示されません。  
  
```
・Reply: r [num or screen_name] 入力文字  
・Retweet: t [num]  
・Favorite: f [num]  
・New tweet: n 入力文字  
・DM: d [num or screen_name] 入力文字  
・User page: p [num or screen_name]  
・Paku-ru: o [num]  
```
  
***[num]は表示されてるツイートの3---------とかになってる部分の数字です。  
Example  
３番目のツイートにリプライ: 'r 3 リプライ'  
  
  

##Environmental construction(Windows)
###Ruby本体のインストール
WindowsにRuby自体が入ってない人はまず[RubyInstaller](http://rubyinstaller.org/downloads/)から好きなバージョンのRubyInstallersをダウンロードしてください。  
1.9.3以上ならどれでも動くと思いますが、Ruby 2.0.0の32bit版を推奨します。(64bitOSの人でも)  
  
###DevelopmentKitのインストール
さっきの[RubyInstaller](http://rubyinstaller.org/downloads/)のサイトのDEVELOPMENT KIT項目のFor use with Ruby 2.0 and above (32bits version only):をダウンロードする。(64bitOSの方も32bitをダウンロードしてください。)
.exeを実行すると解凍が始まりますが、解凍した中身は消してはいけないので先にインストールしたい場所を指定してから解凍をしてください。  
コマンドプロンプトを開き、解凍した先のフォルダを開き以下のコマンドを実行してください。  
  
```
ruby dk.rb init
ruby dk.rb install
```
  
###SSLエラーバグの対処
次に[ここ](https://gist.github.com/luislavena/f064211759ee0f806c88#step-1-obtain-the-new-trust-certificate)からAddTrustExternalCARoot-2048.pemをダウンロードする。  
コマンドプロンプトでgem which rubygemsを実行し.rbを抜いたフォルダにエクスプローラーで移動してください。  
その中にssl_certsフォルダがあると思うので、その中にAddTrustExternalCARoot-2048.pemを入れてください。  
ここまで終了したらHow to Useのステップに移ってください。
  
##Notice
サブウィンドウに関してですが、なぜかウィンドウが初期化されず前のウィンドウで表示していたものがゴミとして残っていたりしています。  
その場合、画面上に表示されてる一番小さい囲いがその画面でのウィンドウなので、そこを目安に文字を読み取ってください。  
そのほかの機能に関しては画面にしたがっていけばわかると思います。  
update_nameやqコマンドを使用する場合は予め設定画面から設定しておく必要があります。  
ターミナルは最低10*60以上の大きさが必要です。  
tokenなどのユーザーデータはflumtter.rbと同じフォルダにtoken.dbとしてデータベースで保存しています。  
  
  
##Afterword
一番最初のflumtterがかなりしょぼかったので１から作り直してみました。  
テスト勉強の合間にだらだらとクソコード書き続けていたので無駄なことばっかりやって千数百行にまでコード膨れ上がってしまいました。  
クソース気持ち悪いと思ったら誰か書き直してください（投げやり  
データの取り回しがめんどくさかったので最小限だけデータを格納して後は全部APIに投げてるので多少APIの消費量が多いです。  
まぁ４ヶ月前のflumtter(仮)に比べてそれなりにruby力は上がったのではないでしょうか。  
あと数ヶ月でrubyの勉強を始めてから一年が経つのでいい加減そろそろまともに使えるようになりたいです。  



詳しい説明はそのうちここに作っておきます。[ふらんちゃんのサイト](http://flum.pw/twitter/index.php?page=flumtter)
なにか質問等ありましたらTwitter:[@flum_](https://twitter.com/flum_)までお願いします。

##License

The MIT License

-------
(c) @2015 flum_