# Ixtlan Optimistic [![Build Status](https://secure.travis-ci.org/mkristian/ixtlan-optimistic.png)](http://travis-ci.org/mkristian/ixtlan-optimistic) #

it adds optimistic persistence support to DataMapper and ActveRecord usingg the updated_at property/attribute which is automatically updated on any change of the model (for datamapper you need dm-timestamps for that). to load a model use `optimistic_get`/`optimistic_get!`/`optimistic_find` respectively where the first argument is the last `updated_at` value which the client has. if the client data is uptodate then the `optimistic_XYZ` method will return the database entity otherwise raise an exception or return nil respectively.

## rails setup ##

automagic via included railtie. just add

    `gem 'ixtlan-optimistic'
	
to your Gemfile.

## datamapper ##

just include `Ixtlan::Optimistic::DataMapper` to your model:

    class User
      include DataMapper::Resource
      include Ixtlan::Optimistic::DataMapper

      property :id, Serial
      property :name, String
  
      timestamps :at
    end
	
you need timestamps to get to work !

## activerecord ##

just add it with

     ::ActiveRecord::Base.send(:include, 
                               Ixtlan::Optimistic::ActiveRecord)

# meta-fu #

bug-reports, feature request and pull request are most welcome.
