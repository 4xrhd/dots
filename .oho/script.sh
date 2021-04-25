#!/bin/bash
        i=$(echo $((1 + RANDOM % 14))) && exec /home/$(whoami)/.oho/$i
