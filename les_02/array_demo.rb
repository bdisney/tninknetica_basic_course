arr = [10]
step = 5

until arr.last == 100 do
  arr = arr << arr.last + step
end

puts arr.inspect