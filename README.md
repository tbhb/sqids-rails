# sqids-rails

[Sqids](https://sqids.org) (formerly [Hashids](https://github.com/hashids)) integration for [Ruby on Rails](https://rubyonrails.org).

From [sqids-ruby](https://github.com/sqids/sqids-ruby):

> [Sqids](https://sqids.org/ruby) _(pronounced "squids")_ is a small library that lets you generate unique IDs from numbers. It's good for link shortening, fast & URL-safe ID generation and decoding back into numbers for quicker database lookups.
>
> Features:
>
> - Encode multiple numbers - generate short IDs from one or several non-negative numbers
> - Quick decoding - easily decode IDs back into numbers
> - Unique IDs - generate unique IDs by shuffling the alphabet once
> - ID padding - provide minimum length to make IDs more uniform
> - URL safe - auto-generated IDs do not contain common profanity
> - Randomized output - Sequential input provides nonconsecutive IDs
> - Many implementations - Support for 40+ programming languages

## Getting started

Run `bundle add sqids-rails` or add this line to your application's `Gemfile`:

```ruby
gem 'sqids-rails'
```

And then execute:

```shell
bundle
```

## Usage

Add auto-generated sqids columns to your ActiveRecord models with `has_sqid`:

```ruby
# Schema: users(sqid:string, long_sqid:string)
class User < ApplicationRecord
  include Sqids::Rails::Model

  has_sqid
  has_sqid :long_sqid, min_length: 24
end

user = User.new
user.save
user.sqid # => "lzNKgEb6ZuaU"
user.sqid_long # => "4y3SVm9M2aV8Olu6p4zZoGij"
user.regenerate_sqid
user.regenerate_long_sqid
```

`has_sqid` follows the same behavior as ActiveRecord's built-in [has_secure_token](https://api.rubyonrails.org/classes/ActiveRecord/SecureToken/ClassMethods.html#method-i-has_secure_token)

Use a custom attribute name (the default is `sqid`):

```ruby
has_sqid :uid
```

Enforce a _minimum length_ for generated IDs:

```ruby
has_sqid min_length: 24
```

Provide a custom alphabet for generated IDs:

```ruby
has_sqid alphabet: "FxnXM1kBN6cuhsAvjW3Co7l2RePyY8DwaU04Tzt9fHQrqSVKdpimLGIJOgb5ZE"
```

Prevent specific words from appearing anywhere in generated IDs:

```ruby
has_sqid blocklist: Set.new(%w[86Rf07])
```

## Roadmap

- [x] `has_sqid` for auto-generating Sqid columns
- [ ] Extensions to [ActiveRecord::FinderMethods](https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html) and [ActiveRecord::Associations::CollectionProxy](https://api.rubyonrails.org/classes/ActiveRecord/Associations/CollectionProxy.html#method-i-find) to find records with a Sqid-encoded primary key

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/tbhb/sqids-rails). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/tbhb/sqids-rails/blob/main/CODE_OF_CONDUCT.md).

## Acknowledgements

Thanks to Ivan Akimov ([@4kimov](https://github.com/4kimov)) for creating and maintaining Sqids and [sqids-ruby](https://github.com/sqids/sqids-ruby), and Roberto Miranda ([@robertomiranda](https://github.com/robertomiranda)) for `has_secure_token`.

## MIT License

Copyright (c) 2024 Anthony Burns

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
