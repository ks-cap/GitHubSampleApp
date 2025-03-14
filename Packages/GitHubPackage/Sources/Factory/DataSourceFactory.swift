import Data
import KeychainAccessCore

enum DataSourceFactory {
    static func create() -> AccessTokenLocalDataSource {
        AccessTokenDataSource(localDataSource: KeychainAccessDefaultClient.shared)
    }

    static func create() -> UsersRemoteDataSource {
        UsersAlamofireDataSource(service: APIDefaultService())
    }
    
    static func create() -> UserReposRemoteDataSource {
        UserReposAlamofireDataSource(service: APIDefaultService())
    }
}
