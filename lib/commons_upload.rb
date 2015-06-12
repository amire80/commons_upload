require 'commons_upload/version'

module CommonsUpload
  def self.license(file_name)
    require 'date'

    date = Date.today.to_s

    category = ENV['LANGUAGE_SCREENSHOT_CATEGORY']
    language_code = ENV['LANGUAGE_SCREENSHOT_CODE']

    "=={{int:filedesc}}==
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

[[Category:#{category}/#{language_code}]]"
  end

  def self.image(file_path, client)
    file_name = File.basename(file_path, '')
    file_license = license(file_name)

    client.upload_image(file_name, file_path, file_license, true)
    sleep 5 # Restriction in bot speed: https://commons.wikimedia.org/wiki/Commons:Bots#Bot_speed
  end

  def self.images
    screenshot_directory = ENV['LANGUAGE_SCREENSHOT_PATH'] || './screenshots'
    require 'mediawiki_api'
    client = MediawikiApi::Client.new ENV['MEDIAWIKI_API_UPLOAD_URL']
    client.log_in ENV['MEDIAWIKI_USER'], ENV['MEDIAWIKI_PASSWORD']
    Dir["#{screenshot_directory}/*.png"].each do |file_path|
      puts "Uploading #{file_path}"
      image file_path, client
    end
  end
end
