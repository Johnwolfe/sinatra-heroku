require 'sinatra'
require 'sinatra/activerecord'
require "pry"



configure(:development){set :database, "sqlite3:my_sintara_db.sqlite3"}

require './models'

set :sessions, true


def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end

get '/' do
	if current_user
		@user = current_user
		erb :index
	else
		redirect "/sign-in"
	end
end


get '/philly' do

	erb :philly

end


get '/sign-in' do
	erb :sign_in
end

post '/sign-in' do
	@user = User.where(username: params[:username]).first

  if  @user && @user.password == params[:password]
  	session[:user_id] = @user.id
  	redirect '/new-post'
  else
  	redirect '/philly'
  end
end

get '/sign-out' do
	session[:user_id] = nil
	erb :sign_in
end


get '/sign-up' do
	erb :sign_up
end

post '/sign-up' do
	@user = User.new(params)

	if @user.save
		session[:user_id] = @user.id
		redirect '/'
	else
		redirect '/sign-up'
	end


end


get '/new-post' do
	if current_user
		erb :new_post
	else
		redirect	'/sign-in'
	end

end

post '/new-post' do


	@post = Post.new(body: params[:body], title: params[:title])
	if current_user
		@post.user_id = current_user.id
	end
	if @post.save
		flash[:notice] = "Your post was saved correctly."
		redirect '/'
	else
		flash[:alert] = "Your Post didn't save! Please try again!"
		redirect	'/new-post'
	end

end


get '/profile/:user_id' do

	# binding.pry
	@user = User.where(id: params[:user_id]).first
	erb :profile

end

get '/post-index' do
	@posts = Post.all
	erb :post_index
end



















