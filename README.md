# ファイルをアップロードしてサムネをGyazoに登録

## 使い方

Usage: ```% upgyazo ファイル {ファイル}```

* 文書や写真のサムネをGyazoにアップロードして本体はクラウドにバックアップする
* 写真のExifデータの日付またはファイル更新日付をGyazoにセットする
* Gyazoページにクラウドの本体へのリンクが登録される
* サムネはMacの```convert```か```qlmanage```で生成する
 * 今のところMac専用
* デフォルトの格納先はDropbox
* GyazoのアップロードAPIを使うのでGyazo Tokenが必要
 * Gyazo Tokenを```~/.profile```などに ```export GYAZO_TOKEN=0123456789...``` などと書いておいて登録しておく
 * Gyazo Tokenは [https://gyazo.com/oauth/applications](https://gyazo.com/oauth/applications) で取得する

### Dropboxにアップロードする場合

* 以下の方法でアクセストークンを取得して利用
 * dropbox\_get\_token スクリプトを起動する

     % ruby dropbox\_get\_token

 * 指示のURLに飛んでアプリを承認するとアクセストークンが得られる
 * これを環境変数 ```DROPBOX_ACCESS_TOKEN``` に登録する
 * ```.profile``` などに ```export DROPBOX_GYAZO_TOKEN=ABCDEFG...``` などと記述しておく

### 増井の場合

* ```scp```でSFCのサーバにバックアップしている
* ```masui.sfc.keio.ac.jp```に格納するスクリプト```cloud_masui.rb```を利用

## CI

```circle.yml``` で自動テストする練習中

[![Circle CI](https://circleci.com/gh/masui/UpGyazo.svg?style=svg)](https://circleci.com/gh/masui/UpGyazo)



