class Interval
  attr_reader :from, :to

  def initialize(from, to)
    @from = from
    @to = to

    validate!
  end

  def <=>(other)
    case
    # +--+
    #       +--+
    when self.to < other.from
      -3

    #     +--+
    #       +--+
    when self.from < other.from && other.from <= self.to && self.to <= other.to
      -2

    #     +------+
    #       +--+
    when self.from < other.from && self.to > other.to
      -1

    #       +--+
    #       +--+
    when self.from == other.from && self.to == other.to
      0

    #        ++
    #       +--+
    when self.from >= other.from && self.to <= other.to
      1

    #         +--+
    #       +--+
    when other.from <= self.from && self.from <= other.to && self.to > other.to
      2

    #             +--+
    #       +--+
    when self.from > other.to
      3
    end
  end

  def add(other)
    raise 'Cannot add intervals without intersection' unless intersect_with?(other)

    self.class.new(
      [self.from, other.from].min,
      [self.to, other.to].max
    )
  end

  def add!(other)
    merged = add(other)
    @from = merged.from
    @to = merged.to
    self
  end

  def subtract(other)
    case self <=> other
    when -2
      [self.class.new(self.from, other.from)]
    when -1
      [
        self.class.new(self.from, other.from),
        self.class.new(other.to, self.to)
      ]
    when 0, 1
      []
    when 2
      [self.class.new(other.to, self.to)]
    when -3, 3
      [clone]
    end
  end

  def to_a
    [from, to]
  end
  alias_method :inspect, :to_a

  def intersect_with?(other)
    (self <=> other).abs < 3
  end

  private

  def validate!
    raise 'Not valid interval [%s-%s]' % [from, to] if to <= from
  end
end
