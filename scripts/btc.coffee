# Description:
#   BTC Krams
#
# Commands:
#   hubot btc - Aktueller Bitcoin Kurs in USD und EUR
#
# Author:
#   kiliankoe

module.exports = (robot) ->
  robot.respond /btc/i, (msg) ->
    robot.http('https://api.coinbase.com/v2/exchange-rates?currency=BTC')
      .get() (err, res, body) ->
        data = JSON.parse body
        USD = data["data"]["rates"]["USD"]
        EUR = data["data"]["rates"]["EUR"]
        msg.send("Aktueller BTC Kurs: " + USD + "$ oder " + EUR + "€")
        msg.send("http://bitcoincharts.com/charts/chart.png?width=940&m=bitstampUSD&SubmitButton=Draw&r=10&i=&c=0&s=&e=&Prev=&Next=&t=M&b=&a1=SMA&m1=10&a2=&m2=25&x=0&i1=&i2=&i3=&i4=&v=0&cv=0&ps=0&l=0&p=0&")
