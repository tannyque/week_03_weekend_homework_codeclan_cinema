require_relative( '../db/sql_runner' )

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING ID"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first()
    @id = customer['id'].to_i()
  end

  def self.all()
    sql = "SELECT * FROM customers"
    customers_array = SqlRunner.run(sql)
    result = customers_array.map { |customer| Customer.new(customer) }
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

end
