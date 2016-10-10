-- Description:
--   Dr. Sommer

-- Dependencies:
--   None

-- Configuration:
--   None

-- Commands:
--   Dr. Sommer, ich hab da mal ne Frage - Stelle eine anonyme Frage in #dr_sommer

-- Author:
--   kiliankoe
module DrSommer where

import Marvin.Prelude
import Data.Text (replace)


script :: IsAdapter a => ScriptInit a
script = defineScript "drsommer" $ do
    hear (r [CaseInsensitive] "^(hey |hallo |lieber )?dr\\.? sommer,?") $ do
        msg <- getMessage
        name <- randomFrom names
        i <- randomValFromRange (10, 15)
        messageRoom "#dr_sommer" $ toStrict $ format "\"{}\" - {} ({})" (content msg, name, i :: Int)

    -- help matthias respond to priv messages as well
    respond (r [CaseInsensitive] "(hey |hallo |lieber )?dr\\.? sommer,?") $ do
        msg <- getMessage
        let question = replace (content msg) "matthias " ""
        name <- randomFrom names
        i <- randomValFromRange (10, 15)
        messageRoom "#dr_sommer" $ toStrict $ format "\"#{}\" - {} ({})" (question, name, i :: Int)


names :: [Text]
names = [
    "Shantalle",
    "Schackeline",
    "Tamara",
    "Cindy",
    "Jenny",
    "Clair-Gina",
    "Justin",
    "Jerome",
    "Chantal",
    "Jacqueline",
    "Yves",
    "Sylvia",
    "Claudia",
    "Dörte"
    ]
