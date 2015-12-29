chalk = require('chalk')
util = require('util');

toJson = (obj) -> util.inspect(obj, {colors: true})

module.exports = (robot) ->
  console.log(chalk.magenta('Slack module initialized.'))

  send = (msg, text, color) ->
    itIsSlack = msg.message.room != 'Shell'

    if(!itIsSlack)
      return msg.send(text)

    robot.emit 'slack.attachment',
      message: msg
      content:
        text: text
        color: color
        fallback: "Attachment fallback"

  return {
    send: send
  }
