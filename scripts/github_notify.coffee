# Description:
#   github_notify

module.exports = (robot) ->
  slack = robot.adapter.client
  slack.on 'message', (msg) ->
    return if msg.subtype is 'bot_message'

    text = msg.text.match(/Failed:  (.+?)'s build/)
    return if text is null

    commit_user = match[1]
    robot.send {room: 'test'}, "@#{commit_user}: failed!"
    return
