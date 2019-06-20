class PagesController < ApplicationController

  def index
    
# https://www.moneycontrol.com/mutual-funds/nav/hdfc-midcap-opportunities/MHD068

# https://www.moneycontrol.com/mutual-funds/nav/hdfc-balanced-advantage-fund/MHD004
    @rates = []
    nifty_50 = "https://www.moneycontrol.com/indian-indices/nifty-50-9.html"
    hdfc_standard_life = "https://www.moneycontrol.com/india/stockpricequote/miscellaneous/hdfclifeinsurancecompanylimited/HSL01"
    hdfc_bank = "https://www.moneycontrol.com/india/stockpricequote/banks-private-sector/hdfcbank/HDF01"
    hdfc = "https://www.moneycontrol.com/india/stockpricequote/finance-housing/housingdevelopmentfinancecorporation/HDF"
    itc = "https://www.moneycontrol.com/india/stockpricequote/cigarettes/itc/ITC"
    reliance_industries = "https://www.moneycontrol.com/india/stockpricequote/refineries/relianceindustries/RI"
    kotak_mahindra_bank = "https://www.moneycontrol.com/india/stockpricequote/banks-private-sector/kotakmahindrabank/KMB"
    infosys = "https://www.moneycontrol.com/india/stockpricequote/computers-software/infosys/IT"
    tcs = "https://www.moneycontrol.com/india/stockpricequote/computers-software/tataconsultancyservices/TCS"
    hindustan_unilever = "https://www.moneycontrol.com/india/stockpricequote/personal-care/hindustanunilever/HU"
    powergrid = "https://www.moneycontrol.com/india/stockpricequote/power-generation-distribution/powergridcorporationindia/PGC"
    mahindra_and_mahindra = "https://www.moneycontrol.com/india/stockpricequote/auto-cars-jeeps/mahindramahindra/MM"
    search_url = params[:url]

    nifty_50_page = Nokogiri::HTML(RestClient.get(nifty_50))
    nifty_50_current_rate = nifty_50_page.at_css('[class="FL gr_35"]')&.children&.text.to_f
    nifty_50_high_52 = nifty_50_page.at_css('[class="tbldtldata b_15"]').children.children.children.text.split[4].last(9).split(",").join.to_f
    nifty_50_percentage = ((nifty_50_high_52-nifty_50_current_rate) * 100)/nifty_50_high_52 if nifty_50_high_52.present? && nifty_50_current_rate.present?
    @rates << {name: "Nifty 50", url: nifty_50, high_52: nifty_50_high_52, current_rate: nifty_50_current_rate, percentage: nifty_50_percentage}

    arr = [hdfc_standard_life, hdfc_bank, hdfc, itc, reliance_industries, kotak_mahindra_bank, infosys, tcs, hindustan_unilever, powergrid, mahindra_and_mahindra, search_url].compact
    arr.each do |url|
      search_page = Nokogiri::HTML(RestClient.get(url))

      search_name = search_page.at_css('[class="b_42 company_name"]')&.children&.text
      search_current_rate = search_page.at_css('[id="Bse_Prc_tick"] strong')&.children&.text.to_f
      search_high_52 = search_page.at_css('[id="b_52high"]')&.children&.text.to_f
      search_percentage = ((search_high_52-search_current_rate) * 100)/search_high_52 if search_high_52.present? && search_current_rate.present?

      @rates << {name: search_name, url: url, high_52: search_high_52, current_rate: search_current_rate, percentage: search_percentage}
    end
  end

  def send_mail
    Emailer.send_report(params[:rates]).deliver_now
    # Emailer.send_test_mail.deliver_now
  end
end
