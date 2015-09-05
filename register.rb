# coding: utf-8
#
# Gyazoデータの日付とURLをセットする。
#  - Gyazo.cool環境で動かす (registerコマンドから呼ぶ)
#  - Mongoデータを直接操作してるので注意!
#
id = ARGV[0]
time = ARGV[1]
url = ARGV[2]
exit unless id && time && url

d = Image.find_by(image_id: id)
d.date = Time.zone.parse(time).utc
d.metadata = { 'url' => url }

d.update
p d
