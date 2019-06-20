class Emailer < ApplicationMailer
  def send_report rates
    @rates = rates
    mail(to: ["tskulkarni25@gmail.com", "maheshpathak@yahoo.com"], subject: "Today's Stock Market Rates (#{Date.today})", content_type: "text/html")
  end

  def send_test_mail
  	mail(to: "ravimevcha@gmail.com", from: "ravimevcha@gmail.com", subject: "Test mail", content_type: "text/html")
  end
end