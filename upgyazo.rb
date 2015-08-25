# coding: utf-8
#
# upgyazo: 写真ファイルやWordファイルをGyazoにアップロードする
#
# GYAZO_TOKEN環境変数にトークンを書いておく
#

require 'gyazo'
require 'exifr'
require 'find'
require 'digest/md5'

class GyazoUpload
  def initialize(token)
    @gyazo = Gyazo::Client.new token
  end

  def modtime(file)
    time = File.mtime(file)
    if file =~ /\.(jpg|jpeg)$/i then # デジカメのJPEGなど
      begin
        exif = EXIFR::JPEG.new(file).exif.to_hash
        t = exif[:date_time_original].to_s
        time = t if t !~ /^\s*$/
      rescue
      end
    end
    time
  end

  def generate_thumbnail(file)
    thumbfile = "/tmp/junk#{$$}.png"
    #
    # サムネ生成
    #
    if file =~ /\.(jpg|jpeg)$/i then # デジカメのJPEGなど
      system "convert -resize 400x '#{file}' #{thumbfile}"
    else
      system "qlmanage -t -o /tmp -s 200 #{file} > /dev/null 2> /dev/null"
      system "/bin/mv '/tmp/#{File.basename(file)}.png' #{thumbfile} > /dev/null 2> /dev/null"
    end
    thumbfile
  end

  def upload_and_delete(file)
    #
    # アップロードしてID取得, ファイルは消す
    #
    res = @gyazo.upload file
    File.unlink file
    url = res['image_id']
    url =~ /([0-9a-f]{32})/
    $1
  end

  def dst(file,gyazoid)
    file =~ /\.([a-zA-Z]*)$/
    ext = $1
    hash = Digest::MD5.new.update(File.read(file)).to_s
    hash =~ /^(.)(.)/
    [
      "/Users/masui/data/#{$1}/#{$2}/#{hash}.#{ext}",
      "http://masui.sfc.keio.ac.jp/masui/data/#{$1}/#{$2}/#{hash}.#{ext}"
    ]
  end

  def process(file)
    STDERR.puts "Generating thumbnail..."
    thumbfile = generate_thumbnail(file)    # サムネイル生成
    STDERR.puts "Uploading to Gyazo..."
    gyazoid = upload_and_delete(thumbfile)  # アップロードして削除
    (dstfile, dsturl) = dst(file,gyazoid)  # コピー先ファイル名, URLを取得
    #
    # ファイルをコピー
    #
    STDERR.puts "Copying original file <#{file}> to masui.sfc.keio.ac.jp..."
    # system "scp #{file} masui.sfc.keio.ac.jp:#{dstfile} > /dev/null 2> /dev/null"
    # system "ssh masui.sfc.keio.ac.jp chmod 644 #{dstfile} > /dev/null 2> /dev/null"
    #
    # nota@gyazo.cool のプログラム動かして日付とURLを登録
    #
    STDERR.puts "Setting dates and urls on Gyazo.com..."
    time = modtime(file) # EXIFの撮影時刻またはファイル修正時刻
    command = "ssh nota@gyazo.cool sh /home/nota/masui/register '#{gyazoid}' '#{time.to_s.gsub(/ /,"\\ ")}' '#{dsturl}' > /dev/null 2> /dev/null"
    system command

    puts "#{gyazoid}\t#{time}"
  end
end

if __FILE__ == $0 then
  require 'minitest/autorun'

  #
  # convertとかのテストはパスしないはず。入れたいけど?
  #
  class TestGyazoUpload < MiniTest::Test
    def test_test
      assert 1 == 1
    end

    def tet_dst
      (dstfile, dsturl) = dst("./upgyazo.rb","12345")
      assert dstfille =~ /1\/2/
    end
  end
end
