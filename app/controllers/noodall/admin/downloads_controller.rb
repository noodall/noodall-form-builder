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

      def email
        download = Noodall::Download.find(params[:download_id])
        download.email_when_ready(current_user.email)
        flash[:message] = 'You will be emailed when the download is ready'
        redirect_to noodall_admin_forms_path
      end
    end
  end
end
