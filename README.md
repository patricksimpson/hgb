# Harp, Gulp, BrowserSync blog engine

## Intro

So I started playing with Harp.js and I really liked it. However, only (alone) harp was a dull, mostly because you have to maintain your own data file, to populate your blog listing, etc. This project's goal is to automate the process of maintaining the blog data files, and let harp do everything else. 

Therefore, this project is a gulp wrapper for harp + browsersync, with automated posts!

###Warning: This is a work in progress
You have been warned. Not ready for use yet.

## Install

`npm install`

## Config and Content

### Post Template

You'll need to modify or change the `_layout-post.jade` file. This is the "template" for you posts, and will be used as such. The tag `%BODY%` is used as a replacement for the rendered markdown content from your posts. `%BODY%` must be left intact, but you can move it to wherever you want your post body content to appear.

### Add posts 

You'll want to add posts to the `app/posts-content` directory. 
These will be markdown files `.md`. Using front-matter to contain all the meta data within the post itself.

The engine will auto generate the `app/posts/` jade files. 

## Running

`gulp`

## End 

That's it. Feel free to contribute, collaborate, etc.
