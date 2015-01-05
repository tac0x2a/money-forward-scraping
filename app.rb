#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require "./money_forward_scraper"

# Sign in.
mfs = MoneyForwardScraper.new
mfs.sign_in

# Show total assets
p mfs.total_assets

# Create cache flow
p mfs.create_cacheflow(amount: 1000, content: "Sample Amount")

# Sign out.
mfs.sign_out
