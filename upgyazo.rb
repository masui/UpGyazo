# -*- ruby -*-
# coding: utf-8
#
# upgyazo: 写真ファイルやWordファイルをGyazoにアップロードする
#
# GYAZO_TOKEN環境変数にトークンを書いておく
#
# CircleCIとかの練習でいろいろ試す
#   circle.yml に記述しておく
#   https://circleci.com/gh/masui/UpGyazo でチェック
#   https://github.com/masui/UpGyazo にも表示される
#

require 'gyazo'
require 'exifr'
require 'find'
require 'digest/md5'
require 'time'

class GyazoUpload
  def initialize(token)
    @gyazo = Gyazo::Client.new token
  end

  def jpeg?(file)
    file =~ /\.(jpg|jpeg)$/i # デジカメのJPEGなど
  end

  def modtime(file)
    time = File.mtime(file)
    if jpeg?(file)
      begin
        exif = EXIFR::JPEG.new(file).exif.to_hash
        t = exif[:date_time_original].to_s
        time = Time.parse(t) if t !~ /^\s*$/
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
    if jpeg?(file)
      begin
        system "convert -resize 400x '#{file}' #{thumbfile}"
      rescue
        thumbfile = nil
      end
    else
      system "qlmanage -t -o /tmp -s 200 #{file} > /dev/null 2> /dev/null"
      system "/bin/mv '/tmp/#{File.basename(file)}.png' #{thumbfile} > /dev/null 2> /dev/null"
    end
    thumbfile
  end

  def upload_and_delete(file, params={})
    #
    # アップロードしてID取得, ファイルは消す
    #
    res = @gyazo.upload file, params
    File.unlink file
    res['image_id'] =~ /([0-9a-f]{32})/
    $1
  end

  #
  # ファイルのコピー+アップロード
  #
  def process(file)
    STDERR.puts "Generating thumbnail..."
    thumbfile = generate_thumbnail(file)    # いろんな方法でサムネイル生成
    if thumbfile then
      STDERR.puts "Uploading to Gyazo..."

      #
      # EXIFの撮影時刻またはファイル修正時刻
      #
      time = modtime(file)
      STDERR.puts "modtime = #{time}"
      #
      # オリジナルのファイルをクラウドにアップロードしてURL取得
      #
      dsturl = upload(file)
      #
      # 時刻とURLを指定してサムネイルをGyazoにアップロード
      # (サムネイルファイルは削除)
      #
      gyazoid = upload_and_delete thumbfile, { 'time' => time, 'url' => dsturl }
      STDERR.puts "Gyazo URL = http://Gyazo.com/#{gyazoid}"
    end
  end
end

if __FILE__ == $0 then
  require 'minitest/autorun'

  #
  # convertとかのテストはパスしないはず。入れたいけど?
  # qlmanage なんてMacでしか動かないからCircleCIではテストできない
  # ssh呼ぶテストも動かないし
  #
  class TestGyazoUpload < MiniTest::Test
    def setup
      @gyazo_token = ENV['GYAZO_TOKEN'] # CircleCIのWebで設定
      @g = GyazoUpload.new @gyazo_token
    end

    def test_gyazotoken
      assert !@gyazo_token.nil?
    end

    def test_jpeg
      assert !@g.jpeg?("./test.png")
    end
    
    #def test_dst
    #  (dstfile, dsturl) = @g.dst("./test.png")
    #  assert dstfile =~ /e\/5/
    #end

    def test_upload
      tmpfile = "/tmp/junk.png"
      system "/bin/cp ./test.png #{tmpfile}"
      assert File.exist?(tmpfile)
      id = @g.upload_and_delete(tmpfile)
      assert id =~ /^[0-9a-f]{32}$/i
      assert !File.exist?(tmpfile)
    end
    
  end
end
