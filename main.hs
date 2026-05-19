import qualified Data.Map.Strict as Map
import Data.List (group, sort, sortBy)
import Data.Ord (comparing)
import Data.Char (toLower, isPunctuation)

-- ==========================================
-- TYPE DEFINITIONS
-- ==========================================
type DocId = Int
type TermFrequency = Int
type InvertedIndex = Map.Map String [(DocId, TermFrequency)]

-- ==========================================
-- PHASE 1: Data Normalization (Cleaning)
-- ==========================================
cleanText :: String -> String
cleanText = map toLower . filter (not . isPunctuation)

-- ==========================================
-- PHASE 2: Tokenization (Bag-of-Words)
-- ==========================================
wordCount :: String -> [(String, Int)]
wordCount = map (\ws -> (head ws, length ws)) . group . sort . words . cleanText

-- ==========================================
-- PHASE 3: Indexing (The Inverted Index)
-- ==========================================
-- This phase runs once in the "backend" to pre-calculate word locations
buildIndex :: [(DocId, String)] -> InvertedIndex
buildIndex docs = 
    let 
        -- 1. Extract words and frequencies for each document
        analyzedDocs = map (\(dId, text) -> (dId, wordCount text)) docs
        
        -- 2. Flatten everything so the Word is the first element
        flattened = [ (word, [(dId, freq)]) 
                    | (dId, wordCounts) <- analyzedDocs
                    , (word, freq) <- wordCounts ]
    in 
        -- 3. Build the map. Merging lists for words that appear in multiple docs.
        Map.fromListWith (++) flattened

-- ==========================================
-- PHASE 4: Search Engine Logic (Query & Rank)
-- ==========================================
-- This phase runs instantly for the user, completely skipping unneeded documents
searchIndex :: InvertedIndex -> String -> [(DocId, Int)]
searchIndex index query = 
    let 
        queryWords = words (cleanText query)
        
        -- Instantly fetch the document lists for our search words
        matches = map (\w -> Map.findWithDefault [] w index) queryWords
        allMatchedDocs = concat matches
        
        -- Group by DocId and sum the frequency scores
        unsortedResults = Map.toList (Map.fromListWith (+) allMatchedDocs)
    in 
        -- Sort by score in descending order
        reverse (sortBy (comparing snd) unsortedResults)

-- ==========================================
-- PHASE 5: Application Execution
-- ==========================================
main :: IO ()
main = do
    -- Simulated Database of Web Documents (Now mapped with Document IDs)
    let rawDocs = [ (1, "Haskell is pure. Haskell is great for data.")
                  , (2, "Data science is fun. Python is used for data.")
                  , (3, "Haskell is pure functional programming. It is fun!") 
                  ]
    
    -- "Backend": Build the index from the raw documents
    let index = buildIndex rawDocs
    
    -- "Frontend": User submits a query
    let query = "Haskell Data"
    let results = searchIndex index query

    -- Explicitly formatting the output for real-world context
    putStrLn "\n======================================================"
    putStrLn "  REAL-WORLD NLP: INVERTED INDEX SEARCH ENGINE"
    putStrLn "======================================================"
    
    putStrLn "\n[1] INDEXING DATABASE DOCUMENTS..."
    mapM_ (\(dId, text) -> putStrLn $ "  -> Doc " ++ show dId ++ ": " ++ text) rawDocs
    
    putStrLn "\n[2] PROCESSING SEARCH QUERY..."
    putStrLn ("  -> User searched for: '" ++ query ++ "'")
    
    putStrLn "\n[3] EXTRACTING AND RANKING RESULTS VIA INVERTED INDEX..."
    putStrLn "------------------------------------------------------"
    putStrLn " DOC ID | SCORE"
    putStrLn "------------------------------------------------------"
    
    -- Print each result on a new line
    mapM_ (\(dId, score) -> putStrLn $ "   " ++ show dId ++ "    |   " ++ show score) results
    putStrLn "======================================================\n"