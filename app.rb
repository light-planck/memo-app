# frozen_string_literal: true

require 'securerandom'
require 'sinatra'
require 'sinatra/reloader'
require 'json'

set :method_override, true

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = load_memos
  erb :index
end

get '/memos/:id' do
  memos = load_memos
  @memo = memos.find { |memo| memo['id'] == params[:id] }
  erb :show
end

get '/memos/:id/edit' do
  memos = load_memos
  @memo = memos.find { |memo| memo['id'] == params[:id] }
  erb :edit
end

delete '/memos/:id' do
  memos = load_memos
  memos.delete_if { |memo| memo['id'] == params[:id] }
  File.open('data/memos.json', 'w') { |f| f.write(memos.to_json) }
  redirect to('/')
end

patch '/memos/:id' do
  memos = load_memos
  updated_memo = memos.find { |memo| memo['id'] == params[:id] }
  updated_memo['title'] = params[:title]
  updated_memo['content'] = params[:content]
  write_memos(memos)
  redirect to("/memos/#{params[:id]}")
end

get '/new' do
  erb :new
end

post '/memos' do
  memos = load_memos
  new_id = SecureRandom.uuid
  new_memo = { id: new_id, title: params[:title], content: params[:content] }
  memos << new_memo
  write_memos(memos)
  redirect to('/')
end

def load_memos
  if File.exist?('data/memos.json') && !File.empty?('data/memos.json')
    JSON.parse(File.read('data/memos.json'))
  else
    []
  end
end

def write_memos(memos)
  File.open('data/memos.json', 'w') { |f| f.write(memos.to_json) }
end
