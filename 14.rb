INPUT = File.read("./14.txt").split("\n\n")
TEMPLATE = INPUT[0]
RULES = INPUT[1].split("\n").map { |rule| rule.split("->").map(&:strip) }.to_h

class Polymer
  attr_reader :pair_counts, :element_counts, :rules

  def initialize(template, rules)
    @rules = rules

    @pair_counts = template.split("")
      .each_cons(2)
      .map(&:join)
      .reduce(Hash.new(0)) do |h, pair|
        h[pair] += 1
        h
      end

    @element_counts = template.split("").reduce(Hash.new(0)) do |h, el|
      h[el] += 1
      h
    end
  end

  def step
    next_pair_counts = Hash.new(0)

    pair_counts.each do |k, v|
      element_to_insert = rules[k]
      pair_1 = k[0] + element_to_insert
      pair_2 = element_to_insert + k[1]
      next_pair_counts[pair_1] += v
      next_pair_counts[pair_2] += v
      element_counts[element_to_insert] += v
    end

    @pair_counts = next_pair_counts
  end

  def length
    element_counts.reduce(0) { |sum, (k, v)| sum + v }
  end

  def score
    sorted_counts = element_counts.to_a.sort_by(&:last)
    least_common = sorted_counts[0]
    most_common = sorted_counts.last
    most_common[1] - least_common[1]
  end
end

def part_1
  polymer = Polymer.new(TEMPLATE, RULES)

  10.times do
    polymer.step
  end

  puts "Part 1"
  puts "Length: #{polymer.length}"
  puts "Score: #{polymer.score}"
end

def part_2
  polymer = Polymer.new(TEMPLATE, RULES)

  40.times do
    polymer.step
  end

  puts "Part 2"
  puts "Length: #{polymer.length}"
  puts "Score: #{polymer.score}"
end

part_1
part_2
