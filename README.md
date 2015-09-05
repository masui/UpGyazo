# ファイルをアップロードしてサムネをGyazoに登録

## 使い方

Usage: ```% upgyazo ファイル {ファイル}```

* 文書や写真のサムネをGyazoにアップロードして本体は```masui.sfc.keio.ac.jp```に格納する。
* 日付やURLをGyazo APIでセットできないので、Gyazo.cool上の```register```, ```register.rb``` を使う
* ```~/.profile```などに ```export GYAZO_TOKEN=0123456789...``` などと書いておいて認証する
* サムネはMacの```convert```か```qlmanage```で生成

今のところほとんど増井専用だが、こういう方針でいろいろできることを実験する。

## CI

```circle.yml``` で自動テストする練習中

[![Circle CI](https://circleci.com/gh/masui/UpGyazo.svg?style=svg)](https://circleci.com/gh/masui/UpGyazo)



