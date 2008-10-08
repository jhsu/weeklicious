require 'rubygems'
require 'httparty'
require 'chronic'
require 'pp'
require 'erb'
require 'fileutils'

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
    posts(:query => {:fromdt => last_week, :todt => today})
  end

end

weeklicious = Weeklicious.new
posts_this_week = weeklicious.this_week

template = %{
  <html>
    <head<title>Delicious links from <%= Time.now.strftime("%m %d, %Y") %> to <%= Chronic.parse("7 days ago").strftime("%m %d, %Y") %> | Joseph Hsu</title>
    </head>
    <body>
      <ul>
    <% posts_this_week['posts']['post'].each do |post| -%>
        <li><%=h post['description'] %></li> 
    <% end -%>
      </ul>
    </body>
  </html>
}

html = 'index.html'
FileUtils.rm(html)
#touch(html)

#File.open(hmtl, 'w')

#rhtml = ERB.new(template)
