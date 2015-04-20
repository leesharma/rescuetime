rescuetime v0.2.0 development branch
==========

[![Quality](http://img.shields.io/codeclimate/github/leesharma/rescuetime.svg?style=flat-square)](https://codeclimate.com/github/leesharma/rescuetime)
[![Build](https://img.shields.io/travis/leesharma/rescuetime/data-analytics-api.svg?style=flat-square)](https://travis-ci.org/leesharma/rescuetime)
[![Dependencies](https://img.shields.io/gemnasium/leesharma/rescuetime.svg?style=flat-square)](https://gemnasium.com/leesharma/rescuetime)
[![Downloads](https://img.shields.io/gem/dt/rescuetime.svg?style=flat-square)](https://rubygems.org/gems/rescuetime)
[![Release](https://img.shields.io/github/release/leesharma/rescuetime.svg?style=flat-square)](https://github.com/leesharma/rescuetime/releases/tag/v0.1.0)
[![License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](http://opensource.org/licenses/MIT)

**This is the v0.2.0 development branch, which will allow full access to the RescueTime Data Analytics API. For more information about the progress towards the release, [view the issue tracking for this milestone](https://github.com/leesharma/rescuetime/milestones/v1.0.0%20(Data%20Analytics%20API))**

A Ruby interface to the RescueTime APIs. Rescuetime provides a simple DSL for interacting
with your personal or team RescueTime data.

Currently, this gem only supports the Data Analytics API with API key authorization.

For more information about RescueTime, visit [the RescueTime homepage](https://www.rescuetime.com).

* [Installation](#installation)
* [Usage](#usage)
   * [Prerequisites](#prerequisites)
   * [Getting Started](#getting-started)
* [Development](#development) ([wiki](https://github.com/leesharma/rescuetime/wiki/Development))
* [Contributing](#contributing) ([wiki](https://github.com/leesharma/rescuetime/wiki/Contributing))

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rescuetime'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rescuetime

## Usage

### Prerequisites

Ensure that you are using a [supported ruby version](https://github.com/leesharma/rescuetime/wiki/Supported-Rubies) for your project. 

In order to use access your RescueTime data, you will need an API key. If you do not already have a key, visit the [API key management page](https://www.rescuetime.com/anapi/manage).

### Getting Started

Using the rescuetime gem is simple. Here is some example code using the rescuetime gem:

```ruby
require 'rescuetime'

@client = Rescuetime::Client.new(api_key: <YOUR_API_KEY>)

@client.activities          # Returns a list of activities, ordered by "rank"

@client.activities.class    # => Array
@client.activities[0].class # => Hash

@client.activities[0]       
# => {   
#       :rank=>1, 
#       :time_spent_seconds=>5307, 
#       :number_of_people=>1, 
#       :activity=>"github.com", 
#       :category=>"General Software Development", 
#       :productivity=>2
#    }

# This is not a valid request yet, but it showcases the v0.2.0 features
# you can expect.
@client.activities { by: 'time',
                     time_interval: 'minute',
                     date: '2015-04-16',
                     detail: 'activity',
                     only: 'Software Development' }
```

### Defaults

The `Rescuetime::Client#activities` action has the following defaults:

```ruby

{ by:               'rank'
  time_interval:    'hour'
  date:             <TODAY>
  detail:           'productivity' }

```

## Development

See the [development page](https://github.com/leesharma/rescuetime/wiki/Development) of the wiki.

## Contributing

See the [contributing page](https://github.com/leesharma/rescuetime/wiki/Contributing) of the wiki.
