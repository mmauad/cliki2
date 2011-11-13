(in-package #:cliki2)
(in-readtable cliki2)

(defvar *title*)
(defvar *footer*)

(defun render-header ()
  #H[<html>
  <head>
    <title>${(format nil "CLiki~@[: ~A~]" *title*)}</title>
    <link  rel="alternate" type="application/rss+xml" title="recent changes" href="$(#/site/feed/rss.xml)">
    <link  rel="stylesheet" href="/static/css/style.css">
    <link  rel="stylesheet" href="/static/css/colorize.css">
  </head>

  <body>
    <div id="pageheader">
      <div id="header">
        <span id="logo">CL<span>iki</span></span>
        <span id="slogan">the common lisp wiki</span>
        <div id="login">]
          (if *account*
              #H[<a href="${(link-to *account*)}">${(name *account*)}</a> <a href="$(#/site/logout)">Log out</a>]
              #H[<form method="post" action="$(#/site/login)">
                   <input type="text" name="name" title="login" class="login_input" />
                   <input type="password" name="password" class="login_input" />
                   <input type="submit" value="login" id="login_submit"/><br />
                   <span id="reset_pw"><input type="submit" value="reset password" /></span>
                   <a id="register" href="$(#/site/register)">Register</a>
                 </form>])
          #H[
        </div>
      </div>
    </div>

    <div class="buttonbar">
      <ul>
        <li><a href="/">Home</a></li>
        <li><a href="$(#/site/recent-changes)">Recent Changes</a></li>
        <li><a href="/CLiki">About CLiki</a></li>
        <li><a href="/Text%20Formating">Text Formatting</a></li>
      </ul>
      <div id="search">
        <form action="$(#/site/search)">
          <input type="text" name="query" value="${(or (hunchentoot:get-parameter "query") "")}" />
          <input type="submit" value="search" />
        </form>
      </div>
    </div>
    <div id="content">])

(defun render-footer ()
  #H[</div><div id="footer" class="buttonbar"><ul>${*footer*}</ul></div></body></html>])

(defmacro render-page (title &body body)
  `(let* ((*title* ,title)
          (*footer* "")
          (body (with-output-to-string (*html-stream*)
                  ,@body)))
     (with-output-to-string (*html-stream*)
       (render-header)
       (princ body *html-stream*)
       (render-footer))))

(defun not-found-page ()
  (render-page "Article not found"
    #H[<h1>Cliki2 does not have an article with this exact name</h1>
    <a href="$(#/site/edit-article?title={(guess-article-name)})">Create</a>]))