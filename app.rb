require 'sinatra'
require 'haml'
require 'json'
require 'open-uri'

user = nil
repo = nil

get '/' do
  "hello"
end

get '/star.svg' do
  if params[:user]
    if params[:repo]
      user = params[:user]
      repo = params[:repo]

      star_count = get("https://api.github.com/repos/#{user}/#{repo}", 'stargazers_count')

      # everything is ok.
      content_type 'image/svg+xml'
      return create_button({
        :button_text => 'Star',
        :count_url   => "https://github.com/#{user}/#{repo}/stargazers",
        :count       => star_count,
        :button_url  => "https://github.com/#{user}/#{repo}"
      })
    else
      content_type 'text/plain'
      return 'missing repo param'
    end
  else
    content_type 'text/plain'
    return 'missing user param'
  end
end

get '/fork.svg' do
  if params[:user]
    if params[:repo]
      user = params[:user]
      repo = params[:repo]

      fork_count = get("https://api.github.com/repos/#{user}/#{repo}", 'forks_count')

      # everything is ok.
      content_type 'image/svg+xml'
      return create_button({
        :button_text => 'Fork',
        :count_url   => "https://github.com/#{user}/#{repo}/network",
        :count       => fork_count,
        :button_url  => "https://github.com/#{user}/#{repo}/fork"
      })
    else
      content_type 'text/plain'
      return 'missing repo param'
    end
  else
    content_type 'text/plain'
    return 'missing user param'
  end
end

def get(api_url, prop)
  JSON.parse(open(api_url).read)[prop]
end

def create_button(opts)
  Haml::Engine.new(File.read("./btn.haml")).render(Object.new, :opts => opts)
end