module LineTypeTests (allLineTypeTests) where

import EditorPosition
import LineType
import Test.HUnit

testGetLocationFromIndexesWithColumn :: Test
testGetLocationFromIndexesWithColumn = TestCase $
  assertEqual "Indexes should generate Location with column"
  (getLocationFromIndexes [1, 2])
  (Just $ Location (Line 1) (Just (Column 2)))

testGetLocationFromIndexesWithoutColumn :: Test
testGetLocationFromIndexesWithoutColumn = TestCase $
  assertEqual "Indexes should generate Location without column"
  (getLocationFromIndexes [1])
  (Just $ Location (Line 1) Nothing)

allLineTypeTests :: [Test]
allLineTypeTests = [
    testGetLocationFromIndexesWithColumn
  , testGetLocationFromIndexesWithoutColumn
  ]
