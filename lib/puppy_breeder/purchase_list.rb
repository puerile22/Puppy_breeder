require 'pg'
module PuppyBreeder
	module Repositories
		class Purchase_list
			attr_reader :db
			def initialize
				@db=PG.connect(host:'localhost', dbname:'puppy-breeder')
			end
			def add(request,status='on hold')
				if request.id.nil?
					sql = "INSERT INTO purchase_request(name, breed, status) VALUES ($1,$2,$3) returning id"
					result = @db.exec(sql,[request.customer,request.breed,status])
					request.instance_variable_set('@id',result[0]['id'])
				else
					sql = "UPDATE purchase_request SET (name,breed,status)=($1,$2,$3) WHERE id=$4"
					result = @db.exec(sql,[request.customer,request.breed,request.status,request.id])
				end
			end
			def find(id)
				sql="SELECT * FROM purchase_request WHERE id=$1"
				result = @db.exec(sql, [id])
				if result.to_a !=[]
					result.map do |row|
						PuppyBreeder::PurchaseRequest.new({customer:row['name'],breed:row['breed']},row['status'])
					end
				end
			end
			def remove(request)
				sql = "DELETE FROM purchase_request WHERE name=$1 and breed=$2"
				result = @db.exec(sql,[request.customer,request.breed])
			end
			def show_request
				sql = "SELECT * FROM purchase_request"
			    result = db.exec(sql)
			    if result.to_a !=[]
			    	result.map do |row|
			    		PuppyBreeder::PurchaseRequest.new({customer:row['name'],breed:row['breed']},row['status'])
			    	end
			    end
			end
			def drop_table
				sql = "DROP TABLE purchase_request"
				result = @db.exec(sql)
			end
			def create_table
				sql = "CREATE TABLE purchase_request(id SERIAL PRIMARY KEY,name text,breed text,status text)"
				result = @db.exec(sql)
			end
		end
	end
end