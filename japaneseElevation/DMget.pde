import twitter4j.*;
import twitter4j.api.*;
import twitter4j.conf.*;
import twitter4j.http.*;
import twitter4j.internal.async.*;
import twitter4j.internal.http.*;
import twitter4j.internal.logging.*;
import twitter4j.internal.org.json.*;
import twitter4j.internal.util.*;
import twitter4j.util.*;
import twitter4j.Paging;
import twitter4j.DirectMessage;

import java.util.List;

final String consumerKey = ""; 
final String consumerSecret = "";
final String accessToken = "";
final String accessTokenSecret = "";

Twitter twitter;
OAuthRestAPI oauth;

class OAuthRestAPI {
  OAuthRestAPI() {
    //Configurationを生成するためのビルダーオブジェクトを生成
    ConfigurationBuilder cb = new ConfigurationBuilder();

    //キー設定
    cb.setOAuthConsumerKey(consumerKey);
    cb.setOAuthConsumerSecret(consumerSecret);
    cb.setOAuthAccessToken(accessToken);
    cb.setOAuthAccessTokenSecret(accessTokenSecret);

    //Twitterのインスタンスを生成
    twitter = new TwitterFactory(cb.build()).getInstance();
  }
}

String [] getLocation(String _str){
  String [] temp = _str.split(",");
  return temp;
}