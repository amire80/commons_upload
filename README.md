# commons_upload

This is a gem for uploading images to Wikimedia Commons.
It uses the MediaWiki API and the mediawiki-api Ruby gem.
It is currently intended for uploading auto-translated
screenshots created using the screenshot gem, for documenting
different MediaWiki features and extensions.

## Installation

Add this line to your application's Gemfile:

    gem 'commons_upload'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install commons_upload

## Usage

To run the upload, do

    # optional, the default is ./screenshots
    # file names have to be in this format VisualEditor_category_item-en.png
    # language code is `en`, between `-` and `.`
    export LANGUAGE_SCREENSHOT_PATH=./screenshots

    # testing:    https://commons.wikimedia.beta.wmflabs.org/w/api.php
    # production: https://commons.wikimedia.org/w/api.php
    export MEDIAWIKI_API_UPLOAD_URL=https://commons.wikimedia.beta.wmflabs.org/w/api.php

    export MEDIAWIKI_USER=LanguageScreenshotBot
    export MEDIAWIKI_PASSWORD=not-the-real-one

    bundle exec upload

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[![Build Status](https://travis-ci.org/amire80/commons_upload.svg?branch=master)](https://travis-ci.org/amire80/commons_upload)
