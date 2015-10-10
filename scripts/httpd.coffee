# Description:
#   A simple interaction with the built in HTTP Daemon
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# URLS:
#   /hubot/version
#   /hubot/ping
#   /hubot/time
#   /hubot/info
#   /hubot/ip

spawn = require('child_process').spawn

module.exports = (robot) ->
  robot.router.get '/', (req, res) ->
    res.end 'I am just a robot programmed with &#x2661; by Restuta.'

  robot.router.get "/version", (req, res) ->
    res.end robot.version

  robot.router.post "/ping", (req, res) ->
    res.end "PONG"

  robot.router.get "/time", (req, res) ->
    res.end "Server time is: #{new Date()}"

  robot.router.get "/info", (req, res) ->
    child = spawn('/bin/sh', ['-c', "echo I\\'m $LOGNAME@$(hostname):$(pwd) \\($(git rev-parse HEAD)\\)"])

    child.stdout.on 'data', (data) ->
      res.end "#{data.toString().trim()} running node #{process.version} [pid: #{process.pid}]"
      child.stdin.end()

  robot.router.get "/ip", (req, res) ->
    robot.http('http://ifconfig.me/ip').get() (err, r, body) ->
      res.end body
