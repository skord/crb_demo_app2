# Our starting point
FROM phusion/passenger-customizable:0.9.11
MAINTAINER Mike Danko <danko@mittdarko.com>
# This should not be, but is currently missing from upstream
ADD /build/ruby-switch /build/ruby-switch
RUN chmod 0755 /build/ruby-switch
# Update apt-cache
RUN apt-get update -qq
# Build System and git
RUN /build/utilities.sh
# Ruby
RUN /build/ruby2.1.sh
# All the stuff we need to build ruby/rails apps
RUN /build/devheaders.sh
# for execjs
RUN /build/nodejs.sh
USER root
ENV HOME /root
# The default command to be executed in container
CMD ["/sbin/my_init"]
# Let's get some NGINX things out of the way
ADD build/crb_demo_app.conf /etc/nginx/sites-enabled/crb_demo_app.conf
RUN rm -f /etc/nginx/sites-enabled/default
RUN rm -f /etc/service/nginx/down
# Let's start copying our app over to the image
RUN mkdir -p /home/app/crb_demo_app
WORKDIR /home/app/crb_demo_app
# First, gems by themselves so it's a cached step
ADD Gemfile /home/app/crb_demo_app/
ADD Gemfile.lock /home/app/crb_demo_app/
# ADD does everything as UID/GUID 0, let's make it right
# before bundling
RUN chown -R app:app /home/app/crb_demo_app
# Bundle, but as the right user
USER app
ENV HOME /home/app
# -- deployment makes sure our git sourced gems are included
RUN bundle install --deployment
# Asset Precompile
ADD Rakefile /home/app/crb_demo_app/
ADD /config/ /home/app/crb_demo_app/config/
ADD /app/assets/ /home/app/crb_demo_app/app/assets/
ADD /vendor/assets/ /home/app/crb_demo_app/vendor/assets/
# Fixing ownership
USER root
ENV HOME /root
RUN chown -R app:app /home/app/crb_demo_app
# Back to the right user
USER app
ENV HOME /home/app
# Asset precompile
RUN bundle exec rake assets:precompile
# Add the rest
ADD / /home/app/crb_demo_app
# Fix Ownership
USER root
ENV HOME /root
RUN chown -R app:app /home/app/crb_demo_app

