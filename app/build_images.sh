#!/bin/bash
# Usage ./build_images.sh <aws account id>
set -eu

aws_account_id="${1}"
monolith_version="1.0"
like_version="1.0"

cd monolith-service || exit
docker build -t monolith-service:${monolith_version} . && \
docker tag monolith-service:${monolith_version} "${aws_account_id}".dkr.ecr.eu-west-1.amazonaws.com/mysfits-monolith:${monolith_version} && \
docker push "${aws_account_id}".dkr.ecr.eu-west-1.amazonaws.com/mysfits-monolith:${monolith_version}

cd ..

cd like-service || exit
docker build -t like-service:${like_version} . && \
docker tag like-service:${like_version} "${aws_account_id}".dkr.ecr.eu-west-1.amazonaws.com/mysfits-like:${like_version} && \
docker push "${aws_account_id}".dkr.ecr.eu-west-1.amazonaws.com/mysfits-like:${like_version}

cd ..

cd xray || exit
docker build -t xray . && \
docker tag xray "${aws_account_id}".dkr.ecr.eu-west-1.amazonaws.com/mysfits-xray && \
docker push "${aws_account_id}".dkr.ecr.eu-west-1.amazonaws.com/mysfits-xray

cd ..

echo -e "Build completed!"
