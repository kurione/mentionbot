# Description:
#   bot_command.coffee

module.exports = (robot) ->
  MEMBER_KEY = "member"
  options =
    webhook: process.env.HUBOT_SLACK_INCOMING_WEBHOOK

  robot.respond /add (.+) (.+)$/i, (msg) ->
    members = (robot.brain.get MEMBER_KEY) or []
    member =
      github_name: msg.match[1]
      slack_name: msg.match[2]

    index = find_member(members, member.github_name)
    if index >= 0
      msg.send "NG. #{member.github_name} is already exists. try remove command."
    else
      members.push member
      robot.brain.set(MEMBER_KEY, members)
      msg.send "OK. add user github=#{member.github_name},slack=#{member.slack_name}"

  robot.respond /list$/i, (msg) ->
    members = (robot.brain.get MEMBER_KEY) or []
    lists = ""
    for member in members
      lists += "#{member.github_name}:#{member.slack_name},"
    msg.send if lists then lists else "nobody."

  robot.respond /remove (.+)$/i, (msg) ->
    members = (robot.brain.get MEMBER_KEY) or []
    member = msg.match[1]
    index = find_member(members, member)

    if index >= 0
      members.splice(index, 1)
      robot.brain.set(MEMBER_KEY, members)
      msg.send "OK. remove #{member}."
    else
      msg.send "NG. #{member} is not found. try list command."

  robot.respond /howto$/i, (msg) ->
    attachment =
      text    : ""
      color   : "good"
      fields  : [
        contents =
          title: "Add User"
          value: "@notifybot add <github_name> <slack_name>"
          short: false
        contents =
          title: "Remove User"
          value: "@notifybot remove <github_name>"
          short: false
        contents =
          title: "List User"
          value: "@notifybot list"
          short: false
      ]

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

  find_member = (members, key) ->
    for member, index in members
      if key == member.github_name
        return index
    return
