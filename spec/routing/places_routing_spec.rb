require 'rails_helper'

RSpec.describe 'Routing to places', type:'routing'  do

  it { expect(get:'/places').to route_to(controller:'places', action:'index') }
  it { expect(get:'/places/1').to route_to(controller:'places', action:'show',id:'1') }
  
end