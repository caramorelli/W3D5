require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    obj = DBConnection.execute2(<<-SQL)
      SELECT *
      FROM #{self.table_name}
    SQL
    obj.first.map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |col|
      define_method(col) do
        self.attributes[col]
    end

      define_method("@#{col}=") do |value|
        self.attributes[col] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  # class getter method ::table_name which will get the name of the table for the class
  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  # ::all: return an array of all the records in the DB
  def self.all
    @all_records = []
    table_cols = self.columns
    row = DBConnection.execute2(<<-SQL)
      SELECT *
      FROM #{self.table_name}
    SQL
    row.shift
    row.each do |row_ele|
      @all_records << row_ele
    end
    @all_records
    @obj_record = @all_records.map { |obj| self.new(obj) }
    parse_all(obj_record)
  end

  def self.parse_all(results)
    objs = []
    results.each do |object|
      if object.is_a?(Hash)
        objs = object.map { |ele| self.new(ele) }
      end
    end
  end

  #::find: look up a single record by primary key
  def self.find(id)
    # self.fetch("@#{id}")
    self.all.find { |obj| obj.id == id }
  end

  def initialize(params = {})
    params.each do |ele|
      print ele.finalize!
      puts ''
    end
    #
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    attr_vals = []
  end

  #insert: insert a new row into the table to represent the SQLObject.
  def insert

  end

  # update: update the row with the id of this SQLObject
  def update
    # ...
  end

  # save: convenience method that either calls insert/update depending on whether or not the SQLObject already exists in the table.
  def save
    self.exists?
  end
end
