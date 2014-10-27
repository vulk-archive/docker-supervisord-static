FROM vulk/python-static
ADD . /build/src
RUN ./build.sh
CMD ["/supervisord"]