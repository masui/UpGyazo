# coding: utf-8
#
# Gyazoデータの日付とURLをセットする。
#  - Gyazo.cool環境で動かす (registerコマンドから呼ぶ)
#  - Mongoデータを直接操作してるので注意!
#
(id, time, url) = ARGV
exit unless id && time && url

d = Image.find_by(image_id: id)
d.date = Time.zone.parse(time).utc
d.metadata = { 'url' => url }

d.update
p d
