import Data
import Domain

enum RepositoryFactory {
    static func create() -> AccessTokenRepository {
        AccessTokenDefaultRepository(localDataSource: DataSourceFactory.create())
    }

    static func create() -> UsersRepository {
        UsersDefaultRepository(remoteDataSource: DataSourceFactory.create())
    }
    
    static func create() -> UserReposRepository {
        UserReposDefaultRepository(remoteDataSource: DataSourceFactory.create())
    }
}

enum ValidatorFactory {
    static func create() -> GitHubValidator {
        GitHubDefaultValidator()
    }
}
