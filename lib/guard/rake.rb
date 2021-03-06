require 'guard'
require 'guard/guard'
require 'rake'

module Guard
  class Rake < Guard
    def initialize(watchers=[], options={})
      super
      @options = {
        :run_on_start => true,
        :run_on_all => true
      }.update(options)
      @task = @options[:task]
    end

    def start
      UI.info "Starting guard-rake #{@task}"
      ::Rake.application.init
      ::Rake.application.load_rakefile
      run_all if @options[:run_on_start]
      true
    end

    def stop
      UI.info "Stopping guard-rake #{@task}"
      true
    end

    def reload
      stop
      start
    end

    def run_all
      run_rake_task if @options[:run_on_all]
    end

    def run_on_change(paths)
      run_rake_task
    end

    def run_rake_task
      UI.info "running #{@task}"
      ::Rake::Task.tasks.each { |t| t.reenable }
      ::Rake::Task[@task].invoke
    end
  end
end
