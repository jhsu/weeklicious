require 'rubygems'
require 'httparty'
require 'chronic'
require 'pp'
require 'erb'

class Weeklicious
  include HTTParty
  
  base_uri 'https://api.del.icio.us/v1'
  basic_auth 'jhsu', 'm02648'

  def initializer(u, p)
    #@auth = {:username => u, :password => p}
  end

  def posts(options={})
    self.class.get('/posts/all', options)
  end

  def this_week
    today = Time.now.strftime("%y-%m-%d")
    last_week = Chronic.parse('7 days ago').strftime("%y-%m-%d")
    self.class.get('/posts/all',:query => {:fromdt => last_week, :todt => today})
  end

end

weeklicious = Weeklicious.new
week_links =  weeklicious.this_week

  template = %q{
    <h2><a href="http://delicious.com/jhsu" title="delicious/jhsu">jhsu</a>'s Weekly Delicious Links</h2>
    <ul>
      <% week_links['posts']['post'].each do |post| %>
        <li><a href="<%= post['href'] %>" title="<%= post['description'] %>"><%= post['description'] %></a></li>
      <% end %>
    </ul>
  }

rhtml = ERB.new(template).result
File.open('index.html', 'w') {|f| f.write(rhtml) }
