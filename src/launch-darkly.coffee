# Description
#   A hubot script that integrates with launch darkly
#
# Configuration:
#   LAUNCH_DARKLY_API_TOKEN
#
# Commands:
#   launchdarkly list - list feature toggles
#   launchdarkly list <project>- list feature toggles by project
#   launchdarkly list <project> <environment>- list feature toggles by project and environment
#
# Author:
#   James Hrisho <james.hrisho@gmail.com>

# Description:
#   Example scripts for you to examine and try out.
#
apiToken = process.env.LAUNCH_DARKLY_API_TOKEN;
buildFeatureToggles = (data) -> 
    return data.map (i) -> 
        name = i.name;
        environments = ""
        for k,v of i.environments
            environments += k.toString() + ": " + v.on + ", "
        return name + " - " + environments + "\n"; 

buildFeatureTogglesForEnvironment = (data, environment) -> 
    return data.map (i) -> 
        name = i.name;
        environments = ""
        for k,v of i.environments
            environments +=  if k == environment then k.toString() + ": " + v.on else ''
        return name + " - " + environments + "\n"; 

module.exports = (robot) ->

  robot.respond /launchdarkly list (.*) (.*)$/i, (message) ->
    message.http("https://app.launchdarkly.com/api/v2/flags/#{message.match[1]}")
      .header('User-Agent', 'Hubot')
      .header('Authorization', apiToken)
      .get() (err, response, body) ->
        if response.statusCode isnt 200
          message.send "Request didn't come back HTTP 200 :("
          return
        result = JSON.parse(body)
        buildResponse = buildFeatureTogglesForEnvironment(result.items, message.match[2])
        message.send buildResponse

  robot.respond /launchdarkly list ([\w\-]+)$/i, (message) ->
    message.http("https://app.launchdarkly.com/api/v2/flags/#{message.match[1]}")
      .header('User-Agent', 'Hubot')
      .header('Authorization', apiToken)
      .get() (err, response, body) ->
        if response.statusCode isnt 200
          message.send "Request didn't come back HTTP 200 :("
          return
        result = JSON.parse(body)
        buildResponse = buildFeatureToggles(result.items)
        message.send buildResponse

  robot.respond /launchdarkly list$/i, (message) ->
    message.http("https://app.launchdarkly.com/api/v2/flags/default")
      .header('User-Agent', 'Hubot')
      .header('Authorization', apiToken)
      .get() (err, response, body) ->
        if response.statusCode isnt 200
          message.send "Request didn't come back HTTP 200 :("
          return
        result = JSON.parse(body)
        buildResponse = buildFeatureToggles(result.items)
        message.send buildResponse
