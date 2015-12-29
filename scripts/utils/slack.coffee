chalk = require('chalk')
util = require('util');

toJson = (obj) -> util.inspect(obj, {colors: true})

module.exports = (robot) ->
  console.log(chalk.magenta('Slack module initialized.'))

  send = (msg, text, color, attachements) ->
    itIsSlack = msg.message.room != 'Shell'

    if(!itIsSlack)
      return msg.send(text)

    fields = []

    if (attachements)
      fields = if Array.isArray(attachements) then attachements else [attachements]

    robot.emit 'slack.attachment',
      message: msg
      attachments:[{
        text: text
        color: color
        fallback: text
        fields: fields,
        mrkdwn_in: ['text', 'pretext', 'fields'] #enables markdown in all fiedls
      }]

  return {
    send: send
  }
