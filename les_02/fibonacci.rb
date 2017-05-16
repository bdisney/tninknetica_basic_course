arr = [0]
number = 1

until number > 100 do
  arr << number
  number = arr.last(2).reduce(:+)
end

puts arr.inspect