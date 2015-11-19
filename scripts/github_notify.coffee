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

    robot.emit 'slack.attachment',
      message: msg.message
      content:
        text      : "#{slack_user}: failed!"
        fallback  : "fallback"
        color     : "warning"
      username    : "notifybot"
      channel     : "test"
      link_names  : 1
