{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Text.Colour.Layout where

import Data.List
import qualified Data.Text as T
import GHC.Generics (Generic)
import Text.Colour

layoutAsTable :: [[Chunk]] -> [Chunk]
layoutAsTable cs = renderTable $ Table {tableCells = padRows cs}

padRows :: [[Chunk]] -> [[Chunk]]
padRows [] = []
padRows css =
  let withLengths = map (\ls -> (length ls, ls)) css
      maximumLength = maximum $ map fst withLengths
      pad (l, cs) = cs ++ replicate (maximumLength - l) ""
   in map pad withLengths

data Table = Table
  { -- | A list of rows. They must be of the same length.
    tableCells :: [[Chunk]]
  }
  deriving (Show, Eq, Generic)

-- TODO spacing
-- TODO single-colour background
-- TODO bicolour background

renderTable :: Table -> [Chunk]
renderTable Table {..} =
  let asColumns = transpose tableCells
      addLengthsToColumn :: [Chunk] -> [(Int, Chunk)]
      addLengthsToColumn = map (\c -> (T.length (chunkText c), c))
      maxLengthOfColum :: [(Int, Chunk)] -> Int
      maxLengthOfColum = maximum . map fst
      padColumn :: Int -> [(Int, Chunk)] -> [(Chunk, Chunk)]
      padColumn maxLength = map (\(l, c) -> (c, paddingChunk (maxLength - l)))
      padEntireColumn :: [(Int, Chunk)] -> [(Chunk, Chunk)]
      padEntireColumn col =
        let maxLength = maxLengthOfColum col
         in padColumn maxLength col
      paddedColumns :: [[(Chunk, Chunk)]]
      paddedColumns = map (padEntireColumn . addLengthsToColumn) asColumns
      paddedRows :: [[(Chunk, Chunk)]]
      paddedRows = transpose paddedColumns
      renderRow :: [(Chunk, Chunk)] -> [Chunk]
      renderRow [] = ["\n"]
      renderRow [(c, p)] = c : p : renderRow []
      renderRow ((c1, p1) : t2 : rest) = c1 : p1 : " " : renderRow (t2 : rest)
   in concatMap renderRow paddedRows

paddingChunk :: Int -> Chunk
paddingChunk l = chunk $ T.pack $ replicate l ' '
