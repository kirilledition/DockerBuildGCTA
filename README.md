# Build GCTA static binary using docker

[GCTA](https://github.com/jianyangqt/gcta) (Genome-wide Complex Trait Analysis) is a software package, which is used for genome-wide association studies (GWASs).

Repository contains dockerfile that builds gcta binary and all dependencies.
Container resulting from this image contains binary executable, so you need to copy it to your local machine.
Patch file changes building instructions for gcta, to create static binary, so you do not need to have any libraries in your machine.

`docker build` accepts build argument MAKE_JOBS that is provided for all make commands. Building for arm features CPU_ARCH build argument for OpenBLAS compilation.