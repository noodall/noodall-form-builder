require 'qu-mongo'

module Noodall
  class Queue
    def initialize(options = {})
      @qu = options[:queue]
    end

    def add(job_type, job_id)
      queue.enqueue(job_type, job_id)
    end

    def queue
      @qu ||= Qu
    end
  end
end

