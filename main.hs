import Data.List (group, sort, sortBy)
import Data.Ord (comparing)
import Data.Char (toLower, isPunctuation)

-- =====================================================================
-- REAL WORLD MACHINE PROBLEM: NLP Search Engine Document Ranking
-- LANGUAGE: Haskell
-- OBJECTIVE: Clean raw text, tokenize it, and rank documents by relevance
-- =====================================================================

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
-- PHASE 3: Information Retrieval (Scoring)
-- ==========================================
getQueryScore :: String -> [(String, Int)] -> Int
getQueryScore query docFrequencies = 
    let 
        queryWords = words (cleanText query) 
        getSingleWordScore word = 
            case lookup word docFrequencies of
                Just count -> count
                Nothing    -> 0
    in sum (map getSingleWordScore queryWords)

-- ==========================================
-- PHASE 4: Search Engine Logic (Ranking)
-- ==========================================
rankDocuments :: String -> [String] -> [(Int, String)]
rankDocuments query docs = 
    let 
        docFrequencies = map wordCount docs
        scores = map (getQueryScore query) docFrequencies
        scoredDocs = zip scores docs
        matchedDocs = filter (\(score, _) -> score > 0) scoredDocs
    in reverse (sortBy (comparing fst) matchedDocs)

-- ==========================================
-- PHASE 5: Application Execution
-- ==========================================
main :: IO ()
main = do
    -- Simulated Database of Web Documents
    let doc1 = "Haskell is pure. Haskell is great for data." 
    let doc2 = "Data science is fun. Python is used for data." 
    let doc3 = "Haskell is pure functional programming. It is fun!" 
    
    let query = "Haskell Data"
    let results = rankDocuments query [doc1, doc2, doc3]

    -- Explicitly formatting the output for real-world context
    putStrLn "\n======================================================"
    putStrLn "  REAL-WORLD NLP APPLICATION: SEARCH ENGINE SIMULATOR"
    putStrLn "======================================================"
    
    putStrLn "\n[1] SCANNING DATABASE DOCUMENTS..."
    putStrLn ("  -> Doc A: " ++ doc1)
    putStrLn ("  -> Doc B: " ++ doc2)
    putStrLn ("  -> Doc C: " ++ doc3)
    
    putStrLn "\n[2] PROCESSING SEARCH QUERY..."
    putStrLn ("  -> User searched for: '" ++ query ++ "'")
    
    putStrLn "\n[3] EXTRACTING, SCORING, AND RANKING RESULTS..."
    putStrLn "------------------------------------------------------"
    putStrLn " RANK | SCORE | DOCUMENT TEXT"
    putStrLn "------------------------------------------------------"
    
    -- Print each result on a new line for maximum readability
    mapM_ print results
    putStrLn "======================================================\n"