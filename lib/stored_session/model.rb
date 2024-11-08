module StoredSession::Model
  extend ActiveSupport::Concern

  included do
    serialize :data, coder: ActiveSupport::MessagePack, type: Hash
    encrypts :data, message_serializer: ActiveRecord::Encryption::MessagePackMessageSerializer.new

    scope :by_sid, ->(sid) { where(sid: sid) }
  end

  module ClassMethods
    def read(sid)
      without_query_cache do
        select(:data).find_by(sid: sid)&.data
      end
    end

    def write(sid, data)
      without_query_cache do
        upsert({ sid:, data: }, unique_by: upsert_unique_by, on_duplicate: :update, update_only: %i[sid data])
      end
      true
    rescue ActiveRecord::SerializationTypeMismatch
      false
    end

    def expire(max_created_age: nil, max_updated_age: nil)
      max_created_threshold = (max_created_age || StoredSession.config.session_max_created_age).ago
      max_updated_threshold = (max_updated_age || StoredSession.config.session_max_updated_age).ago
      where(created_at: ...max_created_threshold).or(where(updated_at: ...max_updated_threshold)).in_batches.delete_all
    end

    def expire_later(max_created_age: nil, max_updated_age: nil)
      StoredSession::ExpireSessionsJob.perform_later(max_created_age: max_created_age, max_updated_age: max_updated_age)
    end

    def uncached_count
      without_query_cache { count }
    end

    private
      def upsert_unique_by
        connection.supports_insert_conflict_target? ? :sid : nil
      end

      def without_query_cache(&)
        uncached(dirties: false, &)
      end
  end

  ActiveSupport.run_load_hooks(:stored_session_model, self)
end
