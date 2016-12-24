+++
date = "2016-12-20T10:44:55+08:00"
draft = false
title = "aws云存储"
tags = [
  "framework"
]


### 亚马逊云存储 java接口使用


sdk下载链接

>https://s3.cn-north-1.amazonaws.com.cn/aws-sdks/java/latest/aws-java-sdk.zip

api文档

>http://docs.amazonaws.cn/zh_cn/AWSJavaSDK/latest/javadoc/index.html

 

pom.xml 依赖

     <!-- amazon -->
    <dependency>
      <groupId>com.amazonaws</groupId>
      <artifactId>aws-java-sdk-s3</artifactId>
    </dependency>

  	</dependencies>

  	<dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>com.amazonaws</groupId>
        <artifactId>aws-java-sdk-bom</artifactId>
        <version>1.11.22</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  	</dependencyManagement>






AwsUtils:

	package com.saudio.common.utils;

	import com.amazonaws.AmazonClientException;
	import com.amazonaws.auth.AWSCredentials;
	import com.amazonaws.auth.BasicAWSCredentials;
	import com.amazonaws.regions.Region;
	import com.amazonaws.regions.Regions;
	import com.amazonaws.services.s3.AmazonS3;
	import com.amazonaws.services.s3.AmazonS3Client;
	import com.amazonaws.services.s3.model.CannedAccessControlList;
	import com.amazonaws.services.s3.model.DeleteObjectRequest;
	import com.amazonaws.services.s3.model.PutObjectRequest;
	import com.amazonaws.services.s3.transfer.TransferManager;
	import com.amazonaws.services.s3.transfer.TransferManagerConfiguration;
	import com.amazonaws.services.s3.transfer.TransferProgress;
	import com.amazonaws.services.s3.transfer.Upload;
	import com.saudio.common.constant.Constant;
	import org.apache.log4j.Logger;
	import org.springframework.util.StringUtils;

	import java.io.InputStream;


	public class AwsUtils {

    private static final Logger logger = Logger.getLogger(AwsUtils.class);
    private static AWSCredentials credentials = null;
    private static AmazonS3 s3 = null;
    private static Region usWest2 = null;

    private static final String accessKeyID = Constant.ACCESS_KEYID;
    private static final String secretKey = Constant.SECRET_KEY;
    private static final String bucketName = Constant.BUCKET_NAME;


    static {

        try {

            credentials = new BasicAWSCredentials(accessKeyID,secretKey);

        } catch (Exception e) {

            throw new AmazonClientException(
                    "Cannot load the credentials from the credential profiles file. " +
                            "Please make sure that your credentials file is at the correct " +
                            "location (~/.aws/credentials), and is in valid format.",
                    e);
        }

        s3 = new AmazonS3Client(credentials);
        usWest2 = Region.getRegion(Regions.US_WEST_2);
        s3.setRegion(usWest2);

    }

    public static boolean pushObject(String md5_key, InputStream inputStream){

        try {
            PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, md5_key, inputStream, null)
                    .withCannedAcl(CannedAccessControlList.PublicRead);
            s3.putObject(putObjectRequest);
            return true;
        }catch (Exception e){
            e.printStackTrace();
            logger.error(e);
            return false;
        }
    }


    public static boolean pushObjectMultiThread(String md5_key, InputStream inputStream){

        try {

            TransferManager tm = new TransferManager(s3);
            TransferManagerConfiguration conf = tm.getConfiguration();

            long threshold = 4 * 1024 * 1024;
            conf.setMultipartCopyThreshold(threshold);
            tm.setConfiguration(conf);

            Upload upload = tm.upload(bucketName, md5_key, inputStream, null);
            TransferProgress p = upload.getProgress();

            while (upload.isDone() == false) {
                int percent = (int) (p.getPercentTransferred());
                System.out.print("\r" + " - " + "[ " + percent + "% ] "
                        + p.getBytesTransferred() + " / " + p.getTotalBytesToTransfer());
                // Do work while we wait for our upload to complete...
                Thread.sleep(500);
            }

            System.out.print("\r" + " - " + "[ 100% ] "
                    + p.getBytesTransferred() + " / " + p.getTotalBytesToTransfer());

            s3.setObjectAcl(bucketName, md5_key, CannedAccessControlList.PublicRead);

            return true;
        }catch (Exception e){
            e.printStackTrace();
            return false;
        }

    }



    public static boolean objectExits(String md5_key){
        boolean b = s3.doesObjectExist(bucketName,md5_key);
        if(b){
            return true;
        }
        return false;
    }

    public static boolean deleteObject(String key){

        try {

            DeleteObjectRequest request = new DeleteObjectRequest(bucketName, key);
            s3.deleteObject(request);
            return true;
        }catch (Exception e){
            e.printStackTrace();
            return false;
        }

    }

    public static boolean deleteObjects(String[] keys) {

            if (keys != null) {
                for (String key : keys) {
                    if (!StringUtils.isEmpty(key)) {
                        if(!deleteObject(key)) {
                            return false;
                        }
                    }
                }
                return true;
            }
            return false;
    }

	}


