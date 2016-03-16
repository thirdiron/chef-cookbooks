file '/var/lib/rabbitmq/queueStatus.txt' do
  owner 'ubuntu'
  group 'ubuntu'
end

cron 'queue_monitoring' do
  action :create
  minute '*'
  hour '*'
  weekday '*'
  user 'root'
  command "bash -c \"/usr/sbin/rabbitmqctl list_queues -p article-herald > /var/lib/rabbitmq/queueStatus.txt\""
end
