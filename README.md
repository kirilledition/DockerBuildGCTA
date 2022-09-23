# Build GCTA static binary using docker

Repository contains dockerfile that builds gcta binary and all dependencies.
Container resulting from this image contains binary executable, so you need to copy it to your local machine.
Patch file changes building instructions for gcta, to create static binary, so you do not need to have any libraries in your machine.
