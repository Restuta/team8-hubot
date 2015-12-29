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

getTotal = (records) ->
  if records
    return records.map((x) -> x.amount).reduce(((prev, next) -> prev + next), 0)
  else
    return 0

getRecordsLog = (records) ->
  if records
    records.map((x) -> x.description)
  else
    return []

sendToSlack = (robot, message, text, color) ->
  robot.emit 'slack.attachment',
    message: message
    content:
      text: text
      color: color
      fallback: "Attachment fallback"

#money functions and variables
sendTotal = (robot, msg) ->
  moneyHistoryBrainCell = msg.message.room + '_total-money-history'
  itIsSlack = msg.message.room != 'Shell'

  records = robot.brain.get(moneyHistoryBrainCell);
  currentTotal = getTotal(robot.brain.get(moneyHistoryBrainCell))

  #msg.send('\n' + getRecordsLog(records).join('\n'))
  log = '\n'

  if (!records)
    log = ''
  else
    for record in records
      if (record.amount > 0)
        log += '_' + record.description + '_\n'
      else
        log += '_    ' + record.description + '_\n'

  msg.send(log)

  if itIsSlack
    msgColor = switch
      when currentTotal == 0 then '#cccccc'
      when currentTotal > 0 then 'good'
      when currentTotal < 0 then 'danger'

    sendToSlack(robot, msg.message, 'Total: $' + currentTotal, msgColor)
  else
    msg.send('Total in #' + msg.message.room + ': $' + currentTotal)

module.exports = (robot) ->
  robot.respond /8/i, (msg) ->
    msg.send "8 it is!"

  robot.hear /Helen/i, (msg) ->
    msg.send "Magical Unicorns!!!111"

  robot.hear /(total|money total)$/i, (msg) ->
    sendTotal robot, msg

  robot.hear /(money reset)$/i, (msg) ->
    moneyHistoryBrainCell = msg.message.room + '_total-money-history'
    robot.brain.set(moneyHistoryBrainCell, [])
    sendTotal robot, msg

  #todo add support for saving + and - log (a la tranasctions log)
  #listens for +$100 and -$100 in channels and maintains total
  robot.hear /[+-]\$\d+(\.\d+)? [\w\s!@#%^&*()_+"'\\\/]+/ig, (msg) ->
    moneyHistoryBrainCell = msg.message.room + '_total-money-history'

    toFloat = (x) ->
      parseFloat(x.replace('$', ''))
    extractAmount = (x) ->
      toFloat(x.match(/[+-]\$\d+(\.\d+)?/)[0])
    addRecord = (amount, record) ->
      records = robot.brain.get(moneyHistoryBrainCell) ? []
      records.push({
        amount: amount,
        description: record});
      robot.brain.set(moneyHistoryBrainCell, records)

    msg.match.map (matchedRecord) ->
      amount = extractAmount(matchedRecord)
      addRecord(amount, matchedRecord)

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
