# SeedMigrator

[![Build Status](https://secure.travis-ci.org/HornsAndHooves/seed_migrator.png)](http://travis-ci.org/HornsAndHooves/seed_migrator)
[![Code Climate](https://codeclimate.com/github/HornsAndHooves/seed_migrator.png)](https://codeclimate.com/github/HornsAndHooves/seed_migrator)

The problem of seed data can get annoying once your Rails app is in production.
Ordinarily, you would place your seeds data in `seeds.rb`.  Unfortunately, once
your application goes live, you will likely not be in a position to reload your
seeds.  This leaves you with Rails migrations as the likely choice, but
that now makes development harder, because things seed out of order (migrations
run before seeds).  This gem solves these problems.

## Installation

In your Gemfile:

```ruby
gem 'seed_migrator'
```

## Usage

Data updates are defined similar to migrations.  Each file contains a class
definition which should ideally extend `SeedMigrator::Updater` but doesn't have
to as long as it implements `apply_update` and `revert_update`.  They need to
follow the default Rails naming convention; a file called
`update_order_types.rb` should contain the class `UpdateOrderTypes`.  It is
highly recommended that each file have a prefix that defines its order.  The
format is pretty flexible, but the prefix must start with a number and not have
any underscores.  So `01_update_order_types.rb` is fine, so is
`1A5_update_order_types.rb`.  In each of these cases, the name of the class is
still `UpdateOrderTypes`.  If you extend `SeedMigrator::Updater` you only need to
override `revert_update` if you need your migration to be reversible, otherwise
it's not necessary.

Here's an example data update class definition:

```ruby
class UpdateOrderTypes < SeedMigrators::Updater
  def perform_update
    OrderType.create :type_code => 'very_shiny'
  end

  # Overriden in case we need to roll back this migration.
  def undo_update
    OrderType.where(:type_code => 'very_shiny').first.delete
  end
end
```

### Migrations

Assuming we have created the update file above in `db/data_updates` in a
file named `01_update_order_types.rb`

`root_updates_path` and  optionally `should_run?(update_name)` must be defined
in every migration where we intend to do data updates.  Realistically, our app
should extend `SeedMigrator` and then include the new module in each migration
where needed.

```ruby
module CoreDataUpdate
  include SeedMigrator

  def root_updates_path
    Rails.root.join('db','data_updates')
  end

  def should_run?(update_name)
    Rails.env == 'production'
  end
end
```

Now, define a migration that will perform our data update.

```ruby
class CreateVeryShinyOrderType < ActiveRecord::Migration
  include CoreDataUpdate

  def up
    apply_update :01_update_order_types
  end

  def down
    revert_update :01_update_order_types
  end
end
```

Note that the update prefix is optional.  The following will also work.

```ruby
class CreateVeryShinyOrderType < ActiveRecord::Migration
  include CoreDataUpdate

  def up
    apply_update :update_order_types
  end

  def down
    revert_update :update_order_types
  end
end
```

Old style migrations, i.e. `def self.up` are not supported.

### Seeds

At the bottom of your `seeds.rb`, include the following:

```ruby
include SeedMigrator::Seeds
apply_updates Rails.root.join('db','data_updates')
```

### Generators

Two generators are added for your convenience:

  * install: Updates the seeds file as specified above and creates a custom
    data update module for engines. See
    {file:lib/generators/seed_migrator/create/USAGE} for examples
  * create: Creates new data\_update and migration files as specified above. See
    {file:lib/generators/seed_migrator/install/USAGE} for examples

NOTE: If you're using this from a Rails engine with Rails 3.2 and you're using
RSpec to test, invoking the generator will likely put the generated files in
`spec/dummy/db` instead of `db`.  Just something to be aware of.

## Testing

Install all the gem dependencies.

    bundle install

Run tests

    rake spec

## License

Copyright (c) 2014 HornsAndHooves.
Copyright (c) 2013 TMX Credit.
Released under the MIT License.  See LICENSE file for details.
