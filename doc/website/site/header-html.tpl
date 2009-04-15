<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title><lisp>(muse-publishing-directive "title")</lisp></title>
    <!-- Insert metadata -->
    <lisp>
      (concat "<meta name=\"generator\" content=\"Emacs Muse v" muse-version "\">")
    </lisp>
    <lisp>
      (let ((author (muse-publishing-directive "author")))
      (when author
      (concat "<meta name=\"author\" content=" author ">")))
    </lisp>
    <meta http-equiv="<lisp>muse-html-meta-http-equiv</lisp>"
          content="<lisp>muse-html-meta-content-type</lisp>">
    <lisp>
      (let ((keywords (muse-publishing-directive "keywords")))
      (when keywords
      (concat "<meta name=\"keywords\" content=\"xavier maillard, " keywords "\">")))
    </lisp>
    <lisp>
      (let ((refresh (muse-publishing-directive "refresh")))
      (when refresh
      (concat "<meta http-equiv=\"refresh\" content=\"" refresh "\">")))
    </lisp>
    <!-- End metadata -->
    <!-- CSS and RSS -->
    <lisp>
      (let ((maintainer (muse-style-element :maintainer)))
      (when maintainer
      (concat "<link rev=\"made\" href=\"" maintainer "\">")))
    </lisp>
    <link rel="stylesheet" type="text/css" charset="utf-8"
          media="screen,projection" href="<lisp>(muse-gen-relative-name "solid.css")</lisp>">
    <link rel="stylesheet" type="text/css"
          href="<lisp>(muse-gen-relative-name "print.css")</lisp>" media="print">
    <link rel="alternate" type="application/atom+xml" title="Alex Ott's Page. No
                                                             vosti sajta"
          href="http://xtalk.msk.su/~ott/ru/news/atom.xml">
    <link rel="alternate" type="application/atom+xml" title="Alex Ott's Page. Si
                                                             te news"
          href="http://xtalk.msk.su/~ott/en/news/atom.xml">
    <!-- END CSS and RSS -->
  </head>
  <body>

    <div id="outside">
      <h1 id="top"><span style="color: #666666; letter-spacing: -2px;"><lisp>(muse-publishing-directive "title")</lisp></span></h1>
      <!--
         - <p>
         -   <a href="<lisp>(muse-gen-relative-name "en/index.html")</lisp>">English</a>
         -   <a href="<lisp>(muse-gen-relative-name "fr/index.html")</lisp>">Français</a>
         - </p>
        -->


      <div id="main">
        <div id="links">
          <h3>Menu</h3>
          <lisp>
            (let ((project (muse-publishing-directive "project")))
            (when project
            (muse-mp-generate-savannah-project-menu project)))
          </lisp>
          <p style="text-align: center;">Support us:
          <script type="text/javascript"
                  src="http://www.ohloh.net/p/324325/widgets/project_thin_badge.js"></script>
          </p>
        </div> <!-- links -->

        <div id="body">
