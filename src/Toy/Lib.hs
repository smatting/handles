module Toy.Lib where

import Data.Has
import RIO
import qualified Toy.Database as Database
import qualified Toy.Database.Postgres as Postgres
import qualified Toy.Logger as Logger

program ::
  ( Has Database.Handle e,
    Has Logger.Handle e
  ) =>
  RIO e ()
program = do
  user <- Database.createUser "bob"
  Logger.log ("User create: " <> show user)
  pure ()

main = do
  let logger = Logger.new
  Postgres.withDatabase $ \db ->
    runRIO (db, logger) program
