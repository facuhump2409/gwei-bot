require 'nokogiri'
require 'net/http'
require 'open-uri'

TELEGRAM_BOT_TOKEN = ENV['TELEGRAM_BOT_TOKEN']
CHAT_ID = ENV['CHAT_ID']
environment_gwei = ENV['MINIMUN_GWEI']
MINIMUN_GWEI = environment_gwei.nil? ? 100 : environment_gwei
document = Nokogiri::HTML(URI.open('https://etherscan.io/gastracker'))
list_xpath = "(//div[contains(@class,'card h-100 shadow-none p-3')]//span)[1]"
document.xpath(list_xpath).each do |detail|
  gwei = detail.to_s.match(/\d{2}(?:<)/)[0].tr('<', '').to_i
  puts "Actual Gwei: #{gwei}"
  if gwei <= MINIMUN_GWEI.to_i
    message = "Gwei price lower than usual \n Price: #{gwei} gwei"
    uri = URI("https://api.telegram.org/#{TELEGRAM_BOT_TOKEN}/sendMessage?chat_id=#{chat_id}&text=#{message}")
    res = Net::HTTP.get_response(uri)
    puts res.body if res.is_a?(Net::HTTPSuccess)
  end
end
