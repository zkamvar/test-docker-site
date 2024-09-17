## 2024-09-13

I got the docker container to work. It's big and I will have to pare it down,
but it's definitely a starting point. 

The only thing I'm struggling with right now is pushing the changes to a
gh-pages site, but I think what I really should do is to just create an
artifact from the container job and have another job do the pushing.

I tried following the initial tutorial for a container action, but it was not
clear exactly how to connect volumes to the container via the action, so I 
abandoned that concept and went with the `jobs.<id>.container` directive to run
all of the steps of a job inside of the container, which is connected to the
source repo itself and appears to use all of the regular actions as usual.

## 2024-09-16

The build and push worked with the R Markdown docker container, but it was
large. I decided to go with a quarto container.... which happily worked with
the old container. 

## 2024-09-17

I was able to get it to work with the app.... but there is a small problem in that I am not able to get the ID to be correct.... it's now pulling random people's IDs in -_-
