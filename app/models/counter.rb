class Counter
  def initialize(operation, options = {})
    @operation = operation
    @attempts = options[:attempts]
    @interval = options[:interval]
    @cooldown_time = options[:expires_in]
    @key = options[:key]
  end

  def rate_limiting_exceeded?
    redis_pool.with do |connection|
      value = connection.get(counter_name).to_i
      return set_cooldown(connection) if value == @attempts
      value >= @attempts
    end
  end

  def increment
    redis_pool.with do |connection|
      connection.set(counter_name, 0, {nx: true, ex: @interval})
      connection.incr(counter_name)
    end
  end

  private

  def set_cooldown(connection)
    connection.expire(counter_name, @cooldown_time )
  end 

  def counter_name
    suffix = @key ? "::#{@key}" : ''
    "rate_limit::#{@operation}" + suffix
  end

  def redis_pool
    RATE_LIMIT_REDIS_POOL
  end
end