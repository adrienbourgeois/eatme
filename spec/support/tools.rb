module Tools

  def wait_for_ajax
    Timeout.timeout(10) do
      loop do
        active = page.evaluate_script('jQuery.active')
        break if active == 0
      end
    end
  end

  def simulate_location(lat, lng)
    page.driver.browser.execute_script <<-JS
      window.navigator.geolocation.getCurrentPosition = function(success){
        var position = {"coords" : { "latitude": "#{lat}", "longitude": "#{lng}" }};
        success(position);
      }
    JS
  end

end
