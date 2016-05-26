# this dockerfile makes the service icoordinator.com available
# It uses registry.cloudogu.com/official/nginx as base container
FROM registry.cloudogu.com/official/nginx:1.9.15-1
MAINTAINER Thomas Grosser <thomas.grosser@cloudogu.com>

# Replace default index file
RUN rm /usr/share/nginx/html/index.html
RUN rm /usr/share/nginx/html/50x.html
ADD resources/index.html /usr/share/nginx/html/javadocs/index.html

ENV SERVICE_TAGS webapp

# Define default command.
CMD ["/startup.sh"]

# Expose ports.
EXPOSE 80
