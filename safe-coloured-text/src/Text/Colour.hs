-- | Safe Coloured Text
--
-- This module is responsible for defining, building, and rendering coloured text.
--
-- The text to be coloured is 'Text', but the rendered text, while technically still (probably) valid Utf8, will be a 'ByteString' builder.
module Text.Colour
  ( -- * Building chunks
    chunk,
    Chunk (..),

    -- ** Styling

    -- *** Setting colour

    --
    -- These will only be rendered if the given 'TerminalCapabilities' supports them.
    fore,
    back,

    -- *** Setting non-colour attributes

    --
    -- These will be rendered for any 'TerminalCapabilities'
    bold,
    faint,
    italic,
    underline,
    doubleUnderline,

    -- ** Colours
    Colour (..),

    -- *** 8-colour

    -- **** Dull
    black,
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    white,

    -- **** Bright
    brightBlack,
    brightRed,
    brightGreen,
    brightYellow,
    brightBlue,
    brightMagenta,
    brightCyan,
    brightWhite,

    -- *** 8-bit
    color256,
    colour256,

    -- *** 24-bit
    colorRGB,
    colourRGB,

    -- * Rendering

    -- ** Rendering chunks to bytestring builders
    renderChunks,
    renderChunk,

    -- ** Rendering chunks to strict bytestring
    renderChunksBS,
    renderChunkBS,

    -- * IO
    TerminalCapabilities (..),

    -- ** Outputting chunks directly
    putChunksWith,
    hPutChunksWith,
  )
where

import qualified Data.ByteString.Builder as SBB
import System.IO
import Text.Colour.Capabilities
import Text.Colour.Chunk

-- | Print a list of chunks to stdout with given 'TerminalCapabilities'.
putChunksWith :: TerminalCapabilities -> [Chunk] -> IO ()
putChunksWith tc = hPutChunksWith tc stdout

-- | Print a list of chunks to the given 'Handle' with given 'TerminalCapabilities'.
hPutChunksWith :: TerminalCapabilities -> Handle -> [Chunk] -> IO ()
hPutChunksWith tc h cs = SBB.hPutBuilder h $ renderChunks tc cs
