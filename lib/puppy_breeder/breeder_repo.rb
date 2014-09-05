require 'pg'
module PuppyBreeder
	module Repositories
		class Breeders
			attr_accessor :purchase_request,:puppy_list,:breeds
			def initialize
				@db=PG.connect(host:'localhost',dbname:'puppy-breeder')
				@purchase_request=PuppyBreeder::Repositories::Purchase_list.new
				@puppy_list=PuppyBreeder::Repositories::Puppy_list.new
			end 
			def generate_request(breeder)
        sql = "DELETE FROM purchase_list WHERE breeder='#{breeder.name}' and status='on hold'"
        result = @db.exec(sql)
        sql = "DELETE FROM purchase_list WHERE breeder='#{breeder.name}' and status='pending'"
        result = @db.exec(sql)
				sql = "SELECT * FROM puppy_list WHERE breeder=$1"
				result = @puppy_list.db.exec(sql, [breeder.name])
				result_1=result.to_a
				result_1.each do |line|
					sql = "SELECT * FROM (SELECT * FROM purchase_request WHERE breed=$1) AS T WHERE status='on hold' LIMIT 1"
					re1 = @purchase_request.db.exec(sql,[line['breed']])
					re1_arr=re1.to_a
            if re1_arr.length==0
                next
            else
                id = re1_arr[0]['id']
                sql = "UPDATE purchase_request SET status='pending' WHERE id='#{id}'"
                re2 = @purchase_request.db.exec(sql)
        		    sql = "INSERT INTO purchase_list(breeder,customer,puppy_name,breed,status) VALUES($1,$2,$3,$4,$5) returning *"
        		    re = @db.exec(sql,[breeder.name,re1_arr[0]['name'],line['name'],line['breed'],'pending'])
            end
				end
        sql = "SELECT * FROM purchase_request WHERE status='on hold'"
        result = @purchase_request.db.exec(sql)
        result.to_a.each do |line|
            sql = "INSERT INTO purchase_list(breeder,customer,puppy_name,breed,status) VALUES($1,$2,$3,$4,$5)"
            re = @db.exec(sql,[breeder.name,line['name'],'unknown',line['breed'],'on hold'])
        end
        sql = "UPDATE purchase_request SET status='on hold' WHERE status='pending'"
        result = @purchase_request.db.exec(sql)
		  end
			def accept_request(breeder,customer,puppy)
				sql = "UPDATE purchase_list SET status='complete' WHERE breeder=$1 and puppy_name=$2 returning *"
				result = @db.exec(sql,[breeder.name,puppy])
        breed=result.to_a[0]['breed']
        request = PuppyBreeder::PurchaseRequest.new(customer:customer,breed:breed)
				@purchase_request.remove(request)
        result = @puppy_list.find_name(puppy)
				@puppy_list.remove(result)
			end
			def add_puppy(puppy,breeder)
				@puppy_list.add(puppy,breeder)
			end
			def add(breeder)
				customer=""
		  		puppy=""
		  		breed=""
		        age=""
		  		puts "Please input customer's name"
		  		customer=gets.chomp
		  		puts "Please input puppy's name"
		  		puppy=gets.chomp
		      puts "Please input puppy's breed"
		      breed=gets.chomp
		  		puts "Please input puppy's age"
		  		age=gets.chomp.to_i
          request=PuppyBreeder::PurchaseRequest.new(customer:customer,breed:breed)
          the_breed=request.breed
          @purchase_request.add(request)
		  		sql = "SELECT * FROM puppy_list WHERE breeder='#{breeder.name}'"
		  		result_1 = @puppy_list.db.exec(sql)
		  		sql = "SELECT * FROM (SELECT * FROM purchase_list WHERE breeder='#{breeder.name}') AS T WHERE status='pending'"
		  		result_2 = @db.exec(sql)
		  		if result_1.to_a.select{|line| line['breed']==the_breed}.length > result_2.to_a.select {|line| line['breed']==the_breed}.length && result_1.to_a.select{|line| line['breed']==the_breed}
                    sql = "INSERT INTO purchase_list(breeder,customer,puppy_name,breed,status) VALUES($1,$2,$3,$4,'pending') returning *"
                    result = @db.exec(sql,[breeder.name,customer,puppy,breed])
                    request.pending
                    @purchase_request.add(request)
		  		end
			end
      def show_list(breeder)
          sql = "SELECT * FROM purchase_list WHERE breeder='#{breeder.name}'"
          result = @db.exec(sql)
          return result.to_a
      end
      def show_complete_list(breeder)
          sql = "SELECT * FROM (SELECT * FROM purchase_list WHERE status='complete') AS T WHERE breeder='#{breeder.name}'"
          result = @db.exec(sql)
          return result.to_a
      end
      def show_pending_list(breeder)
          sql = "SELECT * FROM (SELECT * FROM purchase_list WHERE status='pending') AS T WHERE breeder='#{breeder.name}'"
          result = @db.exec(sql)
          return result.to_a
      end
      def show_on_hold_list(breeder)
          sql = "SELECT * FROM (SELECT * FROM purchase_list WHERE status='on hold') AS T WHERE breeder='#{breeder.name}'"
          result = @db.exec(sql)
          return result.to_a
      end
      def set_price(breed)
        @breeds = PuppyBreeder::Repositories::Breeds.new
        sql = "SELECT * FROM breeds WHERE breed='#{breed}'"
        result = @breeds.db.exec(sql)
        return result.to_a[0]['price'].to_i
      end
			def drop_table
				sql = "DROP TABLE purchase_list"
				result = @db.exec(sql)
			end
			def create_table
				sql = "CREATE TABLE purchase_list(id SERIAL PRIMARY KEY,breeder text,customer text,puppy_name text,breed text,status text)"
				result = @db.exec(sql)
			end
		end
	end
end