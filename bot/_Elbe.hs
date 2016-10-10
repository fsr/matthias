-- Description:
--   Aktueller Elbpegel der Station Dresden

-- Dependencies:
--   None

-- Configuration:
--   None

-- Commands:
--   hubot elbpegel - gibt den aktuellen Elbpegel der Station Dresden aus

-- Author:
--   dirkonet
module Elbe where


import Network.Wreq
import Control.Lens
import Data.Text (justifyRight)
import Data.Time


script = defineScript "elbe" $ do
    respond (r [CaseInsensitive] "elbpegel|elbe") $ checkPegel

checkPegel = do
    r <- liftIO $ getWith (defaults & header "Accept" .~ ["application/json"]) "http://www.pegelonline.wsv.de/webservices/rest-api/v2/stations/DRESDEN/W/measurements.json?start=P0DT0H15M"

    
    case eitherDecode' (r ^. responseBody) of
        Left err -> errorM (pack err)
        Right value -> do
            let ts = ModifiedJulianDay $ value ^?! nth 0 . key "timestamp"
            let (year, month, day) = toGregorian ts
            let date = format "#{fuckinjsdatetime(ts.getDate())}.#{fuckinjsdatetime(ts.getMonth())}.#{ts.getFullYear()} #{fuckinjsdatetime(ts.getHours())}:#{fuckinjsdatetime(ts.getMinutes())} Uhr"
            send "Aktueller Elbpegel, Stand #{date}: #{data[0].value}cm\nhttp://www.pegelonline.wsv.de/webservices/rest-api/v2/stations/DRESDEN/W/measurements.png?start=P7D&width=900&height=400"

fuckinjsdatetime = justifyRight 2 '0' . pack . show
