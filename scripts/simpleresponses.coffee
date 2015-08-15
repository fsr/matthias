# Description:
#   Einfache trigger-response Interaktionen
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot pizza - hubot nennt alle Details für eine Pizzabestellung (im Ratsaal)
#   hubot filmlist - Frag' hubot nach Links zu beiden Filmlisten
#
#
# Author:
#   kiliankoe



simpleresponses = [
  [
    /pizza/i,
    "Ich bin Matthias Stuhlbein, Nöthnitzer Str. 46, 01187 Dresden. Fakultät Informatik. Mail: pizza@ifsr.de, Telefon: 0351 46338223 - Pizzen schneiden nicht vergessen ;)"
  ],
  [
    /filmlist/i,
    "Vorschläge: http://letterboxd.com/kiliankoe/list/ifsr-filmvorschlage/\nGeschaute Filme: http://letterboxd.com/kiliankoe/list/ifsr-movie-night/"
  ],
  [
    /wat is wacken\?/i,
    "Dat ist Wacken. Einmal im Jahr kommen hier alle bösen schwarzen Männer aus Mittelerde her, um ma richtig die Sau rauszulassen."
  ]
]

simplelistens = [
  [/pimmel/i, "Höhöhö, du hast Pimmel gesagt."],
  [/anyway/i, "how's your sex life?"],
  [/jehova/i, "http://i.imgur.com/01PMBGj.gif"],
  [/frau/i, ":lucas: Eh? :point_up:"],
  [/muss man wissen|fefe|sascha lobo|axel stoll/, "http://i.imgur.com/FmEyA8t.png"],
  [/schuh/, ":shoe::shoe:? Liegen wahrscheinlich noch bei Ben daheim."],
  [/you're tearing me apart|the room|tommy wiseau/, "http://i.giphy.com/pTrgmCL2Iabg4.gif"],
  [/citrix|35000|35\.000|35k/, ":moneybag::moneybag::moneybag:"],
  [/madness/i, "Madness you say? THIS. IS. PATRI... MATTHIAS!"],
  [/^nein$/i, "Doch!"],
  [/\sphp|^php/, "Naja, ich hab mit PHP auch schon richtig gut funktioni⍰\nParse error: syntax error, unexpected '::' (T_PAAMAYIM_NEKUDOTAYIM) in Command line code on line 1"],
  [/gewitter/i, "Gewitter? In Neuss?"]
]


module.exports = (robot) ->

  simplelistens.forEach (resp_tuple) ->
    [trigger, answer] = resp_tuple
    robot.hear trigger, (msg) ->
      msg.send answer

  simpleresponses.forEach (resp_tuple) ->
    [trigger, answer] = resp_tuple
    robot.respond trigger, (msg) ->
      msg.send answer
