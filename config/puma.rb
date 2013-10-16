# see details http://ctshryock.com/posts/2012/07/12/running-rails-with-puma-on-heroku.html
# and http://stackoverflow.com/questions/17903689/puma-cluster-configuration-on-heroku
environment ENV['RACK_ENV']
threads 0,5

workers 2
preload_app!

#on_worker_boot do
#	ActiveSupport.on_load(:active_record) do
#		ActiveRecord::Base.establish_connection
#	end
#end

on_worker_boot do
	ActiveRecord::Base.connection_pool.disconnect!

	ActiveSupport.on_load(:active_record) do
		config = Rails.application.config.database_configuration[Rails.env]
		config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
		config['pool']              = ENV['DB_POOL'] || 5
		ActiveRecord::Base.establish_connection
	end
end