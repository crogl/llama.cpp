# how to enable TLS in the provided dockerfiles 
in `.devops.cpu.Dockerflie` and `.devops.cuda.Dockerfile`:

- find the `app-get install` line and add `libssl-dev` to it

e.g. `apt-get install -y build-essential git cmake libcurl4-openssl-dev libssl-dev`

- in the `cmake` line add the flag `-DLLAMA_SERVER_SSL=ON`