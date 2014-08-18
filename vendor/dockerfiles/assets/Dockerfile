# Our starting point
FROM phusion/passenger-full:0.9.11
MAINTAINER Mike Danko <danko@mittdarko.com>
# Build System and git
USER root
ENV HOME /root
# The default command to be executed in container
CMD ["/sbin/my_init"]
RUN mkdir -p /home/app/crb_demo_app/public/assets/
# Fix Ownership
USER root
ENV HOME /root
RUN chown -R app:app /home/app/crb_demo_app/public/assets/
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
VOLUME ["/home/app/crb_demo_app/public/assets/"]
WORKDIR /home/app/crb_demo_app


