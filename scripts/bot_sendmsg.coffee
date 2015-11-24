# Description:
#   bot_sendmsg.coffee

module.exports = (robot) ->
  options =
    webhook: process.env.HUBOT_SLACK_INCOMING_WEBHOOK

  robot.adapter.client.on 'message', (msg) ->
    reg_result = msg.text.toString().match(/Failed:  (.+?)'s build/)
    return if reg_result is null

    github_commit_user = reg_result[1]
    slack_user = account_map[github_commit_user]

    attachment =
      text    : "#{slack_user}: deployに失敗したらしいよ"
      color   : "warning"

    reqbody = JSON.stringify(
      token       : options.webhook
      channel     : "#test"
      text        : ""
      username    : "notifybot"
      icon_emoji  : ":slack:"
      link_names  : 1
      attachments : [attachment]
      )

    robot.http(options.webhook)
      .header("Content-Type", "application/json")
      .post(reqbody) (err, res, body) ->
        return if res.statusCode == 200

        robot.logger.error "Error!", res.statusCode, body

    robot.logger.info reqbody
