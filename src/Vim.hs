module Vim where

import EditorPosition

vimEditCommand :: String -> (Line, Maybe Column) -> String
vimEditCommand path (Line line, Just (Column column)) = "vim "
  ++ "\\\"" ++ path ++ "\\\""
  ++ " \\\"+call cursor(" ++ show line ++ ", " ++ show column ++ ")\\\""
vimEditCommand path (Line line, Nothing) = "vim "
  ++ "\\\"" ++ path ++ "\\\""
  ++ " +" ++ show line
