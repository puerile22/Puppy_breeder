require 'pg'
module PuppyBreeder
  module Repositories
    class Breeds
      attr_reader :db
      def initialize
        @db=PG.connect(host:'localhost',dbname:'puppy-breeder')
      end
      def add
        puts "Please input breed:"
        breed=gets.chomp
        puts "Please input price:"
        price=gets.chomp.to_i
        sql = "INSERT INTO breeds(breed,price) VALUES($1,$2)"
        result = @db.exec(sql,[breed,price])
      end
      def change_price(breed,price)
        sql = "UPDATE breeds SET price='#{price}' WHERE breed='#{breed}'"
        result = @db.exec(sql)
      end
      def show_list
        sql = "SELECT * FROM breeds"
        result = @db.exec(sql)
        return result.to_a
      end
      def drop_table
        sql = "DROP TABLE breeds"
        @db.exec(sql)
      end
      def create_table
        sql = "CREATE TABLE breeds(id SERIAL,breed text PRIMARY KEY,price integer)"
        @db.exec(sql)
      end 
    end
  end
end
