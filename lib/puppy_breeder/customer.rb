#Refer to this class as PuppyBreeder::Customer
module PuppyBreeder
  class Customer
  	attr_accessor :request
  	attr_reader :name
  	def initialize(params)
  		@name=params[:name]
  	end
  	def make_request(breed)
  		@request=PuppyBreeder::PurchaseRequest.new(customer:self.name,breed:breed)
  	end
  end
end