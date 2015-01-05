#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'mechanize'

class MoneyForwardScraper
  @@SIGN_IN_URL = "https://moneyforward.com/users/sign_in"
  @@SIGN_OUT_URL = "https://moneyforward.com/users/sign_out"
  @@DEFAULT_URL = "https://moneyforward.com/"
  @@CACHE_FLOW_URL = "https://moneyforward.com/cf"
  @@CATEGORY_URL = "https://moneyforward.com/profile/rule"

  def MoneyForwardScraper.open(mail, password, &block)
    raise ArgumentError, "block not given" unless block_given?

    mfs = MoneyForwardScraper.new(mail, password)
    mfs.sign_in
    yield(mfs)
    mfs.sign_out
  end

  def initialize(mail, password)
    @agent = Mechanize.new
    @mail, @password = mail, password
  end

  def sign_in
    page = @agent.get(@@SIGN_IN_URL)
    form = page.forms[0]
    form.field_with(:name => 'user[email]').value    = @mail
    form.field_with(:name => 'user[password]').value = @password
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

  def create_cacheflow(updated_at: Time.now.strftime("%Y/%m/%d"), amount: '0', content: '')
    page = @agent.get(@@CACHE_FLOW_URL)
    page.form_with(:action =>  '/cf/create') do |form|
      form.field_with(:name => 'user_asset_act[updated_at]').value = updated_at
      form.field_with(:name => 'user_asset_act[amount]').value = amount.to_s
      form.field_with(:name => 'user_asset_act[content]').value = content
    end.submit
    {updated_at: updated_at, amount: amount, content: content}
  end

  def get_categories()
    page = @agent.get(@@CATEGORY_URL)

    categories_links = page.links.select do |link|
      link.node['class'] =~ /[ml]_c_name/
    end

    categories = {}
    category = nil # [id, name, middle_categories]

    categories_links.each do |link|
      node = link.node

      case node['class']
      when /l_c_name/
        category = [node.text, {}]
        categories[node['id'].to_i] = category
      when /m_c_name/
        category[1][node['id'].to_i] = node.text
      end
    end

    # define util method
    def categories.get_id_by_names(large_name, middle_name)
      large = self.find{|l_id, lc| lc[0] == large_name}
      return nil unless large
      l_id, l_name, middle = large.flatten

      middle = middle.find{|m_id, m_name| m_name == middle_name}
      return nil unless middle
      m_id, m_name = middle

      return [l_id, m_id]
    end

    return categories
  end # of get_categories
end
