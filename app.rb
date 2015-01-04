#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require "./money_forward_scraper"

# p MFSUtil.total_assets
p MFSUtil.create_cacheflow(amount: 1000, content: "Sample Amount")
