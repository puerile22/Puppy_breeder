#Refer to this class as PuppyBreeder::PurchaseRequest
module PuppyBreeder
  class PurchaseRequest
  	attr_reader :id,:customer,:breed,:status
  	def initialize(params,status='on hold')
  		@customer, @breed, @status, @id = params[:customer], params[:breed], status, nil
  	end
    def complete 
      @status='complete'
    end
    def pending
      @status='pending'
    end
  end
end