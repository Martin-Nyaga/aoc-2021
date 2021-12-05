INPUT = File.read("./05.txt")

Point = Struct.new(:x, :y)
class Line
  attr_reader :a, :b

  def initialize(a, b)
    @a, @b = a, b
  end

  def self.from(row)
    new(*row.split("->").map { |point| Point.new(*point.strip.split(",").map(&:to_i)) })
  end

  def points
    if horizontal? || vertical?
      as_range(a.x, b.x).flat_map do |x|
        as_range(a.y, b.y).map do |y|
          Point.new(x, y)
        end
      end
    else
      as_range(a.x, b.x).zip(as_range(a.y, b.y)).map do |x, y|
        Point.new(x, y)
      end
    end
  end

  def horizontal?
    a.x == b.x
  end

  def vertical?
    a.y == b.y
  end

  private
  def as_range(*p)
    p[0] <= p[1] ? p[0]..p[1] : p[0].downto(p[1])
  end
end

def part_1
  lines = INPUT.split("\n").map { |row| Line.from(row) }
  lines = lines.select { |l| l.horizontal? || l.vertical? }
  points = lines.lazy.flat_map(&:points)

  h = {}
  dangerous_points = 0
  points.each do |p|
    h[p.x] ||= {}
    h[p.x][p.y] ||= 0
    if h[p.x][p.y] == 1
      dangerous_points += 1
    end
    h[p.x][p.y] += 1
  end

  puts "Lines: #{lines.count}"
  puts "Expanded points: #{points.count}"
  puts "Part 1: #{dangerous_points}"
end

def part_2
  lines = INPUT.split("\n").map { |row| Line.from(row) }
  points = lines.lazy.flat_map(&:points)

  h = {}
  dangerous_points = 0
  points.each do |p|
    h[p.x] ||= {}
    h[p.x][p.y] ||= 0
    if h[p.x][p.y] == 1
      dangerous_points += 1
    end
    h[p.x][p.y] += 1
  end

  puts "Lines: #{lines.count}"
  puts "Expanded points: #{points.count}"
  puts "Part 2: #{dangerous_points}"
end

part_1
puts
part_2
