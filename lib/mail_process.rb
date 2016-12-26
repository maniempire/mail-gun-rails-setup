require 'rest_client'
module Mailprocess
  MAIL_GUN_API_KEY = "###########" #Configure your mail gun API Key
  MAIL_DOMAIN = "############" #Configure your mail domain
  API_VERSION = "v3" #API version used
  BASE_URI = "https://api:key-#{MAIL_GUN_API_KEY}@api.mailgun.net/#{API_VERSION}/#{MAIL_DOMAIN}"
  
  class MailProcess

    def initialize
    end
     
    # Send emails with a subject, text and campaign id to any email address         
    def send_message(subject, text, campaign_id, to_email)
      ret_msg = nil
      if !to_email.blank?
        begin
          response = RestClient.post "#{BASE_URI}/messages",
          :from => "Mailgun Test User <xxxx@xxxxxxx.com>",
          :to => to_email,
          :subject => subject,
          :html => " #{text} <br/> A <a href='http://www.google.com'>sample link</a> is atttached 
          to test the click event of the email link.",
          "o:campaign" => campaign_id
          ret_msg = response.code == 200 ? "Success" : "Failed"
        rescue Exception => e
          Rails.logger.debug e.message
        end
      end
      ret_msg
    end
    
    # Detect if an email address is listed in a suppressions (do not contact) list
    def detect_email_in_suppression_list(email)
      ret_msg = nil
      if !email.blank?
        suppression_emails = get_suppression_email_list("bounces") + get_suppression_email_list("unsubscribes") + get_suppression_email_list("complaints")
        ret_msg = ( !suppression_emails.blank? && suppression_emails.include?(email) ) ? "The email - #{email} is in the suppression list." : "The email - #{email} is not in the suppression list."
      end
      ret_msg
    end
    
    def get_suppression_list(suppression_type)
      response = nil
      begin
        response = RestClient.get "#{BASE_URI}/#{suppression_type}" 
      rescue Exception => e
        Rails.logger.debug e.message
      end
      response
    end
         
    def get_suppression_email_list(suppression_type)
      suppression_emails = []
      response = get_suppression_list(suppression_type)
      if !response.blank?
        json_body = JSON.parse(response.body)
        suppression_array = json_body["items"]
        if !suppression_array.blank?
          suppression_array.each do |suppression_item|
            suppression_emails.push(suppression_item["address"])
          end
        end
      end
      suppression_emails
    end
    
    # Get the list of previously sent emails to an email address
    def get_email_list(email)
      mail_list_array = []
      response = get_emails(email)
      if !response.blank?
        json_body = JSON.parse(response.body)
        if !json_body["items"].blank?
          Rails.logger.info "Total Emails: #{json_body["items"].count}"
          json_body["items"].each do |item|
            Rails.logger.info "Subject: #{item['message']['headers']['subject']}"
            Rails.logger.info "Storage Url: #{item['storage']['url']}"
            mail_list_array.push(item['storage']['url'])
          end
        end
      end
      mail_list_array
    end
    
    def get_emails(email)
      response = nil
      begin
        response = RestClient.get "#{BASE_URI}/events",
        :params => {
          :'begin'       => 'Fri, 9 December 2016 01:00:00 -0000',
          :'event' => 'delivered',
          :'ascending'   => 'yes',
          :'limit'       =>  25,
          :'pretty'      => 'yes',
          :'recipient' => "#{email}"
        }
      rescue Exception => e
        Rails.logger.debug e.message
      end
      response
    end
      
  end
  
end