# Description:
#   github_notify

module.exports = (robot) ->
  slack = robot.adapter.client
  slack.on 'raw_message', (msg) ->
    robot.send {room: 'test'}, "ok"
    return
