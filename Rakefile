desc "Clear HTML and pull this week's links"
task :update do |t|
  if File.exists?('index.html')
    sh "rm index.html"
  end
  sh "ruby weeklicious.rb"
end
