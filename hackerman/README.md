# Hackerman Mode

This is a version of this website with a fully-fledged POSIX system and a fully-fledged shell. 
This is backed using WebAssembly, Apache NuttX and VirtIO.

## Why?

This is a small experiment to test out if people would find it interesting to browse a website like it's a pubnix system.
The main inspiration behind this was the Replit Website for their careers page which spawned a cloud-hosted shell with
the ability to run commands and view their job openings in a text file.

## Developing

Following this [blog](https://lupyuen.github.io/articles/tinyemu) about trying to run tinyemu on the web, you will be able
to bootstrap this system for testing.

### Adding new programs to NuttX

Coming soon! I'm yet to figure out how to add apps in NuttX, but the initial goal right now is port busybox in it.