# Description:
#   github_notify.coffee

module.exports = (robot) ->
  account_map = {"MasatoUtsunomiya": "@m.utsunomiya"}

  slack = robot.adapter.client
  slack.on 'message', (msg) ->
    return if msg.subtype is 'bot_message'

    hits = msg.text.toString().match(/Failed:  (.+?)'s build/)
    return if hits is null

    commit_user = hits[1]
    slack_user = account_map[commit_user]

    attachment =
      text       : "Optional text that appears within the attachment"

    msgbody = JSON.stringify
      text       : "#{slack_user}: failed!"
      username   : "notifybot"
      channel    : "test"
      attachments : [attachment]
      link_names : 1

    robot.send {room: 'test'}, msgbody
