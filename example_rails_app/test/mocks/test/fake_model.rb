class FakeModel
  attr_reader :id, :name

  def initialize(id = nil)
    @id   = id || rand(10)
    @name = "#{self.class} ##{@id}"
  end

  def new_record?
    false
  end

  # hack to make Rails think this class is an AR
  alias :old_is_a? :is_a?
  def is_a?(thing)
    if thing == ActiveRecord::Base
      true
    else
      old_is_a?(thing)
    end
  end

  # from ActiveRecord::Base
  def ==(comparison_object)
    comparison_object.equal?(self) ||
      (comparison_object.instance_of?(self.class) && 
        comparison_object.id == id && 
        !comparison_object.new_record?)
  end

  def self.base_class
    self
  end

  def self.find(*args)
    self.new(args[0])
  end
end
