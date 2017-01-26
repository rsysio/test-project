FROM java:latest
MAINTAINER Stuart Mcvean
WORKDIR /opt/docker
ADD opt /opt
RUN ["chown", "-R", "daemon:daemon", "."]
USER daemon
ENTRYPOINT ["bin/test-project"]
CMD []
