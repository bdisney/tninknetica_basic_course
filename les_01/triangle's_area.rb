print "Enter triangle's base value: "
triangle_base = gets.to_f

print "Enter triangle's height: "
triangle_height = gets.to_f

if triangle_base > 0 && triangle_height > 0
  triangle_area = 0.5 * triangle_base * triangle_height
  puts "\nTriangle's area = #{triangle_area}"
else
  puts "\nIncorrect input! Triangle's base value should be positive number." if triangle_base <= 0
  puts "\nIncorrect input! Triangle's height value should be positive number." if triangle_height <= 0
end


