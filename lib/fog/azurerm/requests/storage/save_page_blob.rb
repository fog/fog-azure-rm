module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        # This class is used to store chunk data for page blob before uploading.
        class BlobChunk
          attr_reader :id # For debug
          attr_reader :start_range
          attr_reader :data

          def initialize(id, start_range, data)
            @id = id
            @start_range = start_range
            @data = data
          end

          def end_range
            @start_range + @data.size - 1
          end
        end

        # This class is a stream to read chunk data.
        class BlobFileStream
          def initialize(body)
            if body.respond_to?(:read)
              if body.respond_to?(:rewind)
                begin
                  body.rewind
                rescue => ex
                  Fog::Logger.debug "save_page_blob - body responds to :rewind but throws an exception when calling :rewind: #{ex.inspect}"
                end
              end
              @stream = body
            else
              @stream = StringIO.new(body)
            end
            @mutex = Mutex.new
            @count = 0
          end

          def read(size)
            data = nil
            id = 0
            start_range = 0
            @mutex.synchronize do
              start_range = @stream.pos
              data = @stream.read(size)
              return nil if data.nil?
              @count += 1
              id = @count
            end
            BlobChunk.new(id, start_range, data)
          end
        end

        def save_page_blob(container_name, blob_name, body, options)
          threads_num = options.delete(:worker_thread_num)
          threads_num = UPLOAD_BLOB_WORKER_THREAD_COUNT if threads_num.nil? || !threads_num.is_a?(Integer) || threads_num < 1

          begin
            blob_size = Fog::Storage.get_body_size(body)
            raise "The page blob size must be aligned to a 512-byte boundary. But the file size is #{blob_size}." if (blob_size % 512).nonzero?

            # Initiate the upload
            Fog::Logger.debug "Creating the page blob #{container_name}/#{blob_name}. options: #{options}"
            create_page_blob(container_name, blob_name, blob_size, options)
            options.delete(:content_md5)

            # Uploading content
            iostream = BlobFileStream.new(body)

            threads = []
            threads_num.times do |id|
              thread = Thread.new do
                Fog::Logger.debug "Created upload thread #{id}."
                while (chunk = iostream.read(MAXIMUM_CHUNK_SIZE))
                  Fog::Logger.debug "Upload thread #{id} is uploading #{chunk.id}, start_range: #{chunk.start_range}, size: #{chunk.data.size}."
                  put_blob_pages(container_name, blob_name, chunk.start_range, chunk.end_range, chunk.data, options) if Digest::MD5.hexdigest(chunk.data) != HASH_OF_4MB_EMPTY_CONTENT
                end
                Fog::Logger.debug "Upload thread #{id} finished."
              end
              thread.abort_on_exception = true
              threads << thread
            end

            threads.each(&:join)
          rescue
            # Abort the upload & reraise
            begin
              delete_blob(container_name, blob_name)
            rescue => ex
              Fog::Logger.debug "Cannot delete the blob: #{container_name}/#{blob_name} after save_page_blob failed. #{ex.inspect}"
            end
            raise
          end

          Fog::Logger.debug "Successfully save the page blob: #{container_name}/#{blob_name}."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def save_page_blob(*)
          true
        end
      end
    end
  end
end
