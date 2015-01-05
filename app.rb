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

  # Create cache flow
  p mfs.create_cacheflow(amount: 1000, content: "Sample Amount", category_names: ["食費","外食"])
  # => {:updated_at=>"2015/01/05", :amount=>1000, :content=>"Sample Amount", :category_id=>[11, 42]}
end
