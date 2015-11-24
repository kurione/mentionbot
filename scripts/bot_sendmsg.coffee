# Description:
#   bot_sendmsg.coffee

module.exports = (robot) ->
  MEMBER_KEY = "member"
  OPTIONS =
    webhook: process.env.HUBOT_SLACK_INCOMING_WEBHOOK

  robot.hear /Failed:  (.+)'s build/i, (msg) ->
    github_name = msg.match[1]
    slack_name = get_slackname github_name
    if slack_name
      attachment =
        text    : "#{slack_name}: deployに失敗したらしいよ"
        color   : "warning"

      reqbody = JSON.stringify(
        token       : OPTIONS.webhook
        channel     : "#test"
        text        : ""
        username    : "notifybot"
        icon_emoji  : ":slack:"
        link_names  : 1
        attachments : [attachment]
        )

      robot.logger.info reqbody
      robot.http(OPTIONS.webhook)
        .header("Content-Type", "application/json")
        .post(reqbody) (err, res, body) ->
          return if res.statusCode == 200
          robot.logger.error "Error!", res.statusCode, body

  get_slackname = (github_name) ->
    members = (robot.brain.get MEMBER_KEY) or []
    index = find_member(members, github_name)
    if index >= 0
      return members[index].slack_name
    return

  find_member = (members, key) ->
    for member, index in members
      if key == member.github_name
        return index
    return
