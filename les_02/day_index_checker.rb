loop do
  months_duration = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  def leap_year?(year)
    ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)
  end

  def error_message
    puts 'Некорректный ввод. Проверьте правильность вводимых Вами данных.'
  end

  user_input = nil

  while user_input == nil do
    system "clear"
    puts 'Введите дату в формате дд/мм/гггг.'

    print "Введите число:\t"
    user_input = gets.strip.to_i
    if user_input < 1 || user_input > 31
      error_message
      break
    else
      day = user_input
    end
   
    print "Введите месяц:\t"
    user_input = gets.strip.to_i
    if user_input < 1 || user_input > 12
      error_message
      break
    else
      month = user_input
    end

    print "Введите год:\t"
    user_input = gets.strip.to_i
    if user_input < 0 
      error_message
      break
    else
      year = user_input
    end

    puts '-' * 25

    month_days_qty = ( leap_year?(year) && month == 2 ) ? 29 : months_duration[month - 1]

    if day > month_days_qty
      puts "В указанном месяце не может быть #{day} (день/дней), в нем может быть тоько #{month_days_qty} (день/дней)." 
      break
    else
      if leap_year?(year) && month == 2
        error_message if day >= 30
      else
        date_duration = months_duration.take(month - 1).reduce(:+) + day 
      end

      date_duration = months_duration.take(month - 1).reduce(:+) + day 

      if leap_year?(year) && month > 2
        date_duration += 1
      end 

      puts "Указанный Вами день #{date_duration} по счету с начала года."
    end
  end

  puts '***Press Enter to continue. Type exit if you want to stop.***'
  user_input = gets.strip.downcase

  if user_input == 'exit'
    break
  end
end