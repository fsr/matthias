-- Description:
--   geruecht

-- Dependencies:
--   None

-- Configuration:
--   None

-- Commands:
--   hubot gerücht - Lass' hubot aus dem Nähkästchen plaudern

-- Author:
--   kiliankoe

-- cheerio = require 'cheerio'

module Geruecht where

import Marvin.Prelude
import System.Environment
import Network.Wreq
import Control.Lens


script = defineScript "gerücht" $ do
    respond (r [CaseInsensitive] "geruecht|gerücht") $ do
      user <- requireConfigVal "username"
      pw = requireConfigVal "password"
      r <- get $ "http://" ++ user ++ ":" ++ pw ++ "@leaks.fsrleaks.de/index.php"
        .get() (err, res, body) ->
            $ = cheerio.load body
            geruecht = $('div').text().replace /Psst\.\.\./, ""
            geruecht = geruecht.trim()
            geruecht = msg.random(prefixes) + geruecht
            msg.send geruecht

prefixes = [
    "Also... Ich hab ja Folgendes gehört: ",
    "Pssht... ",
    "Ein kleines Vögelchen hat mir das hier verraten: ",
    "Die BILD Zeitung soll ja das hier morgen als Titelstory haben: ",
    "Böse Zungen behaupten ja: ",
    "Bei Fefe stand letzte Woche: ",
    "Also bei Sebi in der BRAVO Girl stand ja letztens: "
]
