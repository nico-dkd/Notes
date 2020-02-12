import Vapor
import Crypto

/// Register your application's routes here.
public func routes(_ router: Router) throws {
  
    let userController = UserController()
    
    let userRoute = router.grouped("api", "users")
    
    let userNoteRoute = router.grouped("api", "users", "notes")
    
    let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
    let guardAuthMiddleware = User.guardAuthMiddleware()
    
    let basicProtected = userRoute.grouped(basicAuthMiddleware, guardAuthMiddleware)
    
    basicProtected.post("login", use: userController.loginHandler)
    
    let tokenAuthMiddleware = User.tokenAuthMiddleware()
    let tokenProtected = userRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
    
    let noteTokenProtected = userNoteRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
    
    tokenProtected.get(use: userController.getAllHandler)
    tokenProtected.get(User.parameter, use: userController.getOneHandler)
    tokenProtected.put(User.parameter, use: userController.updateHandler)
    tokenProtected.post(use: userController.createHandler)
    tokenProtected.delete(User.parameter, use: userController.deleteHandler)
    tokenProtected.get("logout", use: userController.logout)
    noteTokenProtected.get(use: userController.getNotes)
    
    
    let noteRoute = router.grouped("api","note")
    
    let tokenAuthMiddelware = User.tokenAuthMiddleware()
    let tokenAuthGroup = noteRoute.grouped(tokenAuthMiddelware)
    
    let noteController = NoteController()
    
    tokenAuthGroup.post(use: noteController.createNote)
    tokenAuthGroup.delete(use: noteController.deleteHandler)
    tokenAuthGroup.delete(Note.parameter, use: noteController.deleteHandler)
}
