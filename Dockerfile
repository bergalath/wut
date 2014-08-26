
# Ubuntu is sooooo boring, even in a container, back to ArchLinux ! ;o)
# Feignasse inside : revenir à base/archlinux et ajouter yaourt à la mano
FROM base/devel:latest

MAINTAINER Bertrand Gauriat "https://github.com/bergalath/wut"

# Update repositories & packages
#RUN pacman -Syyuu # à tester +tard

# Install ruby & friends
RUN pacman -S --needed --noconfirm ruby
RUN yaourt -S --needed --noconfirm ruby-bundler

# Pull project from github
RUN git clone https://github.com/bergalath/wut.git /home/wut

WORKDIR /home/wut

# Setup project environment
RUN bundle install --path=vendor --binstubs

CMD ["./bin/rackup"]
