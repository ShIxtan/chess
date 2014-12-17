class Employee
  attr_reader :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name, @title, @salary, @boss = name, title, salary, boss
  end

  def bonus(multiplier)
    salary * multiplier
  end

  def salaries
    0
  end
end

class Manager < Employee
  def initialize(*args, employees)
    super(*args)
    @employees = employees
  end

  def bonus(multiplier)
    salaries * multiplier
  end

  def salaries
    @employees.inject(0) { |sum, employee| sum + employee.salaries + employee.salary}
  end
end
