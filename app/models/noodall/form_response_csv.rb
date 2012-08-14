# In Ruby 1.9, FasterCSV was included as csv
if RUBY_VERSION =~ /1\.8/
  require 'fastercsv'
  CSV = FasterCSV
else
  require 'csv'
end

module Noodall
  class FormResponseCsv
    def initialize(form, conditions = {})
      @form = form
      @conditions = conditions
    end

    def output
      csv_string = CSV.generate do |csv|
        csv << header_row

        for response in responses
          response_row = @form.fields.map do |field|
            begin
              value = response.send(field.underscored_name)
              value.respond_to?(:join) ? value.join(', ') : value
            rescue NoMethodError => e
              nil
            end
          end
          response_row += [response.created_at.to_formatted_s(:long), response.ip, response.referrer]
          csv << response_row
        end
      end

      csv_string
    end

    def approved
      @form.responses.where(:approved => true)
    end

    def responses
      filter_by_date(approved)
    end

    def filter_by_date(responses)
      from, to = parse_conditions
      return responses if from.nil? || to.nil?

      responses.where(
        :created_at => {
          :$gte => from,
          :$lt => to
        }
      )
    end

    def parse_conditions
      return [] if @conditions.empty?

      year = @conditions["year"].to_i
      month = @conditions["month"].to_i

      from = Date.civil(year, month, 01).to_time

      next_month = month + 1
      next_month = 1 if next_month > 12
      to = Date.civil(year, next_month, 01).to_time

      [from, to]
    end

    def header_row
      fields + ['Date', 'IP', 'Form Location']
    end

    def fields
      @form.fields.map { |field| field.name }
    end
  end
end
