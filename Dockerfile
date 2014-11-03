FROM centurylink/panamax-ruby-base:0.2.0

CMD bundle exec rake db:create && \
  bundle exec rake db:migrate && \
  bundle exec puma -e production -b 'ssl://0.0.0.0:3000?key=/usr/local/share/certs/pmx_remote_agent.key&cert=/usr/local/share/certs/pmx_remote_agent.crt'
