import FluentSQLite
import Vapor
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentSQLiteProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Configure directory file-system
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    
    // Configure FluentSQLite
    try services.register(FluentSQLiteProvider())
    try services.register(AuthenticationProvider())
    // Configure file to save files to
    var databaseConfig = DatabasesConfig()
    let db = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)Notes.db"))
    databaseConfig.add(database: db, as: .sqlite) // attaches database to this variable (.sqlite) to refer to it in the future easily
    services.register(databaseConfig)
    
    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .sqlite)
    migrations.add(migration: AdminUser.self, database: .sqlite)
    migrations.add(model: Token.self, database: .sqlite)
    migrations.add(model: Note.self, database: .sqlite)
    services.register(migrations)
}
