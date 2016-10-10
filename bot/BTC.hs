-- Description:
--   BTC Krams

-- Dependencies:
--   None

-- Configuration:
--   None

-- Commands:
--   hubot btc - Frag' hubot nach dem aktuellem BTC Kurs

-- Author:
--   kiliankoe
module BTC where

import Marvin.Prelude
import Network.Wreq
import Control.Lens
import Data.Aeson.Lens
import Data.Aeson

script :: IsAdapter a => ScriptInit a
script = defineScript "btc" $
    respond (r [CaseInsensitive] "btc/") $ do
        r <- liftIO $ get "https://api.coinbase.com/v2/exchange-rates?currency=BTC"
        case eitherDecode' (r^.responseBody) :: Either String Value of
            Left err -> errorM $ "Unreadable json" ++ pack err
            Right data_ -> do
                let usd = data_ ^?! key "data" . key "rates" . key "USD" . _Double
                let eur = data_ ^?! key "data" . key "rates" . key "EUR" . _Double
                send $ toStrict $ format "Aktueller BTC Kurs: {}$ oder {}€" (usd, eur)
                send "http://bitcoincharts.com/charts/chart.png?width=940&m=bitstampUSD&SubmitButton=Draw&r=10&i=&c=0&s=&e=&Prev=&Next=&t=M&b=&a1=SMA&m1=10&a2=&m2=25&x=0&i1=&i2=&i3=&i4=&v=0&cv=0&ps=0&l=0&p=0&"
