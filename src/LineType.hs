module LineType (LineType(..), getOutputType) where

import Control.Monad (msum)
import Data.Char (isDigit)
import Data.Maybe (fromMaybe, listToMaybe, mapMaybe)
import EditorPosition
import Regex (getCaptureGroups)

data LineType = Location Line Column | FilePath String | Other
  deriving (Show)

instance Eq LineType where
  (==) (Location line1 column1)
       (Location line2 column2) = line1 == line2 && column1 == column2
  (==) (FilePath path1) (FilePath path2) = path1 == path2
  (==) Other Other = True
  (==) _ _ = False

getOutputType :: String -> LineType
getOutputType line = fromMaybe Other
                               (msum $ map ($ line) [getLocation, getFilePath])

getLocation :: String -> Maybe LineType
getLocation line =
  if length matches == 2 && length indexes == 2
    then Just $ Location (Line $ head indexes) (Column $ indexes !! 1)
    else Nothing
  where matches = getCaptureGroups line "^(?:\x1b\\[[^m]+m)?(\\d+)(?:\x1b\\[0m\x1b\\[K)?:(\\d+):"
        indexes = mapMaybe toNum matches

getFilePath :: String -> Maybe LineType
getFilePath line =
  case listToMaybe matches of
    Just path -> Just $ FilePath path
    Nothing -> Nothing
  where matches = getCaptureGroups line "^(?:\x1b\\[[^m]+m)?([^\x1b]+)(?:\x1b\\[0m\x1b\\[K)?"

toNum :: String -> Maybe Int
toNum string = if all isDigit string
  then Just $ read string
  else Nothing
