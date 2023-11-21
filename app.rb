# frozen_string_literal: true

require 'securerandom'
require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pg'
require 'dotenv/load'

set :method_override, true

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def db_connection
  PG.connect(dbname: ENV['DB_NAME'], user: ENV['DB_USER'])
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = load_memos
  erb :index
end

get '/memos/:id' do
  @memo = fetch_memo(params[:id])
  erb :show
end

get '/memos/:id/edit' do
  @memo = fetch_memo(params[:id])
  erb :edit
end

delete '/memos/:id' do
  delete_memo(params[:id])
  redirect to('/')
end

patch '/memos/:id' do
  id = params[:id]
  title = params[:title]
  content = params[:content]

  update_memo(id:, title:, content:)
  redirect to("/memos/#{id}")
end

get '/new' do
  erb :new
end

post '/memos' do
  id = SecureRandom.uuid
  title = params[:title]
  content = params[:content]

  write_memo(id:, title:, content:)
  redirect to('/memos')
end

def load_memos
  connection = db_connection
  result = connection.exec('SELECT * FROM memos')
  result.map { |row| { 'id' => row['id'], 'title' => row['title'], 'content' => row['content'] } }
ensure
  connection&.close
end

def fetch_memo(id)
  memos = load_memos
  memos.find { |memo| memo['id'] == id }
end

def write_memo(id:, title:, content:)
  db_connection.exec('INSERT INTO memos (id, title, content) VALUES ($1, $2, $3)', [id, title, content])
end

def update_memo(id:, title:, content:)
  db_connection.exec('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, id])
end

def delete_memo(id)
  db_connection.exec('DELETE FROM memos WHERE id = $1', [id])
end
