# Description
#   A hubot script that manages money for Team 8
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot 8 - Hubot's opinion about 8.
#   helen - Magical unicorns.
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Restuta[@<org>]

chalk = require('chalk')
util = require('util');
Slack = require('./utils/slack')
moment = require('moment');

toJson = (obj) -> util.inspect(obj, {colors: true})

module.exports = (robot) ->
  slack = Slack(robot);

  #main logic for managing todos
  todos = (msg) ->
    getCurrentChannelBrainCell: () ->
      # today = moment().format('MM-DD-YYYY')
      brainCell = "Daily_todo_for__#{msg.message.room}"

    getAllTodos: () ->
      todos = robot.brain.get(this.getCurrentChannelBrainCell(msg))
      return todos ? 'no todos yet ¯\\_(ツ)_/¯'

    initInCurrentChannel: () ->
      if (!this.getAllTodos())
        return {}

      console.log this.getAllTodos()


  # triggered only when "hubot <msg>" is sent
  robot.respond /todo!/i, (msg) ->
    slack.send(msg, 'text', '#00ccbb')

  #triggered on every message
  robot.hear /(todo)/i, (msg) ->
    todos(msg).initInCurrentChannel(msg)

    slack.send(msg, 'Here', '#bbccdd', [{
      title: "Title"
      value: "~value value value value value value value value~"
      short: false
    },{
      title: "Title"
      value: "value value value value value value value value"
      short: true
    }])

    console.log()

    slack.send(msg, 'I heard todo test', '#00ccbb', {
      title: "Title"
      value: "value value value value value value value value"
      short: true
    });

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
