# DockerBuildGCTA
Build GCTA static binary using docker

docker build -t build_gcta .
docker run -it --rm -v "$(pwd)"/result:/result build_gcta cp /home/gcta/build/gcta64 /result/gcta64