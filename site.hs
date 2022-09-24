{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           Data.Maybe (catMaybes, fromMaybe)
import           Text.Pandoc (writerExtensions, readerExtensions, enableExtension, Extension(Ext_footnotes))
import           Debug.Trace (traceShowId, trace)
import           Data.Foldable (find)
import           Control.Applicative (empty)
import           Data.Char (toLower)


myPandocCompiler = pandocCompiler
-- Turns out the footnotes extension is enabled by default, but preserving this in case I want to add a different extension someday
-- myPandocCompiler = pandocCompilerWith ro wo
--   where
--       ro = defaultHakyllReaderOptions
--       defaultWriterExtensions = writerExtensions defaultHakyllWriterOptions 
--       defaultReaderExtensions = readerExtensions defaultHakyllReaderOptions
--       wo = defaultHakyllWriterOptions {writerExtensions = enableExtension Ext_footnotes defaultWriterExtensions, readerExtensions = enableExtension Ext_footnotes defaultReaderExtensions}


main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    create ["atom.xml"] $ do
        route idRoute
        compile $ do
            all <- recentFirst =<<
                loadAllSnapshots "posts/*" "content"
            nonDraft <- nonDrafts all
            let recent = (take 10) nonDraft
            renderAtom feedConfiguration feedCtx recent

    match "posts/*" $ do
        route $ setExtension "html"
        --           field "prevPost" prevUrl `mappend` postCtx
        --    (postCtx `mappend` field "nextUrl" (nextUrl (zip postIds metadatas)))
        --
        compile $ do 
            postIds <- getMatches "posts/*"
            metadatas <- mapM getMetadata postIds
            let isDrafts = map (lookupString "draft") metadatas
            let posts = map (\(x, y, z) -> (x, y)) $ filter (\(_, _, isDraft) -> isDraft /= Just "true") $ zip3 postIds metadatas isDrafts 
            let ctx = postCtx
                        `mappend` field "nextPost" (nextUrl posts)
                        `mappend` field "prevPost" (prevUrl posts)
                        `mappend` field "nextTitle" (nextTitle posts)
                        `mappend` field "prevTitle" (prevTitle posts)
                        `mappend` field "nextQuote" (nextQuote posts)
                        `mappend` field "prevQuote" (prevQuote posts)
                        `mappend` field "callToAction" callToAction
            myPandocCompiler
              >>= loadAndApplyTemplate "templates/post.html" ctx
              >>= saveSnapshot "content"
              >>= loadAndApplyTemplate "templates/default.html" ctx
              >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            allPosts <- recentFirst =<< loadAll "posts/*"
            posts <- nonDrafts allPosts
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    constField "description" "Richard's Software Blog"
                    `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

nonDrafts :: [Item String] -> Compiler [Item String]
nonDrafts items = fmap catMaybes (sequence (map nonDraft items))

nonDraft :: Item String -> Compiler (Maybe (Item String))
nonDraft item = do
  draftField <- getMetadataField (itemIdentifier item) "draft"
  return (if draftField == (Just "true") then Nothing else Just item)

postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

type NeighborGetter = Identifier -> [(Identifier, Metadata)] -> Maybe (Identifier, Metadata)
after :: NeighborGetter
after x xs = fmap snd (find (\y -> fst (fst y) == x) $ zip xs (tail xs))
before :: NeighborGetter
before x xs = fmap fst (find (\y -> fst (snd y) == x) $ zip xs (tail xs))

type NeighborData = (String, String, String)

neighborData :: NeighborGetter -> [(Identifier, Metadata)] -> Item String -> Maybe (Identifier, Metadata)
neighborData getNeighbor posts item = 
  getNeighbor (itemIdentifier item) posts

nextUrl :: [(Identifier, Metadata)] -> Item String -> Compiler String
nextUrl posts item = do
   (ident, _) <- maybe empty return $ neighborData after posts item
   getRoute ident >>= maybe empty return

prevUrl :: [(Identifier, Metadata)] -> Item String -> Compiler String
prevUrl posts item = do
   (ident, _) <- maybe empty return $ neighborData before posts item
   getRoute ident >>= maybe empty return

nextTitle :: [(Identifier, Metadata)] -> Item String -> Compiler String
nextTitle posts item = fmap (map toLower) $ do
   (_, metadata) <- maybe empty return $ neighborData after posts item
   maybe empty return (lookupString "title" metadata)

nextQuote :: [(Identifier, Metadata)] -> Item String -> Compiler String
nextQuote posts item = do
   (_, metadata) <- maybe empty return $ neighborData after posts item
   maybe empty return (lookupString "quote" metadata)

prevTitle :: [(Identifier, Metadata)] -> Item String -> Compiler String
prevTitle posts item = fmap (map toLower) $ do
   (_, metadata) <- maybe empty return $ neighborData before posts item
   maybe empty return (lookupString "title" metadata)

prevQuote :: [(Identifier, Metadata)] -> Item String -> Compiler String
prevQuote posts item = do
   (_, metadata) <- maybe empty return $ neighborData before posts item
   maybe empty return (lookupString "quote" metadata)

callToAction :: Item String -> Compiler String
callToAction item = do
  let thisId = itemIdentifier item
  reddit <- getMetadataField thisId "reddit"
  hackernews <- getMetadataField thisId "hackernews"
  retweet <- getMetadataField thisId "retweet"
  let link url text = "<a href=\"" <> url <> "\">" <> text <> "</a>"
      redditText = fmap (\url -> "commenting " <> link url "on reddit") reddit
      hackernewsText = fmap (\url -> "discussing " <> link url "on the orange website") hackernews
      twitterText = fmap (\url -> link url "retweeting" <> " the post") retweet

      oxfordComma [x] = " Consider " <> x <> "."
      oxfordComma [x, y] = " Consider " <> x <> " or " <> y <> "."
      oxfordComma [x, y, z] = " Consider " <> x <> ", " <> y <> ", " <> "or " <> z      <> "."
      oxfordComma _ = ""
  return $ "Thanks for reading!" <> oxfordComma (catMaybes [twitterText, hackernewsText, redditText])

feedCtx :: Context String
feedCtx = defaultContext

feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle = "Richard's Software Blog"
    , feedDescription = "Richard's Software Blog"
    , feedAuthorName = "Richard Marmorstein"
    , feedAuthorEmail = "nobody@example.com"
    , feedRoot = "https://twitchard.github.io"
    }
