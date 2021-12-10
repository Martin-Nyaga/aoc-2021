INPUT = File.read("./10.txt").split("\n").map { |line| line.split("") }

SCORES = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137
}

PAIRS = {
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">"
}

INVERSE_PAIRS = PAIRS.invert

def part_1
  score = 0

  INPUT.each do |line|
    stack = []

    line.each do |c|
      if PAIRS[c]
        stack.push(c)
      elsif INVERSE_PAIRS[c] == stack.last
        stack.pop
      else
        # invalid character
        score += SCORES[c]
        break
      end
    end
  end

  puts "Part 1: #{score}"
end

PART_2_SCORES = {
  ")" => 1,
  "]" => 2,
  "}" => 3,
  ">" => 4
}

def part_2
  line_scores = INPUT.map do |line|
    stack = []
    corrupted = false

    line.each do |c|
      if PAIRS[c]
        stack.push(c)
      elsif INVERSE_PAIRS[c] == stack.last
        stack.pop
      else
        # invalid character
        corrupted = true
        break
      end
    end

    if !corrupted && stack.any?
      closing_stream = stack.reverse.map { |c| PAIRS[c] }
      score = closing_stream.reduce(0) { |score, c| score * 5 + PART_2_SCORES[c] }
      [false, score]
    else
      [true, 0]
    end
  end

  line_scores = line_scores.filter_map { |corrupted, score| !corrupted && score }
  score = line_scores.sort[(line_scores.length / 2.0).ceil - 1]

  puts "Part 2: #{score}"
end

part_1
part_2
