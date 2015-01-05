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

  # Create cache flow
  p mfs.create_cacheflow(amount: 1000, content: "Sample Amount")
end
