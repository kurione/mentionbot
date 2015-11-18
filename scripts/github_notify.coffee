module.exports = (robot) ->
  robot.adapter.client?.on? 'raw_message', (msg) ->
    robot.send {room: 'test'}, "test"
    return
