class Grid
  attr_reader :grid,
              :flashed,
              :flash_queue,
              :affected_queue,
              :total_flash_count,
              :current_step_flash_count

  def initialize(grid)
    @grid = grid
    @flashed = []
    @flash_queue = []
    @affected_queue = []
    @total_flash_count = 0
    @current_step_flash_count = 0
  end

  def step
    @flashed = []
    @flash_queue = []
    @affected_queue = []
    @current_step_flash_count = 0

    grid.each_with_index do |row, y|
      row.each_with_index do |value, x|
        grid[y][x] += 1
      end
    end

    flash
  end

  def all_flashed?
    current_step_flash_count == (grid[0].size * grid.size)
  end

  def flash
    grid.each_with_index do |row, y|
      row.each_with_index do |value, x|
        flash_queue << [x, y] if value > 9
      end
    end

    while flash_point = flash_queue.shift
      next if include?(flashed, flash_point)
      # Flash the point
      flashed << flash_point
      @total_flash_count += 1
      @current_step_flash_count += 1
      x, y = flash_point
      grid[y][x] = 0

      # Affect the neighbours
      affected_queue.concat(neighbours(*flash_point))

      # Deal with affected neighbours
      while affected_point = affected_queue.shift
        next if include?(flashed, affected_point)
        x, y = affected_point
        grid[y][x] += 1

        if grid[y][x] > 9
          flash_queue << affected_point
        end
      end
    end
  end

  def neighbours(x, y)
    [
      [x + 1, y],
      [x - 1, y],
      [x, y + 1],
      [x, y - 1],
      [x - 1, y - 1],
      [x + 1, y + 1],
      [x + 1, y - 1],
      [x - 1, y + 1]
    ].filter { |p| valid?(*p) }
  end

  def valid?(x, y)
    x >= 0 && y >= 0 && x < grid[0].size && y < grid.size
  end

  def include?(arr, point)
    arr.any? { |(x, y)| x == point[0] && y == point[1] }
  end
end

def part_1
  input = File.read("./11.txt").split("\n").map { |row| row.split("").map(&:to_i) }
  grid = Grid.new(input)
  100.times { grid.step }
  puts "Part 1: #{grid.total_flash_count}"
end

def part_2
  input = File.read("./11.txt").split("\n").map { |row| row.split("").map(&:to_i) }
  grid = Grid.new(input)

  step = (1..).detect do
    grid.step
    grid.all_flashed?
  end

  puts "Part 2: #{step}"
end

part_1
part_2
