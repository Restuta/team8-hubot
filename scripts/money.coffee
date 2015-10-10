# Description
#   A hubot script that manages money for Team 8
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot 8 - Hubot's opinioni about 8.
#   helen - Magical unicorns.
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Restuta[@<org>]

chalk = require('chalk')
util = require('util');

module.exports = (robot) ->
  robot.respond /8/i, (msg) ->
    msg.send "8 it is!"

  robot.hear /Helen/i, (msg) ->
    msg.send "Magical Unicorns!!!111"


  #todo add support for +$234234 and -$23423
  #todo add support for saving + and - log (a la tranasctions log)
  robot.hear /\$\d+(\.\d+)?/ig, (msg) ->
    # if msg.message.room != 'restuta'
    #   return

    moneyBrainCell = 'total-money'

    addMoney = (item) ->
      total = parseFloat(robot.brain.get(moneyBrainCell) ? 0)
      total += parseFloat(item)
      robot.brain.set moneyBrainCell, total
    subtractMoney = (item) ->
      total = parseFloat(robot.brain.get(moneyBrainCell) ? 0)
      total += parseFloat(item)
      robot.brain.set moneyBrainCell, total
    summ = (items) ->
      items.reduce (prev, current) -> prev + current
    toFloat = (x) ->
      parseFloat(if x[0] == '$' then x.substring 1 else x)

    msg.send 'calculating total...'
    currentTotal = addMoney summ msg.match.map (x) -> toFloat x

    msg.send '$' + robot.brain.get(moneyBrainCell).toFixed(2)

  robot.hear /test attach/i, (msg) ->
    msg.send "got it"

    robot.emit 'slack.attachment',
      message: msg.message
      content:
        # see https://api.slack.com/docs/attachments
        text: "Attachment text"
        title: "Title"
        color: "#36a64f"
        fallback: "Attachment fallback"
        fields: [{
          title: "Short Field title"
          value: "Short Field value"
          short: true
        },{
          title: "Long field title"
          value: "Long field value"
          short: true
        },{
          title: "Long field title"
          value: "Long field value"
          short: true
        }]
