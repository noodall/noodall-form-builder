module Noodall
  module Admin
    class DownloadsController < Noodall::Admin::BaseController
      def download
        download = Noodall::Download.completed(params[:download_id])

        if download
          send_data(
            download.output,
            filename: download.filename,
            type: 'text/csv',
            disposition: 'attachment'
          )
        end
      end
    end
  end
end
