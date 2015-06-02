require 'sinatra'
set :server, 'trinidad'  # THis line must run before we require 'pacer'
require 'json'
require 'pacer'
require 'app.rb'


# Our graph
@@g = NorthWind.load_graph


get '/' do
  content_type :json
  @@g.v(NorthWind::Customer).name.to_a.to_json
end

