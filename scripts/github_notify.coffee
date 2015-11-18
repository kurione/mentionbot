module.exports = (robot) ->
  slack = robot.adapter.client
  slack.on 'raw_message', (msg) ->
    robot.send {room: 'test'}, "test"
    robot.send {room: 'test'}, msg.text
    return
