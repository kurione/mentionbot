# Description:
#   github_notify

module.exports = (robot) ->
  slack = robot.adapter.client
  slack.on 'message', (msg) ->
    robot.send {room: 'test'}, msg.text
    return
