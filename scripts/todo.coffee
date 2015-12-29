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


module.exports = (robot) ->

  slack = Slack(robot);

  # triggered only when "hubot <msg>" is sent
  robot.respond /todo!/i, (msg) ->
    slack.send(msg, 'text', 'good')
    msg send "bla"
    msg.reply "todo module is loaded!"

  #triggered on every message
  robot.hear /(todo test)/i, (msg) ->
    msg.send "I heard todo test"

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
