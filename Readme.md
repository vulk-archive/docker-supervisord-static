# A standalone supervisord

A supervisor is an important process... it just felt strange to deploy ALL of python.
So I took some time to create a static binary...

# For our minimal example, we'll just pull in the asm version of 'true' from:

https://github.com/tianon/dockerfiles/tree/master/true

```
$ docker run vulk/supervisord-static cat /supervisord > supervisord ; chmod +x supervisord 
$ file supervisord
supervisord: ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 2.6.32, BuildID[sha1]=c7881ee635ceeea7097ffc3d5aadc8d3964283ef, not stripped
$ strip supervisord
$ ls -lah supervisord 
-rwxr-xr-x 1 hh hh 11M Oct 27 13:44 supervisord

```

This binary will allow us to run in 'from scratch' container builds:

```tar cv ./true-asm ./etc/supervisord.conf ./tmp ./supervisord | docker import - supervisord-true-asm```

```
$ docker  history supervisord-true-asm
IMAGE               CREATED             CREATED BY          SIZE
62c673748751        2 seconds ago                           19.72 MB
```

```
$ docker run supervisord-true-asm ./supervisord
<frozen>:294: UserWarning: Supervisord is running as root and it is searching for its configuration file in default locations (including its current working directory); you probably want to specify a "-c" argument specifying an absolute path to a configuration file for improved security.
2014-10-27 21:31:56,087 CRIT Supervisor running as root (no user in config file)
2014-10-27 21:31:56,087 INFO NO LIMIT SET, NOT AVALIABLE IN STATIC BINARY
2014-10-27 21:31:56,088 INFO supervisord started with pid 1
2014-10-27 21:31:57,090 INFO spawned: 'true-asm' with pid 7
2014-10-27 21:31:57,097 INFO exited: true-asm (exit status 0; not expected)
2014-10-27 21:31:58,099 INFO spawned: 'true-asm' with pid 8
2014-10-27 21:31:58,102 INFO exited: true-asm (exit status 0; not expected)
2014-10-27 21:32:00,105 INFO spawned: 'true-asm' with pid 9
2014-10-27 21:32:00,112 INFO exited: true-asm (exit status 0; not expected)
2014-10-27 21:32:03,116 INFO spawned: 'true-asm' with pid 10
2014-10-27 21:32:03,120 INFO exited: true-asm (exit status 0; not expected)
2014-10-27 21:32:04,121 INFO gave up: true-asm entered FATAL state, too many start retries too quickly
```
