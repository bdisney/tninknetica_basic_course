calendar ={
  'January' => 31,
  'February' => 28,
  'March' => 31,
  'April' => 30,
  'May' => 31,
  'June' => 30,
  'July' => 31,
  'August' => 31,
  'September' => 30,
  'October' => 31,
  'November' => 30,
  'December' => 31
}

puts 'Месяцы продолжительностью 30 дней: '

calendar.each_with_index do |(key, value), index|
  puts "\t #{index+1}. #{key}" if value == 30  
end
