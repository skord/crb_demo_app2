# Our starting point
FROM phusion/passenger-full:0.9.11
MAINTAINER Mike Danko <danko@mittdarko.com>
# Build System and git
USER root
ENV HOME /root
# The default command to be executed in container
CMD ["/sbin/my_init"]
RUN mkdir -p /home/app/crb_demo_app/vendor/bundle/
# Fix Ownership
USER root
ENV HOME /root
RUN chown -R app:app /home/app/crb_demo_app/vendor/bundle/
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
VOLUME ["/home/app/crb_demo_app/vendor/bundle/"]
USER app
ENV HOME /home/app
WORKDIR /home/app/crb_demo_app

