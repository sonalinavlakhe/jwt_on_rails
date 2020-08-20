# require 'connection-pool'

RATE_LIMIT_REDIS_POOL = ConnectionPool.new{
  Redis.new(host: Figaro.env.REDIS_HOST, port: Figaro.env.REDIS_PORT)
}