input = File.read("./03.txt").split("\n")
count = input.length
bits = input[0].length

def invert_bit(bit)
  (~(bit.to_i))[0].to_s
end

# Part 1
#
# gamma rate -> most common bit in each position (in decimal)
# epsilon rate -> least common bit in each position (in decimal) i.e. !gamma
# gamma * epsilon

puts "Part 1"
bitwise_sums = input.reduce(Array.new(bits) { 0 }) do |sums, str|
  str.split("").map(&:to_i).zip(sums).map { |pair| pair.reduce(:+) }
end

gamma_bits = bitwise_sums.map { |n| (n.to_f / count).round.to_i }
gamma = gamma_bits.map(&:to_s).join
epsilon = gamma_bits.map { |n| (~n)[0] }.map(&:to_s).join

pp gamma
pp gamma = gamma.to_i(2)
pp epsilon
pp epsilon = epsilon.to_i(2)
pp epsilon * gamma

# Part 2
#
# o2 generator rating => Keep numbers with most common bit in each position
# co2 scrubber rating => Keep numbers with least common bit in each position
# o2 * co2

puts "Part 2"
def find_most_common_bit_at_position(values, position)
  position_sum = values.sum { |str| str[position].to_f }
  (position_sum / values.count).round.to_i.to_s
end

o2_rating_options = input
n = 0
while n < bits && o2_rating_options.length > 1
  most_common_bit = find_most_common_bit_at_position(o2_rating_options, n)
  o2_rating_options = o2_rating_options.select { |str| str[n] == most_common_bit }
  n += 1
end
o2_rating = o2_rating_options[0]
pp o2_rating

co2_rating_options = input
n = 0
while n < bits && co2_rating_options.length > 1
  least_common_bit = invert_bit(find_most_common_bit_at_position(co2_rating_options, n))
  co2_rating_options = co2_rating_options.select { |str| str[n] == least_common_bit }
  n += 1
end
co2_rating = co2_rating_options[0]
pp co2_rating

pp o2_rating.to_i(2) * co2_rating.to_i(2)
