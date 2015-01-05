## MoneyForwardScraper

### Example

```ruby
mail     = "your@money-forward.email.address"
password = "M0n3yF0rw4rdP455w0rd"

MoneyForwardScraper.open(mail, password) do |mfs|
  # Show total assets
  p mfs.total_assets
  # => "5,712,315"

  # Get category id
  p mfs.get_categories().get_id_by_names("食費","外食")
  # => [11, 42]

  # Create new category
  p mfs.create_middle_category_by_name("食費", "社員食堂")
  # => [11, 1094831]

  # Create cache flow (with create new category)
  p mfs.create_cacheflow(amount: 1000, content: "Sample Amount", category_names: ["教養・教育","技術書"])
  # => {:updated_at=>"2015/01/06", :amount=>1000, :content=>"Sample Amount", :category_id=>[12, 1094850]}
end
```

or Edit `auth.json` and `$ ruby ./app.rb`.