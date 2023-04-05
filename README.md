# GCTA in docker

[GCTA](https://github.com/jianyangqt/gcta) (Genome-wide Complex Trait Analysis) is a software package, which is used for genome-wide association studies (GWASs).

Repository contains dockerfile that installs dependencies and builds gcta from source. I include git hash to docker tag, because developers does not assign new version number to recent changes in source code. 

## Command to build image
```
docker build -f apt_dependencies.Dockerfile -t kirill/gcta -t kirill/gcta:1.94.1-f22c624 .
```