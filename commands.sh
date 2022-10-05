docker build \
    -f x86.Dockerfile \
    --build-arg MAKE_JOBS=32 \
    -t build_gcta \
    .

docker build \
    -f arm.Dockerfile \
    --build-arg MAKE_JOBS=32 \
    --build-arg CPU_ARCH=NEOVERSEN1 \
    -t build_gcta \
    .

docker run \
    -it \
    --rm \
    -v "$(pwd)"/result:/result \
    build_gcta \
    cp /home/gcta/build/gcta64 /result/gcta64
