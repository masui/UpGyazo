# coding: utf-8

require './dropbox_sdk'

class GyazoUpload
  #
  # Dropboxにアップロード
  #
  def upload(file)
    access_token = ENV['DROPBOX_GYAZO_TOKEN']

    unless access_token
      STDERR.puts "Set the environment variable 'DROPBOX_GYAZO_TOKEN'."
      STDERR.puts "You can get the access token using 'dropbox_get_token' program."
      exit
    end

    STDERR.puts "Uploading to Dropbox..."
    file =~ /\.([a-zA-Z0-9_]*)$/
    ext = $1
    hash = Digest::MD5.new.update(File.read(file)).to_s
    dsturl = "https://www.dropbox.com/home?client=1&preview=#{hash}.#{ext}"
    #
    # Dropboxにファイルをアップロード
    #
    STDERR.puts "Copying original file <#{file}> to Dropbox ..."
    
    client = DropboxClient.new(access_token)
    file = File.open(file)
    response = client.put_file("/#{hash}.#{ext}", file)
    puts "uploaded:", response.inspect
    
    dsturl
  end
end
      
