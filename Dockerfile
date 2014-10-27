FROM vulk/python-static
ENV PATH /usr/local/python-static/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ADD . /build/src
RUN PATH=/usr/local/python-static/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin ./build.sh
CMD ["/supervisord"]