-- Description:
--   Happy Birthday \o/

-- Dependencies:
--   None

-- Configuration:
--   None

-- Commands:
--   hubot birthday? - Who's is the next upcoming birthday?
--   hubot birthday <name> - When's <name>'s birthday?
--   hubot birthday list - List all known birthdays.

-- Author:
--   kiliankoe
--   Justus Adam <me@justus.science>

-- fs = require('fs')
-- cronjob = require("cron").CronJob
-- moment = require('moment')
-- moment.locale('de_DE')

module BDay where

import Marvin.Prelude
import Marvin.Util.JSON
import Data.Time
import System.Cron
import Data.Text (toTitle)

dontShow = 1900


type Birthdays = HashMap Text Day


script :: IsAdapter a => ScriptInit a
script = defineScript "bday" $ do
    bdayFile <- liftIO $ readFile "bdays.json" 
    bdays <- case eitherDecode' bdayFile of
                Left err -> do 
                    errorM $ "could not read bdays.json: " ++ pack err
                    return mempty
                Right b -> return b

    congratulate <- extractAction $
        for_ (mapToList (bdays :: Birthdays)) $ \(name, bday) -> do
            today <- liftIO getCurrentTime
            let 
                (year, month, day) = toGregorian $ utctDay today
                (bDayYear, bDayMonth, bDayDay) = toGregorian bday
            when (bDayMonth == month && day == bDayDay) $ messageRoom "#random" $ toStrict $ format ":tada: Alles Gute zum Geburtstag, {}! :tada:" [toUpper name]
    
    void $ liftIO $ execSchedule $ do
        addJob congratulate "00 00 9 * * *"    

    respond (r [CaseInsensitive] "(birthday|bday|geburtstag)\\??$") $ do
        today <- utctDay <$> liftIO getCurrentTime
        let 
            (yearToday, _, _) = toGregorian today 
            vallist = flip mapWithKey bdays $ \ name value -> do
                let 
                    (_, bdayMonth, bdayDay) = toGregorian value
                    date = fromGregorian yearToday bdayMonth bdayDay
                if date < today
                    then addGregorianYearsRollOver 1 date
                    else date
        
            date = minimumEx $ map snd $ mapToList vallist

            birthdayBoysAndGirls = map (toUpper . fst) $ filter ((== date)  . snd) $ mapToList vallist

            daysDiff = diffDays today date 
            last_ = lastEx birthdayBoysAndGirls

            diffStr
                | daysDiff == 0 = "heute!"
                | otherwise = toStrict $ format "in nur {} Tagen." [daysDiff]

            msgStr
                | length birthdayBoysAndGirls == 1 = toStrict $ format "Das nächste Geburtstagskind ist {}" [headEx birthdayBoysAndGirls]
                | otherwise = "Die nächsten Geburstage sind von " ++ intercalate ", " (initEx birthdayBoysAndGirls) ++ " und " ++ last_
        send $ msgStr ++ " " ++ diffStr

    respond (r [CaseInsensitive] "(birthday|bday|geburtstag) (.+)") $ do
        (_:name':_) <- getMatch
        let name = toLower name
        
        case name of
            -- Looks like we're going for the list below...
            "list" -> return ()
            "liste" -> return ()
            _ ->  case lookup name bdays of
                    Just bday -> formatBirthdayInfo name bday >>= send
                    Nothing -> send $ toStrict $ format "Sorry, ich kenne keinen Geburtstag von {}." [name]

    respond (r [CaseInsensitive] "(birthday|bday|geburtstag) list(e?)") $ do
        send "Ich kenne folgende Geburtstage:"
        for_ (mapToList bdays) $ \(key, value) ->
            formatBirthdayInfo key value >>= send


formatBirthdayInfo :: MonadIO m => Text -> Day -> m Text
formatBirthdayInfo name birthday
    | birthdayYear == dontShow = return $ toStrict $ format "{} hat am {}.{}. Geburtstag." (toTitle name, birthdayDay, birthdayMonth)
    | otherwise = do
        today <- utctDay <$> liftIO getCurrentTime
        let (age, _, _) = toGregorian $ ModifiedJulianDay $ diffDays today birthday 
        return $ toStrict $ format "{} wurde am {}.{}. geboren. Das war vor {} Jahren! :O" (toTitle name, birthdayDay, birthdayMonth, age)          
  where
    (birthdayYear, birthdayMonth, birthdayDay) = toGregorian birthday
