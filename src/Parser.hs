module Parser (handleOutputLine) where

import Alias (aliasForCommand)
import LineType
import System.IO (Handle, hPutStrLn)
import Vim (vimEditCommand)

-- This function takes a output file handle, a line of output from the program
-- that the output is being parsed from, a piece of context about the current
-- index of matches, and the last FilePath line.
-- It parses the new output line to determine its type, and prints it to the
-- screen, returning a new context to be used for future calls.
-- If the LineType is a FilePath, the context is updated, if the line is a new
-- search location, the index is updated, and the location alias is written to
-- the output file handle. Otherwise the line is just printed to the screen.
-- This function does not handle if there are search matches before FilePath
-- matches.
handleOutputLine :: Handle -> String -> Maybe (Int, LineType) -> IO (Maybe (Int, LineType))
handleOutputLine writer line (Just (index, FilePath path)) = do
  let output = getOutputType line
  case output of
    FilePath newPath -> do
      putStrLn line
      return $ Just (index, FilePath newPath)
    Other -> do
      putStrLn line
      return $ Just (index, FilePath path)
    Location lnum cnum -> do
      putStrLn $ formatLocationLine index line
      hPutStrLn writer
        $ aliasForCommand (index, vimEditCommand path (lnum, cnum))
      return $ Just (index + 1, FilePath path)
handleOutputLine _ line (Just (index, _)) = do
  putStrLn line
  return $ Just (index, getOutputType line)
handleOutputLine _ line Nothing = do
  putStrLn line
  return $ Just (1, getOutputType line)

formatLocationLine :: Int -> String -> String
formatLocationLine index line =
  "[\x1b[0;31m" ++ show index ++ "\x1b[0m] " ++ line
