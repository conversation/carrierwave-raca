require 'raca'

module CarrierWave
  module Storage
    class Raca < Abstract

      def store!(file)
        File.new(uploader, connection, uploader.store_path).tap do |raca_file|
          raca_file.store(file)
        end
      end

      def retrieve!(identifier)
        File.new(uploader, connection, uploader.store_path(identifier))
      end

      def connection
        @connection ||= ::Raca::Account.new(uploader.raca_username, uploader.raca_api_key)
      end

      class File
        attr_writer :content_type
        attr_reader :uploader, :account, :path

        def initialize(uploader, account, path)
          @uploader = uploader
          @account  = account
          @path     = path
        end

        # is this required?
        def attributes
          object_metadata
        end

        def content_type
          @content_type || object_metadata[:content_type]
        end

        def delete
          container.delete(path)
        rescue ::Raca::NotFoundError
          # if the file doesn't exist on cloud files, then deleting it was a no-op anyway
          true
        end

        def extension
          path.split('.').last
        end

        def exists?
          object_metadata != nil
        end

        def filename(options = {})
          if file_url = url(options)
            file_url.gsub(/.*\/(.*?$)/, '\1')
          end
        end

        def read
          tempfile = Tempfile.new("carrierwave-raca")
          tempfile.close
          container.download(path, tempfile.path)
          ::File.read(tempfile.path)
        ensure
          tempfile.unlink if tempfile
        end

        def size
          object_metadata[:bytes]
        end

        def store(new_file)
          container.upload(path, new_file.file, "Content-Type" => new_file.content_type)
        end

        def to_file
          # is this needed?
        end

        def url(options = {})
          if uploader.asset_host
            "#{uploader.asset_host}/#{path}"
          else
            path
          end
        end

        private

        def authenticated_url
          # is this needed?
        end

        def public_url
          # is this needed?
        end

        def containers
          @containers ||= account.containers(uploader.raca_region)
        end

        def container
          @bucket ||= containers.get(uploader.raca_container)
        end

        def object_metadata
          @object_metadata ||= container.object_metadata(path)
        end
      end
    end
  end
end
