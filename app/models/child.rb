class Child < ApplicationRecord
	include ActiveModel::Serializers::JSON
  extend ActiveModel::Naming
	

	attr_accessor  :id, :age, :name, :glucose, :email ,:birthday, :token

  

	def self.attributes=(hash)
    	hash.each do |key, value|
      	send("#{key}=", value)
    	end
  	end

  def attributes
    instance_values
  end

def self.initialize(hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v.is_a?(Hash) ? Child.new(v) : v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
  end
end

def name
  @name
end

def age
  @age
end






end

