module.exports = (robot) ->
  robot.adapter.client?.on? 'raw_message', (msg) ->
    #return if msg.type isnt 'message' || msg.subtype isnt 'bot_message'
    #return unless msg.attachments
    #match = msg.attachments[0].fallback.match(/Failed:  (.+?)'s build/)
    robot.send {room: "##{test}"}, msg.text
    return

    #match = msg.text.match(/Failed:  (.+?)'s build/)
    #return if match is null
    #commit_user = match[1]
    #channel = robot.adapter.client.getChannelByID msg.channel
    # プライベートチャンネルは取得出来ないためundefinedが返される
    #return if channel is undefined
    #text = "@#{commit_user} テストが落ちたよー！"
    #robot.send {room: "##{channel.name}"}, text
