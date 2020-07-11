FROM oracle/graalvm-ce:20.1.0-java11 as graalvm
RUN gu install native-image

COPY . /home/app/garlic
WORKDIR /home/app/garlic

RUN native-image --no-server -cp build/libs/garlic-*-all.jar

FROM frolvlad/alpine-glibc
RUN apk update && apk add libstdc++
EXPOSE 8080
COPY --from=graalvm /home/app/garlic/garlic /app/garlic
ENTRYPOINT ["/app/garlic"]
