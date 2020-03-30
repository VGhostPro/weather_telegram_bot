require 'telegram/bot'
require_relative 'weather'

class TelegramBot
  TOKEN = 'YOUR_TOKEN'.freeze

  def run
    bot.listen do |message|
      weather_message(message)
    rescue => e
      puts e.message
    end
  end

  private

  def bot
    Telegram::Bot::Client.run(TOKEN) { |bot| return bot }
  end

  def weather_message(message)
    return unless message.text.include? '/weather'

    send_message(message.chat.id, Weather.new(city_name(message.text)).form_message)
  end

  def city_name(text)
    text.gsub('/weather', '').strip.tr(' ', '+')
  end

  def send_message(chat_id, message)
    bot.api.sendMessage(chat_id: chat_id, text: message)
  end
end
