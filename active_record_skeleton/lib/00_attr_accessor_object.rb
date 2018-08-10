class AttrAccessorObject
  #should define setter/getter methods
  def self.my_attr_accessor(*names)
    #define_method -- to define getter and setter instance methods you'll want to investigate and use the instance_variable_get and instance_variable_set methods
    # names.each do |name|
    #   #iterate through each attr and implement getters and setters
    names.each do |name|
      define_method(name) {instance_variable_get("@#{name}")}
      define_method("#{name}=") {|val| instance_variable_set("@#{name}", val)}
    end
  end

end
