# Description:
#   bot_command.coffee

module.exports = (robot) ->
  CHANNEL = room: "test"
  MEMBER_KEY = "member"

  robot.respond /add (.+) (.+)$/i, (msg) ->
    members = (robot.brain.get MEMBER_KEY) or []
    member =
      github_name: msg.match[1]
      slack_name: msg.match[2]

    index = find_member(members, member.github_name)
    if index >= 0
      msg.send CHANNEL, "#{member.github_name} is already exists. try remove."
    else
      members.push member
      robot.brain.set(MEMBER_KEY, members)
      msg.send CHANNEL, "OK. add user github=#{member.github_name},slack=#{member.slack_name}"

  robot.respond /list$/i, (msg) ->
    members = (robot.brain.get MEMBER_KEY) or []
    lists = ""
    for member in members
      lists += "#{member.github_name}:#{member.slack_name},"
    msg.send CHANNEL, lists

  robot.respond /remove (.+)$/i, (msg) ->
    members = (robot.brain.get MEMBER_KEY) or []
    member = msg.match[1]
    index = find_member(members, member)

    if index >= 0
      members.splice(index, 1)
      robot.brain.set(MEMBER_KEY, members)
      msg.send CHANNEL, "OK. remove #{member}."
    else
      msg.send CHANNEL, "#{member} is not found. try list command."

  find_member = (members, key) ->
    index = 0
    for member in members
      if key == members.github_name
        return index
      index = index + 1
    return
