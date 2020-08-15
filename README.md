`docker build -t bootstrap --no-cache ./`
`docker run -it --rm -v $PWD:/home/k-ota/ bootstrap /bin/bash`
`cd /home/k-ota`
`make`
