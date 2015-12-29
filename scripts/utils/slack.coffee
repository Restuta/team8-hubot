chalk = require('chalk')
util = require('util');

toJson = (obj) -> util.inspect(obj, {colors: true})

module.exports = (robot) ->
  console.log(chalk.magenta('Slack module initialized.'))
  send = (message, text, color) ->
    robot.emit 'slack.attachment',
      message: message
      content:
        text: text
        color: color
        fallback: "Attachment fallback"

  return {
    send: send
  }
