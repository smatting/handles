module Toy.Database.Postgres where

import RIO
import RIO.Text
import System.IO (putStrLn)
import Toy.Database
import qualified Toy.Database as Database
import Toy.Types
import UnliftIO.Exception (bracket)

new :: PostgresConn -> IO Database.Handle
new conn = do
  let createUser = \name -> do
        pure $ User name 0
  pure $ Database.Handle createUser

withDatabase :: (Database.Handle -> IO a) -> IO a
withDatabase f =
  bracket
    ( do
        -- open connection
        putStrLn "connecting to PG"
        conn <- pure PostgresConn
        pure conn
    )
    ( \conn -> do
        putStrLn "closing connection"
        pure () -- close connection
    )
    ( \conn -> do
        handle <- new conn
        f handle
    )
