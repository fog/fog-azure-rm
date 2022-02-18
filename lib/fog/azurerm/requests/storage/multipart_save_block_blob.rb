module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        # This class is used to store chunk data for block blob before uploading.
        class BlockChunk
          attr_reader :id # For debug
          attr_reader :block_id
          attr_reader :data

          def initialize(id, block_id, data)
            @id = id
            @block_id = block_id
            @data = data
          end
        end

        # This class is a stream to read chunk data.
        class BlockFileStream
          attr_reader :blocks

          def initialize(body)
            if body.respond_to?(:read)
              if body.respond_to?(:rewind)
                begin
                  body.rewind
                rescue => ex
                  Fog::Logger.debug "multipart_save_block_blob - body responds to :rewind but throws an exception when calling :rewind: #{ex.inspect}"
                end
              end
              @stream = body
            else
              @stream = StringIO.new(body)
            end
            @mutex = Mutex.new
            @blocks = []
          end

          def read(size)
            block_id = Base64.strict_encode64(random_string(32))
            data = nil
            id = 0
            @mutex.synchronize do
              data = @stream.read(size)
              return nil if data.nil?
              @blocks << [block_id]
              id = @blocks.size
            end
            BlockChunk.new(id, block_id, data)
          end
        end

        def multipart_save_block_blob(container_name, blob_name, body, options)
          threads_num = options.delete(:worker_thread_num)
          threads_num = UPLOAD_BLOB_WORKER_THREAD_COUNT if threads_num.nil? || !threads_num.is_a?(Integer) || threads_num < 1
          my_options = options.dup
          my_options[:content_length] = 0 unless my_options.key?(:content_length)
          begin
            # Initiate the upload
            Fog::Logger.debug "Creating the block blob #{container_name}/#{blob_name}. options: #{my_options}"
            content_md5 = my_options.delete(:content_md5)
            create_block_blob(container_name, blob_name, nil, my_options)

            # Uploading parts
            Fog::Logger.debug "Starting to upload parts for the block blob #{container_name}/#{blob_name}."
            iostream = BlockFileStream.new(body)

            threads = []
            threads_num.times do |id|
              thread = Thread.new do
                Fog::Logger.debug "Created upload thread #{id}."
                while (chunk = iostream.read(MAXIMUM_CHUNK_SIZE))
                  Fog::Logger.debug "Upload thread #{id} is uploading #{chunk.id}, size: #{chunk.data.size}, options: #{options}."
                  put_blob_block(container_name, blob_name, chunk.block_id, chunk.data, options)
                end
                Fog::Logger.debug "Upload thread #{id} finished."
              end
              thread.abort_on_exception = true
              threads << thread
            end

            threads.each(&:join)
            # Complete the upload
            options[:content_md5] = content_md5 unless content_md5.nil?
            Fog::Logger.debug "Commiting the block blob #{container_name}/#{blob_name}. options: #{options}"
            commit_blob_blocks(container_name, blob_name, iostream.blocks, options)
          rescue
            # Abort the upload & reraise
            begin
              delete_blob(container_name, blob_name)
            rescue => ex
              Fog::Logger.debug "Cannot delete the blob: #{container_name}/#{blob_name} after multipart_save_block_blob failed. #{ex.inspect}"
            end
            raise
          end

          Fog::Logger.debug "Successfully save the block blob: #{container_name}/#{blob_name}."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def multipart_save_block_blob(*)
          true
        end
      end
    end
  end
end
