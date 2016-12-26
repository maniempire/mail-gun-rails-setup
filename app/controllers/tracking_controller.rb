class TrackingController < ApplicationController
  
  skip_before_action :verify_authenticity_token, :only =>[:listen_open_event, :listen_click_event]
  
  # Understand open event
  def listen_open_event
    puts "Mail is opened"
    log_event(params)
    render json: 
    {
      status: "success"
    }.to_json
  end
  
  # Understand click event
  def listen_click_event
    puts "Link in the mail is clicked"
    log_event(params)
    render json: 
    {
      status: "success"
    }.to_json
  end
  
  private
   
  # Parse and log open and click events 
  def log_event(params)
    puts "Log Details:"
    puts "<====================>"
    puts "Event Type: #{params['event']}"
    puts "Recepient: #{params['recipient']}"
    puts "City: #{params['city']}"
    puts "Country: #{params['country']}"
    puts "Client Type: #{params['client-type']}"
    puts "Client Name: #{params['client-name']}"
    puts "Device Type: #{params['device-type']}"
    puts "Client OS: #{params['client-os']}"
    puts "Url Clicked: #{params['url']}" if params['event'] == "clicked"
    puts "Logged at: #{Time.at(params['timestamp'].to_i).utc.to_datetime}"
    puts "<====================>"
  end
  
end
