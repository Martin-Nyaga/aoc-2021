INPUT = File.read("./06.txt").strip.split(",").map(&:to_i)

$fish_id = 0
Fish = Struct.new(:id, :parent_id, :days_to_reproduction, :day) do
  def reproduce
    self.day += self.days_to_reproduction
    self.days_to_reproduction = 7
    Fish.new($fish_id += 1, self.id, 8, self.day + 1)
  end
end

TARGET_DAY = 256
REPRODUCTION_CYCLE = 7
def part_1
  total_fish = 0
  steps = 0
  queue = Queue.new

  INPUT.each do |days_to_reproduction|
    queue << Fish.new($fish_id += 1, 0, days_to_reproduction, 0)
  end

  while !queue.empty?
    fish = queue.pop
    total_fish += 1 unless fish.day > TARGET_DAY

    while (TARGET_DAY - fish.day) >= REPRODUCTION_CYCLE
      steps += 1
      # One or more reproduction cycles left
      queue << fish.reproduce
    end
  end

  puts "Steps: #{steps}"
  puts "Part 1: #{total_fish}"
end

def part_2
  first_gen = INPUT.reduce(Hash.new(0)) do |hash, timer|
    hash[timer] += 1
    hash
  end

  gen = first_gen
  TARGET_DAY.times do
    next_gen = Hash.new(0)
    gen.each do |k, v|
      if k == 0
        next_gen[8] += v
        next_gen[6] += v
      else
        next_gen[k-1] += v
      end
    end
    gen = next_gen
  end
  total_fish = gen.reduce(0) { |sum, (k, v)| sum + v }
  puts "Part 2: #{total_fish}"
end

part_2
