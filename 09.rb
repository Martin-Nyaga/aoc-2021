INPUT = File.read("./09.txt").split("\n").map { |row| row.split("").map(&:to_i) }

class Grid
  attr_reader :grid

  def initialize(grid)
    @grid = grid
  end

  def low_points
    points = []

    grid.each_with_index do |row, y|
      row.each_with_index do |height, x|
        if neighbours(x, y).all? { |neighbour| neighbour > height }
          points.push([x, y])
        end
      end
    end

    points
  end

  def neighbours(x, y)
    neighbour_positions(x, y).map { |(x, y)| grid[y][x] }
  end

  def neighbour_positions(x, y)
    [
      [x - 1, y],
      [x + 1, y],
      [x, y - 1],
      [x, y + 1]
    ].select { |point| valid?(*point) }
  end

  def valid?(x, y)
    x >= 0 && y >= 0 && x < grid[0].length && y < grid.length
  end

  def risk_levels
    low_points.map { |(x, y)| grid[y][x] + 1 }
  end

  def total_risk
    risk_levels.sum
  end

  def include?(arr, point)
    arr.any? { |(bx, by)| bx == point[0] && by == point[1] }
  end

  def find_basin(point)
    basin = []
    wavefront = [point]
    while next_point = wavefront.shift
      basin.push(next_point)

      points_to_check = neighbour_positions(*next_point).reject do |(x, y)|
        grid[y][x] == 9 || include?(basin, [x, y]) || include?(wavefront, [x, y])
      end

      wavefront.concat(points_to_check)
    end

    basin
  end
end

def part_1
  total_risk = Grid.new(INPUT).total_risk
  puts "Part 1: #{total_risk}"
end

def part_2
  grid = Grid.new(INPUT)
  basins = grid.low_points.map { |point| grid.find_basin(point) }
  largest_basin_sizes = basins.sort_by(&:size).reverse.first(3).map(&:size)

  puts "Part 2: #{largest_basin_sizes.reduce(:*)}"
end

part_1
part_2
