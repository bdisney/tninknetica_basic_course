sides_values = []

while sides_values.length != 3
  print "Введите значение #{sides_values.length + 1} стороны: "
  user_input = gets.to_f

  if user_input > 0
    sides_values << user_input
  else 
    puts 'Вводимое значение не может быть меньше или равно 0. Повторите ввод!'
  end
end

sides_values.sort!

longest_side = sides_values[2]

perimeter = sides_values.reduce(:+)

if perimeter - longest_side <= longest_side 
  abort 'Треугольник с такими парамерами не может существовать!'
end

puts "\nДелаем серьезные расчеты..."
sleep 1

if sides_values.uniq.length == 1
  puts "\n*Треугольник равносторонний!*"  
else
  puts 'Треугольник равнобедренный!' if sides_values.uniq.length == 2
  puts 'Треугольник прямоугольный!' if longest_side ** 2 == (sides_values[0] ** 2 + sides_values[1] ** 2) 
  puts 'В треугольнике с заявленными сторонами ничего необычного.' if sides_values.uniq.length > 2
end

