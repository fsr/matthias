docker run -d --name matthias \
		-e FSRUSERNAME='' \
		-e FSRPASSWORD='' \
		-e HUBOT_ALIAS='!' \
		-e HUBOT_FORECAST_API_KEY='' \
		-e HUBOT_WEATHER_CELSIUS='1' \
		-e HUBOT_GOOGLE_CSE_ID='' \
		-e HUBOT_GOOGLE_CSE_KEY='' \
		-e HUBOT_SLACK_TOKEN='' \
		-e HUBOT_MAINTAINERS='shell,kilian' \
		ifsr/matthias -a slack
