require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "WELCOME TO MR.WALTER Barber Shop "			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end
get '/contacts' do
	erb :contacts
end
post '/visit' do
	@user_name = params[:user_name]
	@phone = params[:phone]
	@date_time = params[:date_time]
	@barber_name = params[:barber_name]

	# Check validation
	
	hh_valid = {:user_name  => 'Enter your name',
			:phone => 'Enter your phone',
			:date_time => 'Enter date & time',
			:barber_name => 'choose a barber'
		}

	hh_valid.each do |key,value|
		if (params[key] == '' || params[key]=='underfined')
			@error = hh_valid[key]
			return erb :visit			
		end
	end 	
	
	@title = 'Thank you !'
	@message = "Dear #{@user_name}, we will be waiting for you at #{@date_time},
	your barber is #{@barber_name}"

	f = File.open './public/order.txt','a'
	f.write "User: #{@user_name}, contact: #{@phone}, date and time: #{@date_time} , barber: #{@barber_name}\n" 
	f.close
	
	erb :order_message 

end
