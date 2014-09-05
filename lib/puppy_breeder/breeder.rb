#Refer to this class as PuppyBreeder::Breeder
module PuppyBreeder
  class Breeder
  	attr_reader :name,:list,:puppy
  	def initialize(params)
  		@name=params[:name]
      @list=PuppyBreeder::Repositories::Breeders.new
  	end
    def set_price(breed)
      @list.set_price(breed)
    end
  	def generate_request
      @list.generate_request(self)
  	end
  	def accept_requests(customer,puppy)
      @list.accept_request(self,customer,puppy)
  	end
  	def input_request
      @list.add(self)
  	end
  	def add_puppy(puppy,breed,age)
  		@puppy=PuppyBreeder::Puppy.new(name:puppy,breed:breed,age:age,price:self.set_price(breed))
      @list.add_puppy(@puppy,self)
  	end
  end
end