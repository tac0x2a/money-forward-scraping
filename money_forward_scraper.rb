#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'mechanize'
require 'json'

class MoneyForwardScraper

  @@SIGN_IN_URL = "https://moneyforward.com/users/sign_in"
  @@SIGN_OUT_URL = "https://moneyforward.com/users/sign_out"
  @@DEFAULT_URL = "https://moneyforward.com/"
  @@CACHE_FLOW_URL = "https://moneyforward.com/cf"

  def initialize
    @agent = Mechanize.new
    # open local-file
    begin
      @auth_json = JSON.parse(File.read("auth.json", :encoding => Encoding::UTF_8))
    rescue Errno::ENOENT
      puts "no such file 'auth.json'"
      exit 1
    end
  end

  def sign_in
    page = @agent.get(@@SIGN_IN_URL)
    form = page.forms[0]
    form.field_with(:name => 'user[email]').value = @auth_json["mail"]
    form.field_with(:name => 'user[password]').value = @auth_json["password"]
    form.click_button
  end

  def sign_out
    @agent.get(@@SIGN_OUT_URL)
  end

  def total_assets
    value = "null"
    @agent.get(@@DEFAULT_URL).search("section.total-assets div.heading-radius-box").find_all do |e|
      if e.text =~ /(\S+)\u5186/ then
        value = $1
      end
    end
    value
  end

  def create_cacheflow(updated_at, amount, content)
    page = @agent.get(@@CACHE_FLOW_URL)
    page.form_with(:action =>  '/cf/create') do |form|
      form.field_with(:name => 'user_asset_act[updated_at]').value = updated_at
      form.field_with(:name => 'user_asset_act[amount]').value = amount.to_s
      form.field_with(:name => 'user_asset_act[content]').value = content
    end.submit
    {updated_at: updated_at, amount: amount, content: content}
  end
end

class MFSUtil
  def MFSUtil.total_assets
    mfs = MoneyForwardScraper.new
    mfs.sign_in
    value = mfs.total_assets
    mfs.sign_out
    value
  end

  def MFSUtil.create_cacheflow(updated_at: Time.now.strftime("%Y/%m/%d"), amount: '0', content: '')
    mfs = MoneyForwardScraper.new
    mfs.sign_in
    value = mfs.create_cacheflow(updated_at, amount, content)
    mfs.sign_out
    value
  end
end
