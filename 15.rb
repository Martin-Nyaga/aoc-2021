INPUT = File.read("15.txt").split("\n").map { |row| row.split("").map(&:to_i) }

class PriorityQueue
  include Enumerable

  def initialize
    @map = Hash.new([])
    @arr = []
  end

  def push(priority, value)
    if map[priority].size == 0
      map[priority] = [value]
      arr.push(priority)
      arr.sort!
    else
      map[priority] << value
    end
  end

  def remove(priority, value)
    map[priority].delete_if { |x| x.equal?(value) }

    if map[priority].size == 0
      map.delete(priority)
      arr.delete_if { |x| x == priority }
    end
  end

  def pop
    return nil if empty?
    priority = arr[0]
    result = map[priority].shift

    if map[priority].size == 0
      map.delete(priority)
      arr.shift
    end

    result
  end

  def empty?
    arr.size == 0
  end

  def each
    arr.each do |priority|
      map[priority].each do |x|
        yield(x)
      end
    end
  end

  private

  attr_reader :arr, :map
end

class GridCalculator
  attr_reader :tile
  def initialize(tile)
    @tile = tile
  end

  def grid
    final = Array.new(tile.size * 5) { Array.new(tile[0].size * 5) }

    (0..4).each do |j|
      (0..4).each do |i|
        increment_grid(tile, i + j).each_with_index do |row, y|
          row.each_with_index do |value, x|
            y_index = y + j * tile.size
            x_index = x + i * tile[0].size
            final[y_index][x_index] = value
          end
        end
      end
    end

    final
  end

  def increment_grid(grid, inc)
    grid.map do |row|
      row.map do |value|
        sum = value + inc
        sum > 9 ? sum % 9 : sum
      end
    end
  end
end

class Point
  include Comparable
  attr_reader :x, :y, :risk, :map
  def initialize(x, y, risk, map)
    @x, @y, @risk, @map = x, y, risk, map
  end

  def <=>(other)
    rank <=> other.rank
  end

  def rank
    map.risk_levels[self] + map.destination.x - x + map.destination.y - y
  end

  def coords
    [x, y]
  end

  def inspect
    coords.inspect
  end
end

class Map
  attr_reader :grid, :risk_levels, :unvisited, :visit_queue

  def initialize(grid)
    @grid = grid.each_with_index.map do |row, y|
      row.each_with_index.map do |risk, x|
        Point.new(x, y, risk, self)
      end
    end
  end

  def minimum_risk_to_destination
    @risk_levels = grid_reduce({}) { |h, point| h[point] = Float::INFINITY }
    @risk_levels[grid[0][0]] = 0
    @unvisited = grid_reduce({}) { |h, point| h[point] = true }
    @visit_queue = grid_reduce(PriorityQueue.new) { |q, point| q.push(point.rank, point) }

    loop do
      current = visit_queue.pop
      next unless unvisited[current]

      if current.nil? || destination?(current)
        break
      else
        unvisited.delete(current)
      end

      neighbours(current).select { |point| unvisited[point] }.each do |point|
        new_risk_level = point.risk + @risk_levels[current]
        @risk_levels[point] = new_risk_level if new_risk_level < risk_levels[point]
        visit_queue.push(point.rank, point)
      end
    end

    risk_levels[destination]
  end

  def grid_reduce(initial_value)
    grid.each_with_index.reduce(initial_value) do |h, (row, y)|
      row.each_with_index do |value, x|
        yield(h, value)
      end

      h
    end
  end

  def neighbours(p)
    x, y = p.coords
    [
      [x + 1, y],
      [x - 1, y],
      [x, y + 1],
      [x, y - 1]
    ].select { |p| valid?(*p) }.map { |x, y| grid[y][x] }
  end

  def valid?(x, y)
    x >= 0 && y >= 0 && x < grid[0].size && y < grid.size
  end

  def destination?(point)
    point.eql?(destination)
  end

  def destination
    @destination ||= grid[grid.size - 1][grid[0].size - 1]
  end
end

def part_1
  map = Map.new(INPUT)
  puts "Part 1: #{map.minimum_risk_to_destination}"
end

def part_2
  grid = GridCalculator.new(INPUT).grid
  map = Map.new(grid)
  puts "Part 2: #{map.minimum_risk_to_destination}"
end

part_1
part_2
