# Iterate over all images, create license, upload image by image
module CommonsUpload
  def self.license(file_name)
    require 'date'
    date = Date.today.to_s

    # file_name example: VisualEditor_category_item-en.png
    # language_code is the portion of the string between dash (-) and dot (.)
    # in this case it is: en
    language_code = file_name.split('-')[1].split('.')[0]

    <<~LICENSE
      =={{int:filedesc}}==
      {{Information
      |description={{en|1=#{file_name}}}
      |date=#{date}
      |source=[[User:LanguageScreenshotBot|Automatically created by LanguageScreenshotBot]]
      |author=[[User:LanguageScreenshotBot|Automatically created by LanguageScreenshotBot]]
      |permission=
      |other_versions=
      |other_fields=
      }}

      =={{int:license-header}}==
      {{Wikipedia-screenshot}}

      [[Category:VisualEditor-#{language_code}]]
    LICENSE
  end

  def self.image(file_path, client)
    file_name = File.basename(file_path, '')
    file_license = license(file_name)

    begin
      client.upload_image(file_name, file_path, file_license, true)
    rescue MediawikiApi::ApiError => mwerr
      raise mwerr if mwerr.code != 'fileexists-no-change'
      puts 'File already uploaded.'
    ensure
      sleep 5 # Restriction in bot speed: https://commons.wikimedia.org/wiki/Commons:Bots#Bot_speed
    end
  end

  def self.images
    screenshot_directory = ENV['LANGUAGE_SCREENSHOT_PATH'] || './screenshots'
    require 'mediawiki_api'
    client = MediawikiApi::Client.new ENV['MEDIAWIKI_API_UPLOAD_URL']
    client.log_in ENV['MEDIAWIKI_USER'], ENV['MEDIAWIKI_PASSWORD']
    Dir["#{screenshot_directory}/*.png"].each do |file_path|
      print "Uploading #{file_path} ... "
      STDOUT.flush
      begin
        image file_path, client
        puts 'OK'
      rescue StandardError => e
        puts 'FAILED'
        raise e
      end
      STDOUT.flush
    end
  end
end
