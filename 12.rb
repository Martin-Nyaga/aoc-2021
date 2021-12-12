INPUT = File.readlines("./12.txt").map { |line| line.strip.split("-") }

def start?(cave)
  cave == "start"
end

def end?(cave)
  cave == "end"
end

def large?(cave)
  !start?(cave) && !end?(cave) && cave.upcase == cave
end

def small?(cave)
  !start?(cave) && !end?(cave) && cave.downcase == cave
end

class Path
  attr_accessor :path, :visits, :visited_small_cave_twice

  def initialize(_path = [], _visits = Hash.new(0), _visited_small_cave_twice = false)
    @path = _path
    @visits = _visits
    @visited_small_cave_twice = _visited_small_cave_twice
  end

  def add(cave)
    @path.push(cave)
    @visits[cave] += 1

    if small?(cave) && visits[cave] > 1
      @visited_small_cave_twice = true
    end
  end

  def visited?(cave)
    visits[cave] > 0
  end

  def visited_small_cave_twice?
    visited_small_cave_twice
  end

  def deep_clone
    Path.new(
      path.clone,
      visits.clone,
      visited_small_cave_twice
    )
  end

  def to_a
    path
  end

  def to_s
    to_a.join("->")
  end
end

class Graph
  attr_reader :graph

  def initialize(edges)
    @graph = edges.reduce({}) do |g, edge|
      g[edge[0]] ||= []
      g[edge[0]] << edge[1]
      g[edge[1]] ||= []
      g[edge[1]] << edge[0]
      g
    end
  end

  def find_paths(current_path = Path.new, cave = "start")
    current_path.add(cave)
    return [current_path] if end?(cave)

    paths = []

    graph[cave].each do |next_cave|
      next if start?(next_cave) || (small?(next_cave) && current_path.visited?(next_cave))
      paths.concat(find_paths(current_path.deep_clone, next_cave))
    end

    paths
  end

  def find_paths_with_double_visits_allowed(current_path = Path.new, cave = "start")
    current_path.add(cave)
    return [current_path] if end?(cave)

    paths = []

    graph[cave].each do |next_cave|
      next if start?(next_cave) || (small?(next_cave) && current_path.visited?(next_cave) && current_path.visited_small_cave_twice?)
      paths.concat(find_paths_with_double_visits_allowed(current_path.deep_clone, next_cave))
    end

    paths
  end
end

def part_1
  graph = Graph.new(INPUT)
  paths = graph.find_paths.map(&:to_a)
  puts "Part 1: #{paths.count}"
end

def part_2
  graph = Graph.new(INPUT)
  paths = graph.find_paths_with_double_visits_allowed.map(&:to_a)
  puts "Part 2: #{paths.count}"
end

part_1
part_2
