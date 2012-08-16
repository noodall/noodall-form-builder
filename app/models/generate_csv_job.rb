class GenerateCsvJob
  def self.perform(download_id)

    # TODO: Catch errors if download or form do not exist
    download = Noodall::Download.find(download_id)
    form = Noodall::Form.find(download.form_id)

    csv = Noodall::FormResponseCsv.new(form, download.conditions).output
    download.update_attribute(:output, csv)
  end
end
