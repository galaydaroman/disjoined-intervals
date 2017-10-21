# Disjoined intervals solution

## How to run
```
  irb -r ./solution.rb
```

Example:

```ruby
    timeline = Timeline.new
    timeline.add(3, 10)   # => [[3, 10]]
    timeline.add(1, 5)    # => [[1, 10]]
    timeline.add(15, 20)  # => [[1, 10], [15, 20]]
    timeline.remove(4, 6) # => [[1, 4], [6, 10], [15, 20]]
    timeline.to_a         # convert to the array
```
## Dependencies

- ruby version 2.0.0 and greater (tested on 2.4.2)

## Implementation

Classes:
 - Interval
 - Timeline

Class `Timeline` is the main entry point for solution, it uses dependent class `Interval`.
Basically it is a collection of the `Interval` classes.
Methods:
 * `add(from, to)` - method merge interval to collection, accept one or two arguments (`from`, `to`). In case of one argument passed: `to` will be equals to `from`
 * `remove(from, to)` - method will extract interval from collection. (you can pass one argument `from` in the same way as `add` method)
 * `to_a` - method converts collection into plain array
 * `clone` - method make a copy of collection

Class `Interval` accept to params `from` and `to`. It has methods:
 * `<=>` intervals comparsion method, see details in method's definition
 * `add(interval)` merge with another interval (it will create new `Interval` instance)
 * `add!(interval)` merge with another interval, result will be the same interval instance
 * `subtract(interval)` result is an array with interval(s) or empty array (always return new instances of intervals)
 * `to_a` converts interval to array, e.g. `[from, to]`
 * `intersect_with?(interval)` determine possible intersection between other interval object (boolean result)
