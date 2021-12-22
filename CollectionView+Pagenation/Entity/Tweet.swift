//
//  Tweet.swift
//  Bish
//
//  Created by kou yamamoto on 2021/06/16.
//

import Foundation

protocol TweetBase {
    var id: Int { get }
    var created_at: String { get }
    var full_text: String { get }
    var extended_entities: Extended_entities? { get }
    var user: UserDetail { get }
    var retweet_count: Int { get }
    var favorite_count: Int { get }
}

// 画像付きのツイート
struct MediaTweet: Codable {
    let statuses: [Tweet]
    let search_metadata: SearchMetaData
}

struct SearchMetaData: Codable {
    let max_id: Int
}

struct CustomMediaTweet: Codable {
    let tweet: Tweet
    let media: Media
}

struct Tweet: TweetBase, Codable {
    let id: Int
    let created_at: String
    let full_text: String
    let extended_entities: Extended_entities?
    let user: UserDetail
    let retweet_count: Int
    let favorite_count: Int
    let is_quote_status: Bool
    let quoted_status: QuoteTweet?
    let retweeted_status: Retweet?
}

// ユーザー情報
struct UserDetail: Codable {
    let name: String
    let screen_name: String
    let location: String?
    let created_at: String
    let url: String?
    let description: String?
    let profile_image_url_https: String
    let profile_banner_url: String?
    let followers_count: Int
    let friends_count: Int
}

// 引用ツイート
struct QuoteTweet: TweetBase, Codable {
    let id: Int
    let created_at: String
    let full_text: String
    let extended_entities: Extended_entities?
    let user: UserDetail
    let retweet_count: Int
    let favorite_count: Int
}

// リツイート
struct Retweet: TweetBase, Codable {
    let id: Int
    let created_at: String
    let full_text: String
    let extended_entities: Extended_entities?
    let user: UserDetail
    let retweet_count: Int
    let favorite_count: Int
}

// 写真 or 動画
struct Extended_entities: Codable {
    let media: [Media]
}

struct Media: Codable {
    let type: String
    let media_url_https: String
    let video_info: Video_info?
}

struct Video_info: Codable {
   let variants: [Variants]
}

struct Variants: Codable {
    let url: String
}
