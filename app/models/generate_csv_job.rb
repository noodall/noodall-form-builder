class GenerateCsvJob
  def self.perform(download_id)
    Rails.logger.info "Picking up download with ID #{download_id}"

    # TODO: Catch errors if download or form do not exist
    download = Noodall::Download.find(download_id)
    form = Noodall::Form.find(download.form_id)

    csv = Noodall::FormResponseCsv.new(form, download.conditions).output
    download.reload
    download.update_attribute(:output, csv)

    # Send notification email
    if download.email_when_ready?
      FormMailer.download_ready(download).deliver
    end
  end
end
