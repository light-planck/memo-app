# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

set :method_override, true

get '/' do
  @memos = if File.exist?('data/memos.json') && !File.empty?('data/memos.json')
             JSON.parse(File.read('data/memos.json'))
           else
             []
           end
  erb :index
end

get '/memos/:id' do
  memos = if File.exist?('data/memos.json') && !File.empty?('data/memos.json')
            JSON.parse(File.read('data/memos.json'))
          else
            []
          end
  @memo = memos.find { |memo| memo['id'] == params[:id].to_i }
  erb :show
end

delete '/memos/:id' do
  memos = if File.exist?('data/memos.json') && !File.empty?('data/memos.json')
            JSON.parse(File.read('data/memos.json'))
          else
            []
          end
  memos.delete_if { |memo| memo['id'] == params[:id].to_i }
  File.open('data/memos.json', 'w') { |f| f.write(memos.to_json) }
  redirect to('/')
end

get '/new' do
  erb :new
end

post '/memos' do
  memos = if File.exist?('data/memos.json') && !File.empty?('data/memos.json')
            JSON.parse(File.read('data/memos.json'))
          else
            []
          end
  new_id = memos.empty? ? 1 : memos.last['id'] + 1
  new_memo = { id: new_id, title: params[:title], content: params[:content] }
  memos << new_memo
  File.open('data/memos.json', 'w') { |f| f.write(memos.to_json) }
  redirect to('/')
end
