# Description:
#   github_notify.coffee

module.exports = (robot) ->
  options =
    token: process.env.HUBOT_SLACK_TOKEN
    webhook: process.env.HUBOT_SLACK_INCOMING_WEBHOOK

  account_map = {"MasatoUtsunomiya": "@m.utsunomiya"}

  slack = robot.adapter.client
  slack.on 'message', (msg) ->
    return if msg.subtype is 'bot_message'

    hits = msg.text.toString().match(/Failed:  (.+?)'s build/)
    return if hits is null

    commit_user = hits[1]
    slack_user = account_map[commit_user]

    reqbody = JSON.stringify(
      token       : options.webhook
      channel     : "#test"
      text        : "#{slack_user}: failed!"
      link_names  : 1
      attachments : [color: "warning"]
      )

    robot.logger.info reqbody

    robot.http(options.token)
      .header("Content-Type", "application/json")
      .post(reqbody) (err, res, body) ->
        return if res.statusCode == 200

        robot.logger.error "Error!", res.statusCode, body
