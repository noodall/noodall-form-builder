module Noodall
  class Download
    include MongoMapper::Document

    key :output, String
    key :conditions, Hash, :required => true
    key :form_id, ObjectId, :required => true
    key :form_title, String, :required => true
    key :email, String

    timestamps!

    def filename
      "#{form_title} responses #{date_conditions} #{download_date}.csv"
    end

    def email_when_ready(email)
      update_attribute(:email, email)
    end

    def email_when_ready?
      !email.to_s.empty?
    end

    def self.completed(download_id)
      where(id: download_id).where(:output.ne => nil).first
    end

    private

    def date_conditions
      "#{conditions[:month]}-#{conditions[:year]}"
    end

    def download_date
      updated_at.to_formatted_s(:db)
    end
  end
end

