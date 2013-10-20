# Description:
#   Hubot says goodbye.
#
# Commands:
#   Goodbye hubot
#
# Notes:
#   Testing 1,2,3

module.exports = (robot) ->
  robot.hear /(cya|bye|later)/i, (msg) ->
    goodbyes = [ "Bye", "Later", "Take care"]
    msg.send msg.random goodbyes
