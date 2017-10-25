require 'forwardable'

class Timeline
  extend Forwardable

  def_delegators :@intervals, :[], :size, :length, :each, :map, :empty?

  def initialize
    @intervals = []
  end

  def add(from, to)
    add_interval Interval.new(from, to)
    self
  end

  def remove(from, to)
    remove_interval Interval.new(from, to)
    self
  end

  def to_a
    map(&:to_a)
  end
  alias_method :inspect, :to_a

  def clone
    super.tap do |obj|
      obj.instance_variable_set :@intervals, @intervals.clone
    end
  end

  private

  def remove_interval(interval)
    return if @intervals.empty?

    @intervals = @intervals.reduce([]) do |result, item|
      result + item.subtract(interval)
    end
  end

  def add_interval(interval)
    @intervals.push(interval).sort!
    return if size < 2

    first, *rest = @intervals
    @intervals = [first]

    rest.each do |item|
      if @intervals.last.intersect_with?(item)
        @intervals.last.add!(item)
      else
        @intervals << item
      end
    end
  end
end
