require 'slack'

# slack configuration
$:.unshift File.dirname(__FILE__)
require "token" # set your $token in ./token.rb
Slack.configure do |config|
  config.token = $token
end

# Post a text to #channel slack as username
#
# @param [String] text a text to be post in slack
# @param [String] username username is displayed intead of bot
# @param [String] channel # is needed at the head of channel
# @return [Boolean] returns whether post is successed or not
def slack_post(text, username, channel)
  result = false
  if Slack.auth_test["ok"] then
    result = Slack.chat_postMessage(text: text, username: username , channel: channel)["ok"]
  end
  return result
end
