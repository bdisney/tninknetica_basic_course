system "clear"

loop do
  puts "\nВведите коэффициенты a,b,c для решения уравнения вида a*x^2 + b*x + c = 0"
  print 'Введите значение a: '
  a = gets.strip.to_f

  if a == 0 
    abort "Неккоректное условие, значение 'a' не может быть пустым, либо равно 0."
  else
    print 'Введите значение b: '
    b = gets.strip.to_f

    print 'Введите значение с: '
    c = gets.strip.to_f
  end

  discriminant = (b ** 2) - (4 * a * c)
  puts "\nДискриминант: #{discriminant}"

  if discriminant < 0 
    puts 'Корней нет.'
  elsif discriminant == 0
    math_root = -b * 0.5 / a
    puts "Корни равны (x1 и x2): #{math_root}"
  else
    math_root_1 = (-b + Math.sqrt(discriminant)) * 0.5 / a
    math_root_2 = (-b - Math.sqrt(discriminant)) * 0.5 / a
    puts 'Уравнение имеет два корня:'
    puts "\tx1 = #{math_root_1}\t x2 = #{math_root_2}"
  end 

  puts "\n*Для выхода из программы нажмите CTRL+C*"
end