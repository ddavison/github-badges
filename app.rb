require 'sinatra'
require 'haml'
require 'json'
require 'net/http'
require 'cgi'

user = nil
repo = nil

get '/' do
  haml :index
end

get '/list' do
  list = ''
  Dir['cache/*'].each {|file| list += file + '<br />'}

  list
end

get '/star.svg' do
  if params[:user]
    if params[:repo]
      user = params[:user]
      repo = params[:repo]

      star_count = get("https://api.github.com/repos/#{user}/#{repo}", 'stargazers_count', {user: user, repo: repo})

      # everything is ok.
      content_type 'image/svg+xml'

      # Avoid CDN caching
      now = CGI::rfc1123_date(Time.now)
      response.headers['Cache-Control'] = 'no-cache,no-store,must-revalidate,max-age=0'
      response.headers["Date"] = now
      response.headers["Expires"] = now

      return create_button({
        :button_text => 'star',
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

      fork_count = get("https://api.github.com/repos/#{user}/#{repo}", 'forks_count', {user: user, repo: repo})

      # everything is ok.
      content_type 'image/svg+xml'

      # Avoid CDN caching
      now = CGI::rfc1123_date(Time.now)
      response.headers['Cache-Control'] = 'no-cache,no-store,must-revalidate,max-age=0'
      response.headers["Date"] = now
      response.headers["Expires"] = now

      return create_button({
        :button_text => 'fork',
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

def get(api_url, prop, args)
  cached_response = "cache/#{args[:user]}:#{args[:repo]}"
  uri = URI.parse api_url
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(uri.request_uri)

  if File.exist?(cached_response)
    request['If-Modified-Since'] = File.stat(cached_response).mtime.rfc2822

    response = http.request(request)
    p response

    open cached_response, 'w' do |io|
      io.write response.body
    end if response.is_a?(Net::HTTPSuccess)
  else
    response = http.request(request)
    open cached_response, 'w' do |io|
      io.write response.body
    end
  end

  JSON.parse(File.read(cached_response))[prop]
end

def create_button(opts)
  Haml::Engine.new(File.read("./btn.haml")).render(Object.new, :opts => opts)
end
