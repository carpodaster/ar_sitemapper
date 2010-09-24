# Dummyclass to mock ActiveRecord::Base
class FooBar

  attr_reader :id, :name

  def initialize(*args)
    @id = rand(4711)
  end

  def to_param; id; end

  def self.all(*args)
    3.times.map { self.class.new }
  end

  def self.find(*args)
    unless args.first.is_a?(Hash)
      return self.class.all if args.first == :all
    else
      return self.class.new
    end
  end
 
end