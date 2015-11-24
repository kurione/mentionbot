# Description:
#   bot_command.coffee

module.exports = (robot) ->
  MEMBER_KEY = "member"
  robot.respond /add user (.+) (.+)$/, (msg) ->
    members = (robot.brain.get MEMBER_KEY) or []
    member =
      github_name: msg.match[1]
      slack_name: msg.match[2]
    members.push member
    robot.brain.set(MEMBER_KEY, members)
    msg.send "#test" "add user #{github_name}:#{slack_name}"

  #robot.respond /list user$/, (msg) ->
