require 'rails_helper'

RSpec.describe 'Routing to photos', type:'routing'  do

  it { expect(get:'/photos').to route_to(controller:'photos', action:'index') }
  
end