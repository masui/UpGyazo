# ファイルをアップロードしてサムネをGyazoに登録

## 使い方

Usage: ```% upgyazo ファイル {ファイル}```

* 文書や写真のサムネをGyazoにアップロードして本体はクラウドにバックアップする
* 増井の場合は```masui.sfc.keio.ac.jp```に格納する。
* Exifの日付またはファイル更新日付をGyazoにセットする
* Gyazo Tokenを```~/.profile```などに ```export GYAZO_TOKEN=0123456789...``` などと書いておいて認証する
* サムネはMacの```convert```か```qlmanage```で生成
* 今のところMac専用
* 今のところ増井専用


## CI

```circle.yml``` で自動テストする練習中

[![Circle CI](https://circleci.com/gh/masui/UpGyazo.svg?style=svg)](https://circleci.com/gh/masui/UpGyazo)



