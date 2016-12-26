require 'spec_helper'
require 'rails_helper'
require_relative "../../lib/mail_process.rb" 

RSpec.describe Mailprocess do
  
  let(:mail_prcocess) { Mailprocess::MailProcess.new }
  
  describe "#send_message" do
    let(:to_email) {"mani@maniempire.com"}
    let(:subject) {"Test Subject"}
    let(:text) {"This is the email"}
    let(:campaign_id) {"1234"}
    
    #This test is needed to test that sending mail is working fine if all parameters are having values 
    it "should send a message if the given email id is valid" do
      #expect(mail_prcocess.send_message(subject, text, campaign_id, to_email)).to eq "Success"
    end
    
    #This test is needed to test that sending mail is not working the email is blank 
    it "should not send a message if the given email id is nil" do
      expect(mail_prcocess.send_message(subject, text, campaign_id, nil)).to eq nil
    end
    
    #This test is needed to test that sending mail is not working the email is invalid 
    it "should not send a message if the given email id is invalid" do
      expect(mail_prcocess.send_message(subject, text, campaign_id, "aa@ss")).to eq nil
    end
    
    #This test is needed to test that sending mail will work if email is valid and all other fields are blank
    it "should send a message if the given email id is valid" do
      expect(mail_prcocess.send_message(nil, nil, nil, to_email)).to eq "Success"
    end
    
  end
  
   describe "#detect_email_in_suppression_list" do
      let(:exist_email) {"maniempire@bsnl.in"}
      let(:non_exist_email) {"mani@maniempire.com"}
     
     #This test is needed to test that email detection logic will give required message if the email passing is not in the list
     it "should return the given message as not exist if the given email is not in the suppression list" do
       expect(mail_prcocess.detect_email_in_suppression_list(non_exist_email)).to eq "The email - #{non_exist_email} is not in the suppression list."
     end
     
     #This test is needed to test that email detection logic will give required message if the email passing is in the list
     it "should return the given message as exist if the given email is in the suppression list" do
       expect(mail_prcocess.detect_email_in_suppression_list(exist_email)).to eq "The email - #{exist_email} is in the suppression list."
     end
     
     #This test is needed to test that email detection logic will return blank if the email is blank
     it "should return the given message as not exist if the given email is blank" do
       expect(mail_prcocess.detect_email_in_suppression_list(nil)).to eq nil
     end
     
   end
   
   describe "#get_suppression_list" do
      let(:suppression_type) {"bounces"}
       
    #This test is needed to test that we will get correct response if we pass the correct suppression type
     it "should return the correct response object if its a valid suppression type" do
       expect(mail_prcocess.get_suppression_list(suppression_type)).to be_a(RestClient::Response)
     end
     
     #This test is needed to test that we will get nul response if we pass suppression type as nil
     it "should return nil if the suppression type is blank" do
       expect(mail_prcocess.get_suppression_list(nil)).to eq nil
     end
     
     #This test is needed to test that we will get nil response if we pass the incorrect suppression type
     it "should return nil if its a not a valid suppression type" do
       expect(mail_prcocess.get_suppression_list("test")).to eq nil
     end
     
   end
   
   describe "#get_suppression_email_list" do
      let(:suppression_type) {"bounces"}
      
     #This test is needed to test that we will get the suppression list if we pass the correct suppression type 
     it "should return the array if its a valid suppression type" do
       expect(mail_prcocess.get_suppression_email_list(suppression_type)).to be_a(Array)
     end
     
     #This test is needed to test that we will get the empty list if we pass the nil suppression type 
     it "should return empty array if the suppression type is blank" do
       expect(mail_prcocess.get_suppression_email_list(nil)).to eq []
     end
     
     #This test is needed to test that we will get the empty list if we pass the incorrect suppression type 
     it "should return empty array if its a not a valid suppression type" do
       expect(mail_prcocess.get_suppression_email_list("test")).to eq []
     end
     
   end 
   
   describe "#get_email_list" do
      let(:email) {"manimaran@gmail.com"}
      
     #This test is needed to test that we will get mail array list if we pass the valid email  
     it "should return the mail list array if its a valid email" do
       expect(mail_prcocess.get_email_list(email)).to be_a(Array)
     end
     
     #This test is needed to test that we will get empty array list if we pass the blank email  
     it "should return empty array if the email is blank" do
       expect(mail_prcocess.get_email_list(nil)).to eq []
     end
     
     #This test is needed to test that we will get empty array list if we pass the invalid email 
     it "should return empty array if the email is not valid" do
       expect(mail_prcocess.get_email_list("test@")).to eq []
     end
     
   end
   
   describe "#get_emails" do
      let(:email) {"manimaran@gmail.com"}
      
     #This test is needed to test that we will get correct response object if we pass the valid email    
     it "should return the correct response object if its a valid email" do
       expect(mail_prcocess.get_emails(email)).to be_a(RestClient::Response)
     end
     
     #This test is needed to test that we will get nil response if we pass the blank email 
     it "should return nil response if the email is blank" do
       expect(mail_prcocess.get_emails(nil)).to eq nil
     end
     
   end               
                  
  
end