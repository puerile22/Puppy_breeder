require 'pg'
module PuppyBreeder
	module Repositories
		class Puppy_list
			attr_reader :db
			def initialize
				@db=PG.connect(host:'localhost', dbname:'puppy-breeder')
			end
			def add(puppy,breeder)
				if puppy.id.nil?
					sql = "INSERT INTO puppy_list(name,breed,age,price,breeder) VALUES($1,$2,$3,$4,$5) returning id"
					result = @db.exec(sql,[puppy.name,puppy.breed,puppy.age,puppy.price,breeder.name])
					puppy.instance_variable_set("@id", result[0]['id'])
				else
					sql = "UPDATE puppy_list SET (name,breed,age,price,breeder) = ($1,$2,$3,$4,$5) WHERE id=$6"
					@db.exec(sql,[puppy.name,puppy.breed,puppy.age,puppy.price,breeder.name,puppy.id])
				end
			end
			def find(id)
				sql = "SELECT * FROM puppy_list WHERE id=$1"
				result = @db.exec(sql,[id])
				PuppyBreeder::Puppy.new(name:result[0]['name'],breed:result[0]['breed'],age:result[0]['age'].to_i,price:result[0]['price'].to_i)
			end
			def find_name(name)
				sql = "SELECT * FROM puppy_list WHERE name=$1"
				result = @db.exec(sql,[name])
				PuppyBreeder::Puppy.new(name:result[0]['name'],breed:result[0]['breed'],age:result[0]['age'].to_i,price:result[0]['price'].to_i)
			end
			def remove(puppy)
				sql = "DELETE FROM puppy_list WHERE name=$1"
				result = @db.exec(sql,[puppy.name])
			end
			def show_puppies
				sql = "SELECT * FROM puppy_list"
			    result = db.exec(sql)
			    if result.to_a !=[]
			    	result.map do |row|
			    		PuppyBreeder::Puppy.new(name: row['name'],breed: row['breed'],age: row['age'].to_i,price: row['price'].to_i)
			    	end
			    end
			end
			def drop_table
				sql = "DROP TABLE puppy_list"
				result = @db.exec(sql)
			end
			def create_table
				sql = "CREATE TABLE puppy_list(id SERIAL PRIMARY KEY,name text,breed text REFERENCES breeds(breed),age integer,price integer,breeder text)"
				result = @db.exec(sql)
			end
		end
    end
end