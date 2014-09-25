FROM centurylink/panamax-ruby-base:0.1.2

CMD bundle exec rake db:create && \
  bundle exec rake db:migrate && \
  bundle exec puma -e production -b 'ssl://0.0.0.0:3000?key=certs/pmx_remote_agent.key&cert=certs/pmx_remote_agent.crt'
