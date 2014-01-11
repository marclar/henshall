# Description:
#   Hubot says goodbye, then quits
#
# Commands:
#   Hubot bye, cya, later
#
# Notes:
#   Testing 1,2,3

module.exports = (robot) ->
  robot.respond /(cya|bye|later)/i, (msg) ->
    goodbyes = [ "Bye", "Later", "Take care", "Goodbye", "Thanks for all the fish"]
    msg.send "#{msg.random goodbyes} :wave:"
