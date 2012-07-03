require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'
require 'dm-sqlite-adapter'
require 'ixtlan/optimistic/data_mapper'

DataMapper.setup(:default, 'sqlite::memory:')

class A
  include DataMapper::Resource
  include Ixtlan::Optimistic::DataMapper

  property :id, Serial
  property :name, String
  
  timestamps :at
end

DataMapper.finalize
DataMapper.auto_migrate!

describe Ixtlan::Optimistic::DataMapper do

  subject { A.create :name => 'huffalump' }

  it 'should load' do
    A.optimistic_get!(subject.updated_at.to_s, subject.id).must_equal subject
  end

  it 'should fail with nil' do
    A.optimistic_get((subject.updated_at - 1000).to_s, subject.id).must_be_nil
  end

  it 'should fail with exception' do
    lambda { A.optimistic_get!((subject.updated_at - 1000).to_s, subject.id) }.must_raise Ixtlan::Optimistic::ObjectStaleException
  end

end
