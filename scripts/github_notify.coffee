# Description:
#   github_notify

module.exports = (robot) ->
  slack = robot.adapter.client
  slack.on 'message', (msg) ->
    return if msg.subtype is 'bot_message'

    msg.text /Failed:  (.+?)'s build/i, (hits) ->
      commit_user = hits.match[1]
      robot.send {room: 'test'}, "@#{commit_user}: failed!"
      return
