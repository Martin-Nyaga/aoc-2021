INPUT = File.read("./04.txt")

class Board
  attr_reader :numbers, :marked

  def initialize(numbers)
    @numbers = numbers
    @marked = Array.new(numbers.size) { Array.new(numbers[0].size) { false } }
  end

  def self.from_square(square)
    new(square.strip.split(/\s+/).map(&:to_i).each_slice(5).to_a)
  end

  def mark(number)
    numbers.each_with_index do |row, y|
      row.each_with_index do |value, x|
        marked[y][x] = true if value == number
      end
    end
  end

  def won?
    marked.any? { |row| row.all?(&:itself) } ||
    marked.transpose.any? { |column| column.all?(&:itself) }
  end

  def score(last_call)
    sum = 0
    marked.each_with_index do |row, y|
      row.each_with_index do |value, x|
        sum += numbers[y][x] if value == false
      end
    end
    sum * last_call
  end
end

def part_1
  calls = INPUT.split("\n")[0].split(",").map(&:to_i)
  boards = INPUT.partition("\n")[2].strip.split("\n\n")
    .map { |square| Board.from_square(square) }

  winning_score = calls.lazy.map do |call|
    boards.each { |board| board.mark(call) }
    if winner = boards.detect(&:won?)
      winner.score(call)
    else
      nil
    end
  end.find(&:itself)

  puts "Part 1: #{winning_score}"
end

def part_2
  calls = INPUT.split("\n")[0].split(",").map(&:to_i)
  boards = INPUT.partition("\n")[2].strip.split("\n\n")
    .map { |square| Board.from_square(square) }

  last_call = nil
  losing_score = calls.lazy.map do |call|
    if boards.length == 1
      boards[0].mark(call)
      if boards[0].won?
        boards[0].score(call)
      else
        last_call = call
        nil
      end
    else
      boards.each { |board| board.mark(call) }
      boards.reject!(&:won?)
      last_call = call
      nil
    end
  end.find(&:itself)

  puts "Part 2: #{losing_score}"
end

part_1
part_2
