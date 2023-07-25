require 'securerandom'

module AuthService
  class RpcClient
    extend Dry::Initializer[undefined: false]

    option :connection, default: proc { start_connection }
    option :channel, default: proc { @connection.create_channel }
    option :reply_queue, default: proc { @channel.queue('user-id', durable: true) }
    option :correlation_id, default: proc { SecureRandom.uuid }
    option :lock, default: proc { Mutex.new }
    option :condition, default: proc { ConditionVariable.new }

    def auth(token)
      subscribe_to_reply_queue
      payload = { token: token }.to_json
      channel.queue('auth', durable: true).publish(payload, type: 'auth', correlation_id: @correlation_id)

      @lock.synchronize { @condition.wait(@lock) }

      @user_id
    end

    private

    attr_writer :user_id

    def start_connection
      @connection = Bunny.new(automatically_recover: false)
      @connection.start
    end

    def close_connection
      channel.close
      connection.close
    end

    def subscribe_to_reply_queue
      @reply_queue.subscribe do |_delivery_info, properties, payload|
        if properties[:correlation_id] == @correlation_id
          @user_id = JSON.parse(payload)['user_id']
          channel.queue('auth.rabbitmq.reply-to').publish('', correlation_id: properties.correlation_id)

          # sends the signal to continue the execution of #call
          @lock.synchronize { @condition.signal }
          close_connection
        end
      end
    end
  end
end
