INPUT = File.read("./07.txt").split(",").map(&:to_i).sort

def part_1
  range = INPUT.min..INPUT.max
  crab_count_by_position = INPUT.reduce(Hash.new(0)) do |count_by_pos, pos|
    count_by_pos[pos] += 1
    count_by_pos
  end
  position_counts = range.map do |position|
    first_index_past_position = INPUT.bsearch_index { |crab_position| crab_position > position }
    crabs_after = first_index_past_position.nil? ? 0 : INPUT.count - first_index_past_position
    crabs_at = crab_count_by_position[position]
    # pos, crabs before, crabs after
    [position, INPUT.length - crabs_after - crabs_at, crabs_at, crabs_after]
  end
  # pp INPUT.count
  # pp position_counts

  # cost of moving all crabs from the left to pos
  move_from_left_costs = position_counts.each_with_index
    .reduce([]) do |result, ((position, crabs_before, crabs_at, crabs_after), index)|
      # pos, cost
      result.push([position, (index.zero? ? 0 : result[index - 1][1]) + crabs_before])
      result
    end
  # pp move_from_left_costs
  move_from_right_costs = position_counts.reverse.each_with_index
    .reduce([]) do |result, ((position, crabs_before, crabs_at, crabs_after), index)|
      # pos, cost
      result.push([position, (index.zero? ? 0 : result[index - 1][1]) + crabs_after])
      result
    end.reverse
  # pp move_from_right_costs
  total_costs =
    move_from_left_costs.zip(move_from_right_costs).map do |((pos, left_cost), (_, right_cost))|
      [pos, left_cost + right_cost]
    end
  # pp total_costs
  optimal_pos, cost = total_costs.min_by { |(pos, cost)| cost }
  puts "Part 1"
  puts "Optimal position: #{optimal_pos}"
  puts "Cost: #{cost}"
end

def sum_to(n)
  n * (n + 1) / 2
end

def part_2
  range = INPUT.min..INPUT.max
  costs_to_move = range.map do |pos|
    total_cost = INPUT.reduce(0) do |cost, crab_pos|
      cost + sum_to((crab_pos - pos).abs)
    end
    [pos, total_cost]
  end
  optimal_pos, cost = costs_to_move.min_by { |(pos, cost)| cost }
  puts "Part 2"
  puts "Optimal position: #{optimal_pos}"
  puts "Cost: #{cost}"
end

part_1
part_2
