import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
  
    let userController = UserController()

    try userController.boot(router: router)
    
    let tokenAuthMiddelware = User.tokenAuthMiddleware()
    let tokenAuthGroup = router.grouped(tokenAuthMiddelware)
    
    tokenAuthGroup.post("api/note", use: NoteController.createNote)
}
