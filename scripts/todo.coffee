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

toJson = (obj) -> util.inspect(obj, {colors: true, depth: 8})

module.exports = (robot) ->
  slack = Slack(robot);

  ###
    main logic for managing todos
    brain structure is the following
    {
      "Daily_todo_for_<channel_name>": [{
        "12-28-2015": [{
          "restuta": [{
            "text": "buy milk",
            "completed": false
          }]
        }, {
          "me4ta": [{}]
        }]
      }, {
        "12-29-2015": [

        ]
      }]
    }
  ###
  Todos = (msg, robot) ->
    mainBrainCell = "Daily_todo_for__#{msg.message.room}"

    init = () ->
      today = moment().format('MM-DD-YYYY')
      todaysTodos = {};
      todaysTodos[today] = [{
        'restuta': [{
          text: 'buy milk',
          completed: false
        }]
      }];

      todos = [{todaysTodos}]
      robot.brain.set(mainBrainCell, todos)
      console.log toJson todos

    return {
      getAllTodos: () ->
        todos = robot.brain.get(mainBrainCell)
        return todos ? 'no todos yet ¯\\_(ツ)_/¯'

      initForCurrentChannel: () ->
        #if (!this.getAllTodos())
        init()
    }


  # triggered only when "hubot <msg>" is sent
  robot.respond /test-todo!/i, (msg) ->
    slack.send(msg, 'text', '#00ccbb')

  #triggered on every message
  robot.hear /(test-todo)/i, (msg) ->
    Todos(msg, robot).initForCurrentChannel(msg)

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
