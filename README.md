## MoneyForwardScraper

### How to run

```ruby
mail     = "your@money-forward.email.address"
password = "M0n3yF0rw4rdP455w0rd"

MoneyForwardScraper.open(mail, password) do |mfs|
  # Show total assets
  p mfs.total_assets

  # Create cache flow
  p mfs.create_cacheflow(amount: 1000, content: "Sample Amount")
end
```

or Edit `auth.json` and `$ ruby ./app.rb`.