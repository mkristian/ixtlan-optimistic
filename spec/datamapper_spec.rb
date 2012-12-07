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

  describe "#optimistic_get" do

    it 'should load' do
      A.optimistic_get(subject.updated_at.to_s, subject.id).must_equal subject
    end

    it 'should fail with stale exception' do
      lambda { A.optimistic_get((subject.updated_at - 1000).to_s, subject.id) }.must_raise Ixtlan::Optimistic::ObjectStaleException
    end

    it 'should fail with nil' do
      A.optimistic_get(subject.updated_at.to_s, subject.id + 987).must_be_nil
    end

  end

  describe "#optimistic_get!" do

    it 'should load' do
      A.optimistic_get!(subject.updated_at.to_s, subject.id).must_equal subject
    end
    
    it 'should fail with not-found exception' do
      lambda { A.optimistic_get!(subject.updated_at.to_s, subject.id + 987) }.must_raise DataMapper::ObjectNotFoundError
    end
    
    it 'should fail with stale exception' do
      lambda { A.optimistic_get!((subject.updated_at - 1000).to_s, subject.id) }.must_raise Ixtlan::Optimistic::ObjectStaleException
    end

  end

end
