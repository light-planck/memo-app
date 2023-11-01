# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

$memos = []

get '/' do
  @memos = $memos
  erb :index
end

get '/new' do
  erb :new
end

post '/memos' do
  new_memo = { title: params[:title], content: params[:content] }
  $memos << new_memo
  redirect to('/')
end
