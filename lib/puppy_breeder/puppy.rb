#Refer to this class as PuppyBreeder::Puppy
module PuppyBreeder
  class Puppy
  	attr_reader :age,:name,:breed,:price,:id
  	def initialize(params)
  		@name=params[:name]
  		@breed=params[:breed]
  		@age=params[:age]
  		@price=params[:price]
      @id=params[:id]
  	end
    def birthday
      @age+=365
    end
  end
end