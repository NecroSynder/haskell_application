# Haskell NLP Search Engine Simulator

## Overview:
This program is a lightweight, real-world simulation of a Natural Language Processing (NLP) search engine. Written in Haskell, it demonstrates core data processing pipelines used in information retrieval systems: data normalization, tokenization (Bag-of-Words), scoring, and ranking.

**Dependencies:**
The module relies on standard Haskell libraries for list manipulation, ordering, and character evaluation:
- `Data.List` (`group`, `sort`, `sortBy`)
- `Data.Ord` (`comparing`)
- `Data.Char` (`toLower`, `isPunctuation`)

## Function Reference

**Phase 1: Data Normalization (Cleaning)**
`cleanText :: String -> String`

This prepares raw text for analysis by standardizing its format. It strips out all punctuation marks and converts the entire string to lowercase. This ensures that words like "Haskell!", "Haskell", and "haskell" are treated as the exact same token.

**Phase 2: Tokenization (Bag-of-Words)**
`wordCount :: String -> [(String, Int)]`

This converts a cleaned string into a *Bag-of-Words* frequency map.
- **Process:** It cleans the input string, splits it into individual words, sorts them alphabetically, groups identical words together, and finally counts the length of each group.
- **Output:** Returns a list of tuples containing the tokenized word and its frequency count (e.g., `[("data", 2), ("haskell", 2)]`).

**Phase 3: Information Retrieval (Scoring)**
`getQueryScore :: String -> [(String, Int)] -> Int`

It calculates a relevance score for a single document against a user's search query.

- **Process:** It normalizes the query using `cleanText` and splits it into individual search terms. For each term, it looks up its frequency in the document's `docFrequencies` list. It then sums the frequencies of all matched terms to generate a final score.
- `Output:` An integer representing the total number of times any of the query words appeared in the document.

**Phase 4: Search Engine Logic (Ranking)**
`rankDocuments :: String -> [String] -> [(Int, String)]`

The core search engine logic that evaluates and ranks a list of documents based on a user's query.

- Process: 
  -  Converts all raw documents into frequency maps.
  - Scores each document against the query.
  - Pairs the raw document text with its calculated score.
  - Filters out any documents with a score of `0` (irrelevant documents).
  - Sorts the remaining documents in descending order (highest score first).
- Output: 
  - A list of tuples containing the score and the corresponding document string, ordered by relevance.

**Application Execution (`main`)**
`main :: IO ()`

The entry point of the application. It sets up a simulated database of three web documents and executes a search for the query `"Haskell Data"`. It then prints a highly readable, formatted CLI interface displaying the scanning process, the query, and the final ranked results.

**Simulated Database:**
- Doc 1: "Haskell is pure. Haskell is great for data."
- Doc 2: "Data science is fun. Python is used for data."
- Doc 3: "Haskell is pure functional programming. It is fun!"

**Expected Output:**
When compiled and run, the program will output the documents scored and ranked based on how many times "haskell" and "data" appear in them. Doc 1 will rank highest (score of 3), followed by Doc 2 (score of 2 for "data"), and Doc 3 (score of 1 for "haskell").