## MoneyForwardScraper

### How to run

```ruby
mail     = "your@money-forward.email.address"
password = "M0n3yF0rw4rdP455w0rd"

MoneyForwardScraper.open(mail, password) do |mfs|
  # Show total assets
  p mfs.total_assets
  # => "5,712,315"

  # Create cache flow
  p mfs.create_cacheflow(amount: 1000, content: "Sample Amount", category_names: ["食費","外食"])
  # => {:updated_at=>"2015/01/05", :amount=>1000, :content=>"Sample Amount", :category_id=>[11, 42]}
end
```

or Edit `auth.json` and `$ ruby ./app.rb`.