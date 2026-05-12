#!/bin/bash
grep -oP -m1 "href=\"[^\"]+" "$1" | cut -c 7-
