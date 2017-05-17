@cart = {}

def user_input
  print "Введите наименование:\t"
  @product_name = gets.strip.downcase.to_sym

  print "Введите цену за единицу товара:\t"
  @product_price = gets.strip.to_f

  print "Введите кол-во:\t"
  @product_qty = gets.strip.to_f
end

def errors_messages
  puts 'Некорректный ввод, попробуйте изменить условия.'
end

def add_product_to_cart(product_name, product_price, product_qty)
    @cart.include?(product_name) ? @cart[product_name][:qty] += product_qty : @cart[product_name] = { price: product_price, qty: product_qty }
    puts "\nТовар - '#{product_name}' добавлен в корзину."
end

def display_cart
  system "clear"
  total_price = 0

  if @cart.empty?
    puts "Внутри пусто. Совсем."
  else
    puts 'В Вашей корзине:'
      @cart.each_with_index do | (product_name, product_params), index |
        line_item_sum = product_params[:price] * product_params[:qty]
        puts "\t#{index + 1}. #{product_name.capitalize} \t* #{product_params[:qty]}, \t= #{line_item_sum} у.е." 
        total_price += line_item_sum
      end
    puts "\n\tИТОГО: \t#{total_price.round(2)} у.е."
  end
end

system "clear"
puts 'Он-лайн овощебаза приветствует Вас!'

loop do
  print "\nНажмите <Enter> для добавления товара, введите <show> - просмотр корзины, exit - выход: "
  user_choice = gets.strip.downcase

  if user_choice == 'exit'
    break
  elsif user_choice == 'show'
    display_cart
  else
    user_input

    line_item_sum = @product_price * @product_qty
    line_item_sum > 0 ? add_product_to_cart(@product_name, @product_price, @product_qty) : errors_messages
  end
end