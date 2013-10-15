# Description:
#   Hubot says goodbye.
#
# Commands:
#   Goodbye hubot
#
# Notes:
#   Testing 1,2,3

module.exports = (robot) ->
  robot.respond /(bye|later)/i, (msg) ->
    goodbyes = [ "Bye", "Later", "Take care"]
    byeMessage = goodbyes[Math.floor(Math.random() * goodbyes.length)]
    msg.send(byeMessage)
