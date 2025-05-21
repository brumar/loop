#! /bin/sh
tail -n 2 ../.jbsays/logs/*.log | grep "num_turns" > ../../logs.json
