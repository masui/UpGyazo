id = ARGV[0]
time = ARGV[1]
url = ARGV[2]
exit unless id && time && url

#time = time.gsub(/_/,' ')
d = Image.find_by(image_id: id)
d.date = Time.zone.parse(time).utc
d.metadata = { 'url' => url }

d.update
p d
