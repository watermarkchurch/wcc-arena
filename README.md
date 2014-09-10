# WCC::Arena

This gem provides wrappers to the Arena church management system's API.
This is an early version of the library, and has had limited testing in
real world environments. Use at your own risk!

There are also bound to be a few things that are specific to our
configuration and version of Arena. This isn't intentional and we
consider that a bug that we would like to fix. We would love for this to
be a fully featured way to interact with Arena's API.

## Installation

Add this line to your application's Gemfile:

    gem 'wcc-arena'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wcc-arena

## Configuration

You can configure the wcc-arena gem using the `WCC::Arena.configure`
method.

Here is an example configuration block:

```ruby
WCC::Arena.configure do |arena|
  arena.username = 'username'
  arena.password = 'password'
  arena.api_key = 'api_key'
  arena.api_secret = 'api_secret'
  arena.api_url = 'https://arena-domain/api.svc/'
end
```

## Usage

The library is currently a very thin layer over the Arena API. We plan
to add a higher level interface layer that provides a better experience
for the most common use cases.

The library consists of Query classes and Mapper classes. The Query
classes handle calling the respective services and the Mapper classes
handle binding the XML to Ruby objects. For full details on all
available endpoints please see the code. Below are a few examples of
some common queries.

```ruby
person_query = WCC::Arena::PersonQuery.new.where(first_name: "Travis")
people = person_query.call
people.each do |person|
  puts person.full_name
end
```
This will print the full names of all person records with the first name
"Travis". There are a ton of other attributes that are available on a
Person record. Check them out on the
[Person](https://github.com/watermarkchurch/wcc-arena/blob/master/lib/wcc/arena/person.rb)
model.

You can also query tags (or Profiles as they are called under the hood).
To pull all top level Ministry tags run the following:

```ruby
# This assumes that your ministry tags have a type ID of 1.
WCC::Arena::ProfileQuery.new(profile_type_id: 1).call.each do |tag|
  puts tag.name
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
