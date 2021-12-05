input = File.read("./02.txt").split("\n")

# part 1
final_coordinates = input.reduce([0, 0]) do |(x, y, aim), command|
  command, amount = command.split(" ")
  amount = amount.to_i

  case command
  when "up"
    y -= amount
  when "down"
    y += amount
  when "forward"
    x += amount
  end

  [x, y]
end

pp final_coordinates
pp final_coordinates.reduce(:*)

# part 2
final_coordinates = input.reduce([0, 0, 0]) do |(x, y, aim), command|
  command, amount = command.split(" ")
  amount = amount.to_i

  case command
  when "up"
    aim -= amount
  when "down"
    aim += amount
  when "forward"
    x += amount
    y += aim * amount
  end

  [x, y, aim]
end
pp final_coordinates
pp final_coordinates[0] * final_coordinates[1]
