module Noodall
  class FormResponsesDownload
    attr_accessor :csv_generator, :queue

    def initialize(form, conditions, email = nil)
      @form = form
      @conditions = conditions
      @email = email
    end

    def generate
      download = Noodall::Download.new(
        form_id: @form.id,
        form_title: @form.title,
        conditions: @conditions,
        email: @email
      )

      download.save

      if Noodall::FormBuilder.use_background_queue == true
        queue.add(GenerateCsvJob, download.id)
      else
        csv_output = csv_generator.new(@form, @conditions).output
        download.update_attribute(:output, csv_output)
      end

      download
    end

    def csv_generator
      @generator ||= FormResponseCsv
    end

    def queue
      @queue ||= Noodall::Queue.new
    end
  end
end

