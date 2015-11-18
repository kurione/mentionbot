# Description:
#   github_notify

module.exports = (robot) ->
  slack = robot.adapter.client
  slack.on 'message', (msg) ->
    return if msg.subtype is 'bot_message'

    msg.text /Failed:  (.+?)'s build/i, (commit_user) ->
      robot.send {room: 'test'}, "@#{commit_user}: failed!"
      return
