require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

def is_barber_exist? db,name
	db.execute('select * from Barbers where name = ?', [name]).length > 0
end

def seed_db db,barbers

	barbers.each do |barber|
		if !is_barber_exist? db,barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end
end

before do
	db = get_db
	@barbers = db.execute 'select * from Barbers'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS 
	"Users" 
	(
		"id"  INTEGER PRIMARY KEY AUTOINCREMENT,
		"user" VARCHAR (128) NOT NULL, 
		"phone"  VARCHAR (45)  NOT NULL,
		"barber" VARCHAR (45)  NOT NULL, 
		"date" VARCHAR (45)  NOT NULL, 
		"time"   VARCHAR (45)  NOT NULL
	)'

	db.execute 'CREATE TABLE IF NOT EXISTS 
	"Barbers" 
	(
		"id"  INTEGER PRIMARY KEY AUTOINCREMENT,
		"name" VARCHAR (128) 
	)'

	seed_db db,['Snoop Dog','Gerard Butler','Frank Sinatra','Charli Chaplin','Bruce Willis']
end

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
get '/orders' do
 db = get_db
 @result = db.execute 'select * from Users order by id desc'
 	erb :orders
end

post '/visit' do
	@user_name = params[:user_name]
	@phone = params[:phone]
	@date = params[:date]
	@time = params[:time]
	@barber = params[:barber]


	# Check validation
	
	hh_valid = {:user_name  => 'Enter your name',
			:phone => 'Enter your phone',
			:date => 'Enter date ',
			:time => 'Enter time',
			:barber => 'choose a barber'
		}

	hh_valid.each do |key,value|
		if (params[key] == '' || params[key]=='underfined')
			@error = hh_valid[key]
			return erb :visit			
		end
	end 
	#Check period of time	
	@x = @time.delete":"    #delete symbol ":"
	while @x.to_i < 800 || @x.to_i > 1830     
		@error = "you can make an appointment from 8:00 to 18:30, please enter correct time "
		return erb :visit  
	end
	

	@title = 'Thank you !'
	@message = "Dear #{@user_name}, we will be waiting for you on #{@date} at #{@time},
	your barber is #{@barber}"

	db = get_db
	db.execute 'insert into	Users(user,	phone, barber, date, time) values ( ?, ?, ?, ?, ?)' , [@user_name, @phone,@barber, @date, @time]
	
	erb :order_message 
end
