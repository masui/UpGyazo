# ファイルをアップロードしてGyazoに登録

## 使い方

Usage: ```% upgyazo ファイル```

* 文書や写真のサムネをGyazoにアップロードして本体は```masui.sfc.keio.ac.jp```に格納する。
* ```register```, ```register.rb``` は Gyazo.coolに置く
* ```~/.profile```などに ```export GYAZO_TOKEN=0123456789...``` などと書いておく
* サムネは```convert```か```qlmanage```で生成

今のところ増井専用だが、こういう方針でいろいろできることを実験する。

## CircleCIとか

よくわからないのだが ```circle.yml``` で自動テストしている。

[![Circle CI](https://circleci.com/gh/masui/UpGyazo.svg?style=svg)](https://circleci.com/gh/masui/UpGyazo)



