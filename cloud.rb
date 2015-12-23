# coding: utf-8

class GyazoUpload
  #
  # ファイルをクラウドにアップロードしてURLを返す
  # (これは増井用だがカスタマイズすればいい)
  #
  def upload(file)
    STDERR.puts "Uploading to cloud..."
    file =~ /\.([a-zA-Z0-9_]*)$/
    ext = $1
    hash = Digest::MD5.new.update(File.read(file)).to_s
    dstfile = "masui.sfc.keio.ac.jp:/Users/masui/data/#{hash[0]}/#{hash[1]}/#{hash}.#{ext}"
    dsturl = "http://masui.sfc.keio.ac.jp/masui/data/#{hash[0]}/#{hash[1]}/#{hash}.#{ext}"
    #
    # クラウドにファイルをアップロード
    #
    STDERR.puts "Copying original file <#{file}> to <#{dstfile}> ..."
    system "scp #{file} #{dstfile} > /dev/null 2> /dev/null"
    system "ssh masui.sfc.keio.ac.jp chmod 644 #{dstfile} > /dev/null 2> /dev/null"
    dsturl
  end
end
      
