INPUT = File.read("./13.txt").split("\n\n")

def read_points
  INPUT[0].split("\n").map { |line| line.split(",").map(&:to_i) }
end

def read_folds
  INPUT[1].split("\n").map do |line|
    line = line.sub(/fold along /, "").split("=")
    line[1] = line[1].to_i
    line
  end
end

class Paper
  attr_reader :points
  def initialize(points)
    @points = points.reduce({}) do |h, point|
      h[point] = true
      h
    end
  end

  def bottom_right_corner
    corner = [0, 0]

    points.keys.each do |x, y|
      corner[0] = x if x > corner[0]
      corner[1] = y if y > corner[1]
    end

    corner
  end

  def fold(along)
    axis, value = along
    next_points = {}

    points.each do |((x, y), _)|
      if axis == "x" && x > value
        new_x = value - (x - value)
        next_points[[new_x, y]] = true
      elsif axis == "y" && y > value
        new_y = value - (y - value)
        next_points[[x, new_y]] = true
      else
        next_points[[x, y]] = true
      end
    end

    @points = next_points
  end

  def to_grid
    x, y = bottom_right_corner
    answer_grid = Array.new(y + 1) { Array.new(x + 1) { " " } }

    points.keys.each do |point|
      answer_grid[point[1]][point[0]] = "#"
    end

    answer_grid
  end

  def draw
    to_grid.each do |row|
      row.each do |value|
        print(value)
      end

      puts
    end
  end
end

def part_1
  paper = Paper.new(read_points)
  folds = read_folds
  first_fold = folds.first
  paper.fold(first_fold)
  puts "Part 1: #{paper.points.keys.count}"
end

def part_2
  paper = Paper.new(read_points)
  folds = read_folds

  folds.each do |fold_line|
    paper.fold(fold_line)
  end

  puts
  puts "Part 2:"
  paper.draw
end

part_1
part_2
