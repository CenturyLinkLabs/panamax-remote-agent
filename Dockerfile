FROM centurylink/panamax-ruby-base:0.1.2

CMD bundle exec rake db:create && \
  bundle exec rake db:migrate && \
  bundle exec rails s
