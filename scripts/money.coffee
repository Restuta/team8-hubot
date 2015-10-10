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

#money functions and variables
sendTotal = (robot, msg) ->
  moneyBrainCell = msg.message.room + '_total-money'
  itIsSlack = msg.message.room != 'Shell'
  currentTotal = robot.brain.get(moneyBrainCell).toFixed(2)

  if itIsSlack
    good = 'good'
    neutral = '#cccccc'
    danger = 'danger'

    msgColor = switch
      when currentTotal == 0 then neutral
      when currentTotal > 0 then good
      when currentTotal < 0 then danger

    robot.emit 'slack.attachment',
      message: msg.message
      content:
        text: 'Total: $' + currentTotal
        color: msgColor
        fallback: "Attachment fallback"
  else
    msg.send 'Total in #' + msg.message.room + ': $' + currentTotal

module.exports = (robot) ->
  robot.respond /8/i, (msg) ->
    msg.send "8 it is!"

  robot.hear /Helen/i, (msg) ->
    msg.send "Magical Unicorns!!!111"

  robot.hear /(total|show total)$/i, (msg) ->
    sendTotal robot, msg

  #todo add support for saving + and - log (a la tranasctions log)
  #listens for +$100 and -$100 in channels and maintains total
  robot.hear /[+-]\$\d+(\.\d+)?/ig, (msg) ->
    moneyBrainCell = msg.message.room + '_total-money'
    moneyHistoryBrainCell

    toFloat = (x) ->
      parseFloat(x.replace(/[+-]\$/, '')) #removes "+$"" or "-$" from the beginning of the string
    addMoney = (item) ->
      total = parseFloat(robot.brain.get(moneyBrainCell) ? 0)
      total += item
      robot.brain.set moneyBrainCell, total
    subtractMoney = (item) ->
      total = parseFloat(robot.brain.get(moneyBrainCell) ? 0)
      total -= item
      robot.brain.set moneyBrainCell, total

    msg.match.map (x) ->
      if x[0] == '+'
        addMoney toFloat x
      else
        subtractMoney toFloat x

    sendTotal robot, msg

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
