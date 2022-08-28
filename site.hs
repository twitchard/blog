{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           Data.Maybe (catMaybes)
import           Text.Pandoc (writerExtensions, readerExtensions, enableExtension, Extension(Ext_footnotes))
import           Debug.Trace (trace)



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

    match (fromList ["journal.md"]) $ do
        route   $ setExtension "html"
        compile $ myPandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    create ["atom.xml"] $ do
        route idRoute
        return (trace "hello" ())
        compile $ do
            all <- recentFirst =<<
                loadAllSnapshots "posts/*" "content"
            nonDraft <- nonDrafts all
            let recent = (take 10) nonDraft
            renderAtom feedConfiguration feedCtx recent

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ myPandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    constField "description" "Richard's Software Blog"
                    `mappend`
                    defaultContext

            makeItem ""
                -- >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
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
