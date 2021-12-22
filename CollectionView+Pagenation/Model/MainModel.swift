//
//  MainModel.swift
//  CollectionView+Pagenation
//
//  Created by kou yamamoto on 2021/12/08.
//

import Foundation
import RxSwift
import Alamofire

protocol TwitterRepositoryType {
    func fetchMediaTweet(shouldRefresh: Bool, query: String, filter: String) -> Single<MediaTweet>
}

final class TwitterRepository: TwitterRepositoryType {

    private var mediaMaxID: Int?
    private let url = "https://api.twitter.com/1.1/search/tweets.json"

    private let headers: HTTPHeaders = ["Authorization": "Bearer AAAAAAAAAAAAAAAAAAAAACHTQgEAAAAAWxWvliA1atTYmWrRbCovauR%2FL5U%3Dg5TfGTmFUxyugvn60KpDZe2jySu9J4ncXHvMsgveXqiqliv4Ip"]

    func fetchMediaTweet(shouldRefresh: Bool, query: String, filter: String) -> Single<MediaTweet> {
        var parameters: Parameters = ["q": "\(query) filter:\(filter) lang:ja", "result_type": "popular", "count": 10, "tweet_mode": "extended"]
        if !shouldRefresh { parameters["max_id"] = mediaMaxID }
        return self.apiRequest(parameters: parameters, headers: self.headers)
    }

    func apiRequest(parameters: Parameters, headers: HTTPHeaders) -> Single<MediaTweet> {

        return Single<MediaTweet>.create { single in

            AF.request(self.url, parameters: parameters, headers: headers).validate().responseJSON { response in

                guard let data = response.data else { return }

                switch response.result {
                case .success:
                    guard let tweet = try? JSONDecoder().decode(MediaTweet.self, from: data) else {
                        single(.failure(APIError.noResult))
                        return
                    }
                    self.mediaMaxID = tweet.statuses.last?.id
                    single(.success(tweet))
                case .failure:
                    single(.failure(APIError.noResult))
                }
            }
            return Disposables.create()
        }
    }
}
