#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'json'

require "./money_forward_scraper"

AuthJsonFile = "auth.json"
mail = password = ""

begin
  auth_json = JSON.parse(File.read(AuthJsonFile, :encoding => Encoding::UTF_8))
  mail     = auth_json["mail"]
  password = auth_json["password"]
rescue Errno::ENOENT
  puts "no such file 'auth.json'"
  exit 1
end

MoneyForwardScraper.open(mail, password) do |mfs|
  # Show total assets
  p mfs.total_assets
  # => "5,712,315"

  # Get Category id
  p categories = mfs.get_categories()
  # => {1=>["収入", {1=>"給与", 2=>"一時所得", 3=>"事業・副業", 4=>"年金", 89=>"配当所得", ...

  # Create cache flow
  p mfs.create_cacheflow(amount: 1000, content: "Sample Amount")
  # => {:updated_at=>"2015/01/05", :amount=>1000, :content=>"Sample Amount"}

end
