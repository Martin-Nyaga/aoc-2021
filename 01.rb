input = File.read("./01.txt").split("\n").map(&:to_i)

# Part 1
times_increased = input.each_cons(2).map { |(a, b)| b > a ? 1 : 0 }.sum
pp times_increased

# Part 2
times_increased = input
  .each_cons(3)
  .map(&:sum)
  .each_cons(2)
  .map{ |(a, b)| b > a ? 1 : 0 }
  .sum
pp times_increased
