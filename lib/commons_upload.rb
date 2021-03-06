# frozen_string_literal: true

# Iterate over all images, create license, upload image by image
module CommonsUpload
  def self.edit(file_name, client)
    page = "File:#{file_name}"
    client.edit(title: page, text: license(file_name), summary: 'Update page text')
  end

  def self.license(file_name)
    require 'date'
    date = Date.today.to_s

    # file_name example: VisualEditor_category_item-en.png
    # language_code is the portion of the string between dash (-) and dot (.)
    # in this case it is: en
    language_code = file_name.split('-')[1].split('.')[0]

    <<LICENSE.gsub(/^\s+\|/, '')
      |=={{int:filedesc}}==
      |{{Information
      ||description={{en|1=#{file_name}}}
      ||date=#{date}
      ||source=[[User:LanguageScreenshotBot|Automatically created by LanguageScreenshotBot]]
      ||author=[[User:LanguageScreenshotBot|Automatically created by LanguageScreenshotBot]]
      ||permission=
      ||other_versions=
      ||other_fields=
      |}}
      |
      |=={{int:license-header}}==
      |{{Wikimedia-screenshot}}
      |
      |[[Category:VisualEditor-#{language_code}]]
LICENSE
  end

  def self.image(file_path, client)
    file_name = File.basename(file_path, '')
    file_license = license(file_name)

    begin
      client.upload_image(
        file_name, file_path, 'Upload new version of the file', true, file_license
      )
      return 'OK'
    rescue MediawikiApi::ApiError => mwerr
      return 'exists: fileexists-no-change' if mwerr.code == 'fileexists-no-change'
      return 'exists: fileexists-shared-forbidden' if mwerr.code == 'fileexists-shared-forbidden'
      return "error: #{mwerr}"
    ensure
      edit(file_name, client) # update page content
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
        message = image file_path, client
        puts message
      rescue StandardError => e
        puts 'FAILED'
        raise e
      end
      STDOUT.flush
    end
  end
end
