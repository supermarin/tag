module Vim where

import EditorPosition

vimEditCommand :: String -> (Line, Column) -> String
vimEditCommand path (line, column) = "eval '$EDITOR "
  ++ "\\\"" ++ path ++ "\\\""
  ++ " \\\"+" ++ show line ++ "\\\"'"
