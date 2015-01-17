module Tools

  def Tools.wait_for_ajax(page)
    Timeout.timeout(10) do
      loop do
        active = page.evaluate_script('jQuery.active')
        break if active == 0
      end
    end
  end

  # Became useless because now the geolocation is saved in an angular service
  def Tools.simulate_location(page, lat, lng)
    page.driver.browser.execute_script <<-JS
      window.navigator.geolocation.getCurrentPosition = function(success){
        var position = {"coords" : { "latitude": "#{lat}", "longitude": "#{lng}" }};
        success(position);
      }
    JS
  end

end
