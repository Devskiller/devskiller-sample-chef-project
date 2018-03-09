
default['fileserver'].tap do |task|
  task['group'] = 'nobody'
  task['group_id'] = 9000
  task['user'] = 'nobody'
  task['user_id'] = 9000
  task['configuration'] = {}
end
