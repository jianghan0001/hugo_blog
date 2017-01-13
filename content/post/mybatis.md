
+++
tags = ["mybatis"]
title = "mybatis学习笔记"
draft = false
date = "2017-01-13T12:54:24+02:00"

+++


[http://www.mybatis.org/mybatis-3/zh/getting-started.html](http://www.mybatis.org/mybatis-3/zh/getting-started.html)


对于这个简单的例子来说似乎有点小题大做了，但实际上它是非常轻量级的。在一个 XML 映射文件中，你想定义多少个映射语句都是可以的，这样下来，XML 头部和文档类型声明占去的部分就显得微不足道了。文件的剩余部分具有很好的自解释性。在命名空  间“org.mybatis.example.BlogMapper”中定义了一个名为“selectBlog”的映射语句，这样它就允许你使用指定的完全限定名“org.mybatis.example.BlogMapper.selectBlog”来调用映射语句，就像上面的例子中做的那样：
 
Blog blog = (Blog) session.selectOne("org.mybatis.example.BlogMapper.selectBlog", 101);  

你可能注意到这和使用完全限定名调用 Java 对象的方法是相似的，之所以这样做是有原因的。这个命名可以直接映射到在命名空间中同名的 Mapper 类，并在已映射的 select 语句中的名字、参数和返回类型匹配成方法。这样你就可以向上面那样很容易地调用这个对应 Mapper 接口的方法。不过让我们再看一遍下面的例子：
 
BlogMapper mapper = session.getMapper(BlogMapper.class);
Blog blog = mapper.selectBlog(101);  

第二种方法有很多优势，首先它不是基于字符串常量的，就会更安全；其次，如果你的 IDE 有代码补全功能，那么你可以在有了已映射 SQL 语句的基础之上利用这个功能。  



    package org.mybatis.example;
    public interface BlogMapper {
      @Select("SELECT * FROM blog WHERE id = #{id}")
      Blog selectBlog(int id);
    }


对于简单语句来说，注解使代码显得更加简洁，然而 Java 注解对于稍微复杂的语句就会力不从心并且会显得更加混乱。因此，如果你需要做很复杂的事情，那么最好使用 XML 来映射语句。

选择何种方式以及映射语句的定义的一致性对你来说有多重要这些完全取决于你和你的团队。换句话说，永远不要拘泥于一种方式，你可以很轻松的在基于注解和 XML 的语句映射方式间自由移植和切换。

    <insert id="insertAuthor">
      insert into Author (id,username,password,email,bio)
      values (#{id},#{username},#{password},#{email},#{bio})
    </insert>
    
    <update id="updateAuthor">
      update Author set
    username = #{username},
    password = #{password},
    email = #{email},
    bio = #{bio}
      where id = #{id}
    </update>
    
    <delete id="deleteAuthor">
      delete from Author where id = #{id}
    </delete>



    <insert id="insertAuthor" useGeneratedKeys="true"
    keyProperty="id">
      insert into Author (username,password,email,bio)
      values (#{username},#{password},#{email},#{bio})
    </insert>



    <insert id="insertAuthor" useGeneratedKeys="true"
    keyProperty="id">
      insert into Author (username, password, email, bio) values
      <foreach item="item" collection="list" separator=",">
    (#{item.username}, #{item.password}, #{item.email}, #{item.bio})
      </foreach>
    </insert>


##### sql

这个元素可以被用来定义可重用的 SQL 代码段，可以包含在其他语句中。它可以被静态地(在加载参数) 参数化. 不同的属性值通过包含的实例变化. 比如：

    <sql id="userColumns"> ${alias}.id,${alias}.username,${alias}.password </sql>
	<select id="selectUsers" resultType="map">
 		 select
    <include refid="userColumns"><property name="alias" value="t1"/></include>,
    <include refid="userColumns"><property name="alias" value="t2"/></include>
  		from some_table t1
    	cross join some_table t2
	</select>



例子

    <sql id="sometable">
      ${prefix}Table
    </sql>
    
    <sql id="someinclude">
      from
    <include refid="${include_target}"/>
    </sql>
    
    <select id="select" resultType="map">
      select
    field1, field2, field3
      <include refid="someinclude">
    <property name="prefix" value="Some"/>
    <property name="include_target" value="sometable"/>
      </include>
    </select>



resultTpe:

    <select id="selectUsers" resultType="com.someapp.model.User">
      select id, username, hashedPassword
      from some_table
      where id = #{id}
    </select>


    <!-- In mybatis-config.xml file -->
    <typeAlias type="com.someapp.model.User" alias="User"/>
    
    <!-- In SQL Mapping XML file -->
    <select id="selectUsers" resultType="User">
      select id, username, hashedPassword
      from some_table
      where id = #{id}
    </select>


这些情况下,MyBatis 会在幕后自动创建一个 ResultMap,基于属性名来映射列到 JavaBean 的属性上。如果列名没有精确匹配,你可以在列名上使用 select 字句的别名(一个 基本的 SQL 特性)来匹配标签。比如:

    <select id="selectUsers" resultType="User">
      select
    user_id as "id",
    user_name   as "userName",
    hashed_password as "hashedPassword"
      from some_table
      where id = #{id}
    </select>



resultMap：

    <resultMap id="userResultMap" type="User">
      <id property="id" column="user_id" />
      <result property="username" column="user_name"/>
      <result property="password" column="hashed_password"/>
    </resultMap>


引用它的语句使用 resultMap 属性就行了(注意我们去掉了 resultType 属性)。比如:

    <select id="selectUsers" resultMap="userResultMap">
      select user_id, user_name, hashed_password
      from some_table
      where id = #{id}
    </select>




关联：



    <resultMap id="blogResult" type="Blog">
      <id property="id" column="blog_id" />
      <result property="title" column="blog_title"/>
      <association property="author" column="blog_author_id" javaType="Author" resultMap="authorResult"/>
    </resultMap>
    
    <resultMap id="authorResult" type="Author">
      <id property="id" column="author_id"/>
      <result property="username" column="author_username"/>
      <result property="password" column="author_password"/>
      <result property="email" column="author_email"/>
      <result property="bio" column="author_bio"/>
    </resultMap>


相同resultMap两个关联使用，association中加columnPrefix="co_"：


    <select id="selectBlog" resultMap="blogResult">
      select
    B.idas blog_id,
    B.title as blog_title,
    A.idas author_id,
    A.username  as author_username,
    A.password  as author_password,
    A.email as author_email,
    A.bio   as author_bio,
    CA.id   as co_author_id,
    CA.username as co_author_username,
    CA.password as co_author_password,
    CA.emailas co_author_email,
    CA.bio  as co_author_bio
      from Blog B
      left outer join Author A on B.author_id = A.id
      left outer join Author CA on B.co_author_id = CA.id
      where B.id = #{id}
    </select>


    <resultMap id="authorResult" type="Author">
      <id property="id" column="author_id"/>
      <result property="username" column="author_username"/>
      <result property="password" column="author_password"/>
      <result property="email" column="author_email"/>
      <result property="bio" column="author_bio"/>
    </resultMap>


    <resultMap id="blogResult" type="Blog">
      <id property="id" column="blog_id" />
      <result property="title" column="blog_title"/>
      <association property="author"
    resultMap="authorResult" />
      <association property="coAuthor"
    resultMap="authorResult"
    columnPrefix="co_" />
    </resultMap>



集合关联：

我们又一次联合了博客表和文章表,而且关注于保证特性,结果列标签的简单映射。现 在用文章映射集合映射博客,可以简单写为:


    <resultMap id="blogResult" type="Blog">
      <id property="id" column="blog_id" />
      <result property="title" column="blog_title"/>
      <collection property="posts" ofType="Post">
    <id property="id" column="post_id"/>
    <result property="subject" column="post_subject"/>
    <result property="body" column="post_body"/>
      </collection>
    </resultMap>

或

    <resultMap id="blogResult" type="Blog">
      <id property="id" column="blog_id" />
      <result property="title" column="blog_title"/>
      <collection property="posts" ofType="Post" resultMap="blogPostResult" columnPrefix="post_"/>
    </resultMap>
    
    <resultMap id="blogPostResult" type="Post">
      <id property="id" column="id"/>
      <result property="subject" column="subject"/>
      <result property="body" column="body"/>
    </resultMap>



##### 鉴别器


    <resultMap id="vehicleResult" type="Vehicle">
      <id property="id" column="id" />
      <result property="vin" column="vin"/>
      <result property="year" column="year"/>
      <result property="make" column="make"/>
      <result property="model" column="model"/>
      <result property="color" column="color"/>
      <discriminator javaType="int" column="vehicle_type">
    <case value="1" resultMap="carResult"/>
    <case value="2" resultMap="truckResult"/>
    <case value="3" resultMap="vanResult"/>
    <case value="4" resultMap="suvResult"/>
      </discriminator>
    </resultMap>



##### 缓存

MyBatis 包含一个非常强大的查询缓存特性,它可以非常方便地配置和定制。MyBatis 3 中的缓存实现的很多改进都已经实现了,使得它更加强大而且易于配置。

默认情况下是没有开启缓存的,除了局部的 session 缓存,可以增强变现而且处理循环 依赖也是必须的。要开启二级缓存,你需要在你的 SQL 映射文件中添加一行:

<cache/>



##### if
动态 SQL 通常要做的事情是有条件地包含 where 子句的一部分。比如:

    <select id="findActiveBlogWithTitleLike"
     resultType="Blog">
      SELECT * FROM BLOG 
      WHERE state = ‘ACTIVE’ 
      <if test="title != null">
    AND title like #{title}
      </if>
    </select>



##### choose, when, otherwise
有些时候，我们不想用到所有的条件语句，而只想从中择其一二。针对这种情况，MyBatis 提供了 choose 元素，它有点像 Java 中的 switch 语句。

还是上面的例子，但是这次变为提供了“title”就按“title”查找，提供了“author”就按“author”查找，若两者都没有提供，就返回所有符合条件的BLOG（实际情况可能是由管理员按一定策略选出BLOG列表，而不是返回大量无意义的随机结果）。
 
    <select id="findActiveBlogLike"
     resultType="Blog">
      SELECT * FROM BLOG WHERE state = ‘ACTIVE’
      <choose>
    <when test="title != null">
      AND title like #{title}
    </when>
    <when test="author != null and author.name != null">
      AND author_name like #{author.name}
    </when>
    <otherwise>
      AND featured = 1
    </otherwise>
      </choose>
    </select>


##### trim, where, set

    <trim prefix="WHERE" prefixOverrides="AND |OR ">
      ... 
    </trim>


	<update id="updateAuthorIfNecessary">
	  update Author
	    <set>
	      <if test="username != null">username=#{username},</if>
	      <if test="password != null">password=#{password},</if>
	      <if test="email != null">email=#{email},</if>
	      <if test="bio != null">bio=#{bio}</if>
	    </set>
	  where id=#{id}
	</update>


	<trim prefix="SET" suffixOverrides=",">
	  ...
	</trim>


##### foreach


	<select id="selectPostIn" resultType="domain.blog.Post">
	  SELECT *
	  FROM POST P
	  WHERE ID in
	  <foreach item="item" index="index" collection="list"
	      open="(" separator="," close=")">
	        #{item}
	  </foreach>
	</select>