-- Description:
--   Der Techniker ist informiert.
-- Dependencies:
--   None

-- Configuration:
--   None

-- Commands:
--   hubot türstatus - hubot schaut nach, wie es um die Tür des APB steht.
--   hubot ist die tür kaputt? - hubot schaut nach, wie es um die Tür des APB steht.
--   hubot glasschaden - teile hubot mit, dass die Tür mal wieder im Eimer ist.
--   hubot rate mal, was wieder kaputt ist - teile hubot mit, dass die Tür mal wieder im Eimer ist.
--   hubot techniker ist informiert - teile hubot mit, dass die Tür mal wieder im Eimer ist.
--   hubot tür ist wieder ganz - teile hubot mit, dass die Tür wieder ganz ist
--   hubot tür ist weg - teile hubot mit, dass die Tür sich in einem unbekannten Status befindet.

-- Author:
--   kiliankoe
{-# LANGUAGE MultiWayIf #-}
module Apbdoor (script) where


import Marvin.Prelude
import Network.Wreq
import Control.Lens


script :: IsAdapter a => ScriptInit a
script = defineScript "apbdoor" $ do
  respond (r [CaseInsensitive] "türstatus|tuerstatus|ist die tür kaputt\\?|ist die tuer kaputt\\?") $
    checkDoor

  respond (r [CaseInsensitive] "glasschaden|rate mal, was wieder kaputt ist|techniker ist informiert") $ do
    setDoor "yes"
    send "Orr ne, schon wieder?!"

  respond (r [CaseInsensitive] "tür ist wieder ganz|tuer ist wieder ganz") $ do
    setDoor "no"
    send "/giphy party"

  respond (r [CaseInsensitive] "tür ist weg|tuer ist weg") $ do
    setDoor "maybe"
    send "Ähm... Ahja?"


checkDoor :: IsAdapter a => BotReacting a MessageReactionData ()
checkDoor = do
  r <- liftIO $ get "http://tuer.fsrleaks.de"
  
  let body = r^.responseBody
  -- TODO Add random
  if 
    | "Ja" `isInfixOf` body -> randomFrom yesMsgs >>= send
    | "Nein" `isInfixOf` body -> randomFrom noMsgs >>= send
    | otherwise -> randomFrom maybeMsgs >>= send


setDoor state = liftIO $ get (unpack $ format "http://door.fsrleaks.de/set.php?{}" [state :: Text])

yesMsgs = 
  [ "Jop, Tür ist im Eimer."
  , "Tür ist 'putt."
  , "Rate mal..."
  , "Alles im Arsch, Normalzustand halt."
  , "Computer sagt: Tür ist hin."
  , "Tür pass auf!! Du hast ne Scheibe verloren!"
  , "Techniker ist selbstverständlich bereits informiert."
  ]

noMsgs = 
  [ "Die Tür ist... ganz?!"
  , "Alles im grünen Bereich."
  , "Sie ist ganz! Also... Zumindest gerade eben. Vermutlich schon nicht mehr."
  , "Rufe Fr. Kapplusch an... Nop, scheint alles gut zu sein. Beeindruckend."
  , "Hab' eben nachgesehen und... Ausnahmezustand!"
  ]

maybeMsgs = 
  [ "Ich hab keine Ahnung ¯\\_(ツ)_/¯"
  , "Sorry, musst du dieses Mal selber nachschauen."
  , "Quizás, señor/a."
  , "Sorry, no clue."
  , "Schrödingers Tür?"
  , "Lässt sich aus diesem Blickwinkel schlecht beurteilen."
  ]
