INPUT = File.read("./08.txt").split("\n").map { |row| row.split("|").map { |part| part.split(" ").map { |s| s.split("").sort.join } } }

VALUE_TO_DIGIT = {
  0 => 'abcefg',
  1 => 'cf',
  2 => 'acdeg',
  3 => 'acdfg',
  4 => 'bcdf',
  5 => 'abdfg',
  6 => 'abdefg',
  7 => 'acf',
  8 => 'abcdefg',
  9 => 'abcdfg'
}
DIGIT_TO_VALUE = VALUE_TO_DIGIT.invert

DIGIT_LENGTH_TO_DIGITS = VALUE_TO_DIGIT.reduce({}) do |h, (value, digit)|
  h[digit.length] ||= []
  h[digit.length].push(value)
  h
end

def part_1
  total_count = INPUT.reduce(0) do |sum, (digits, outputs)|
    sum + outputs.count { |digit| DIGIT_LENGTH_TO_DIGITS[digit.length].length == 1 }
  end
  puts "Part 1: #{total_count}"
end

def convert_digit_using_mapping(digit, mapping)
  digit.split("").map { |letter| mapping[letter][0] }.sort.join
end

def find_digit_mappings(digits_to_check, possible_mappings, all_digits)
  # base case
  if possible_mappings.all? { |(_, letters)| letters.length == 1 }
    if possible_mappings.values.map(&:first).uniq.length == 7 &&
       all_digits.all? { |digit| DIGIT_TO_VALUE[convert_digit_using_mapping(digit, possible_mappings)] }
       return possible_mappings
    else
      return false
    end
  end

  # Look for "easy" cases
  if digit_index = digits_to_check.find_index { |digit| DIGIT_LENGTH_TO_DIGITS[digit.length].size == 1 }
    digit = digits_to_check[digit_index]
    canonical_digit = VALUE_TO_DIGIT[DIGIT_LENGTH_TO_DIGITS[digit.length][0]]
    digit.split("").each do |letter|
      possible_mappings[letter].reject! { |alt| !canonical_digit.include?(alt) }
    end

    digits_to_check.delete_at(digit_index)
    return find_digit_mappings(digits_to_check, possible_mappings, all_digits)
  end

  # Explore remaining cases by checking what alternative mapping of the letter
  # with the current smallest number of alternatives leads to a valid result
  test_letter = possible_mappings.min_by { |(letter, alts)| alts.length == 1 ? Float::INFINITY : alts.length }[0]
  possible_mappings[test_letter].each do |alt|
    test_mapping = possible_mappings.dup.map do |(letter, alts)|
      if letter == test_letter
        [letter, [alt]]
      else
        [letter, alts.reject { |other_alt| other_alt == alt }]
      end
    end.to_h

    if final_mapping = find_digit_mappings(digits_to_check, test_mapping, all_digits)
      return final_mapping
    end
  end

  return false
end

def part_2
  values = INPUT.map do |(digits, outputs)|
    possible_mappings = ('a'..'g').map { |letter| [letter, ('a'..'g').to_a] }.to_h
    digit_mapping = find_digit_mappings(digits, possible_mappings, digits)
    outputs.reverse.map.with_index.reduce(0) do |sum, (output, index)|
      digit = convert_digit_using_mapping(output, digit_mapping)
      value = DIGIT_TO_VALUE[digit]
      sum + value * (10 ** index)
    end
  end
  puts "Part 2: #{values.sum}"
end

part_1
part_2
