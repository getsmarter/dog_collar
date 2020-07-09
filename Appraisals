if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.5.0')
  appraise "rails4" do
    gem "rails", "~> 4"
  end
end

appraise "rails5" do
  gem "rails", "~> 5"
end

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.5.0')
  appraise "rails6" do
    gem "rails", "~> 6"
  end
end
