<h1 align="center">Geny</h1>

<div align="center">

![Build](https://github.com/rzane/geny/workflows/Build/badge.svg)
![Version](https://img.shields.io/gem/v/geny)
[![Coverage Status](https://coveralls.io/repos/github/rzane/geny/badge.svg?branch=master)](https://coveralls.io/github/rzane/geny?branch=master)

</div>

A tool for building code generators.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'geny'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install geny

## Usage

You are tired of writing the boilerplate for new React components. Let's solve that.

First, let's create a template at `.geny/react/component/templates/component.erb`:

```javascript
import React from "react";

export const <%= name %> = props => {
  return <h1><%= name ></h1>
}
```

Next, we'll define our generator at `.geny/react/component/generator.rb`:

```ruby
parse do
  description "generate a React component"
  usage "geny react:component [NAME]"
  argument :name, required: true, desc: "component name"
end

invoke do
  templates.copy "component.erb", "src/components/#{name}.js"
end
```

Awesome. Run it:

    $ geny react:component Logo
            create  src/components/Logo.js

Obviously, this is a simple example. But Geny comes with a lot of tools to help you build really great code generators with minimal effort.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rzane/geny. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Geny project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rzane/geny/blob/master/CODE_OF_CONDUCT.md).
