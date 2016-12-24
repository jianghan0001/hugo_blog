
+++
date = "2016-12-20T10:44:55+08:00"
draft = false
title = "maven-redis"
tags = [
  "framework"
,"java"
]
+++
## maven项目添加redis支持

redis.properties

		#config for redis
		redis.pool.maxActive=512
		redis.pool.maxIdle=100
		redis.pool.maxWait=100000
		redis.pool.testOnBorrow=true
		redis.pool.testOnReturn=true
		redis.ip=127.0.0.1
		redis.port=6379
		redis.expire=1200


pom.xml 依赖包


	<!-- https://mvnrepository.com/artifact/org.apache.commons/commons-lang3 -->

    <dependency>
      <groupId>org.apache.commons</groupId>
      <artifactId>commons-lang3</artifactId>
      <version>3.4</version>
    </dependency>

    <!-- redis.properties -->
    <dependency>
      <groupId>redis.clients</groupId>
      <artifactId>jedis</artifactId>
      <version>2.1.0</version>
    </dependency>


java -- RedisUtils  进行存取操作

		public class RedisUtils {
	
	    protected static JedisPool jedispool;
	    protected static int EXPIRE = 130;
	
	    static{
	        Locale locale1 = new Locale("zh", "CN");
	        ResourceBundle bundle = ResourceBundle.getBundle("redis",locale1);
	        if (bundle == null) {
	            throw new IllegalArgumentException(
	                    "[redis.properties] is not found!");
	        }
	
	        EXPIRE = Integer.valueOf(bundle.getString("redis.expire"));
	
	        JedisPoolConfig jedisconfig = new JedisPoolConfig();
	        jedisconfig.setMaxActive(Integer.valueOf(bundle
	                .getString("redis.pool.maxActive")));
	        jedisconfig.setMaxIdle(Integer.valueOf(bundle
	                .getString("redis.pool.maxIdle")));
	        jedisconfig.setMaxWait(Long.valueOf(bundle
	                .getString("redis.pool.maxWait")));
	        jedisconfig.setTestOnBorrow(Boolean.valueOf(bundle
	                .getString("redis.pool.testOnBorrow")));
	        jedisconfig.setTestOnReturn(Boolean.valueOf(bundle
	                .getString("redis.pool.testOnReturn")));
	        jedispool = new JedisPool(jedisconfig, bundle.getString("redis.ip"),
	                Integer.valueOf(bundle.getString("redis.port")), 100000);
	    }
	
	    public static Jedis getJedis() {
	        Jedis jedis = null;
	        try {
	            jedis = jedispool.getResource();
	        } catch (JedisConnectionException jce) {
	            jce.getStackTrace();
	            try {
	                Thread.sleep(3000);
	            } catch (InterruptedException e) {
	                jce.getStackTrace();
	            }
	            jedis = jedispool.getResource();
	        }
	        return jedis;
	    }
	
	    public static void returnResource(Jedis jedis) {
	        if (jedis != null) {
	            jedispool.returnResource(jedis);
	        }
	    }
	
	    public static void setKey(String key , String value , int seconds){
	        Jedis jedis = getJedis();
	        jedis.set(key,value);
	        jedis.expire(key,seconds);
	        returnResource(jedis);
	    }
	
	    public static String getKey(String key){
	        Jedis jedis = getJedis();
	        String value = jedis.get(key);
	        returnResource(jedis);
	        return value;
	    }
	
	    public static void del(String s) {
	        Jedis jedis = getJedis();
	        jedis.del(s);
	        returnResource(jedis);
	    }
	
	    public static void expire(String s, int i) {
	
	        Jedis jedis = getJedis();
	        jedis.expire(s,i);
	        returnResource(jedis);
	
	    }
	}




