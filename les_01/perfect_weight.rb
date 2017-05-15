print 'Enter your name: '
name = gets.strip.downcase.capitalize!

print 'Enter your height: '
height = gets.to_i

perfect_weight = height - 110

puts "#{name}, your perfect weight is #{perfect_weight} kg." if perfect_weight >= 0
puts "#{name}, your weight is optimal." if perfect_weight < 0 