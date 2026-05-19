import qualified Data.Map as Map

type InvertedIndex = Map.Map String [(Int, Int)]

-- Pre-calculated search engine index
myIndex :: InvertedIndex
myIndex = Map.fromList [ ("haskell", [(1, 2), (3, 1)])  -- Haskell is in Doc 1 (score 2) and Doc 3 (score 1)
                       , ("data",    [(1, 1), (2, 2)])  -- Data is in Doc 1 (score 1) and Doc 2 (score 2)
                       , ("python",  [(2, 1)])          -- Python is only in Doc 2
                       ]