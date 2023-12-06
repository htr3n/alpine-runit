# Alpine Docker with runit

[Alpine Linux](https://www.alpinelinux.org/) is a lightweight distribution that uses `BusyBox` and `musl` as the base system. As such, the base Alpine Docker image is very small, roughly 5.6MB, and only contains the bare minimum to get up and running.

This image is based on the base [Alpine dockr image](https://hub.docker.com/r/library/alpine) plus [`runit`](http://smarden.org/runit/) for better service supervision and zombie process reaping.

## Usage

This image is intended as an example of using `runit` in a Docker container with some illustrative services `first`, `second`, and `third`. You cap adapt them to your own requirements.

### Build the image

```sh
docker build --rm --tag=alpine-runit .
```

### Start a Docker container

```sh
docker run -it --rm alpine-runit
- runit: $Id: 25da3b86f7bed4038b8a039d2f8e8c9bbcf0822b $: booting.
- runit: enter stage: /etc/runit/1
1 :: This is a one time system task
- runit: leave stage: /etc/runit/1
- runit: enter stage: /etc/runit/2
2 :: This is the runsvdir task
Starting the third service
Starting the first service
Starting the second service
uid=1003(third) gid=0(root) groups=0(root)
uid=1002(second) gid=0(root) groups=0(root)
```

Explore runit process tree:

```sh
docker top <container_id|container_name> -afx
PID                 TTY                 STAT                TIME                COMMAND
428622              pts/0               Ss+                 0:00                \_ runit
428643              ?                   Ss                  0:00                \_ runsvdir -P /etc/service log: ............
428644              ?                   Ss                  0:00                \_ runsv third
428647              ?                   S                   0:00                | \_ sh -c id; while true; do sleep 100; done
428652              ?                   S                   0:00                | \_ sleep 100
428645              ?                   Ss                  0:00                \_ runsv second
428649              ?                   S                   0:00                | \_ sh -c id; while true; do sleep 100; done
428655              ?                   S                   0:00                | \_ sleep 100
428646              ?                   Ss                  0:00                \_ runsv first
428648              ?                   S                   0:00                \_ sh -c id; while true; do sleep 100; done
428653              ?                   S                   0:00                \_ sleep 100
```
