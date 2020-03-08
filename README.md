# Mwiki

Search from any MediaWiki.

The default host is ja.wikipedia.org.


## Installation

Add this line to your application's Gemfile:

```sh
$ gem install mwiki
```

## Usage

```
$ mwiki <word>
```

By default, words searched once are cached in `$HOME/.mwiki`.

If you do not want to use cached results, specify the following options:

```
$ mwiki --no-cache <word>
```

To change the host, specify the following options:

```
$ mwiki --host=<media wiki host> <word>
```

*This command allows only https.*

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mwiki.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
