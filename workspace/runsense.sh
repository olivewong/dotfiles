#!/bin/sh

tmux new-session -s 'runsense' \; \
  send-keys 'tmux kill-session -a -t runsense' C-m \; \
  send-keys 'cd ~/repos/brain && embite start 301 --backseat' C-m \; \
  send-keys 'roscore & sleep 5' C-m C-m\; \
  send-keys 'rossimon && roslaunch brain sense.launch' C-m \; \
        split-window -v \; \
  send-keys 'cd ~/repos/brain && sleep 30' C-m \; \
        send-keys 'embite play 201 2020/11/13/03/55/08 20 -l --clock' C-m \; \
        split-window -h \; \
        send-keys 'cd ~/repos/frontier' C-m \; \
        send-keys './kill' C-m \; \
        send-keys './serve operator' C-m
