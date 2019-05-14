//
//  SocketIOManager.swift
//
//  Created by Vicky Prajapati.
//

import Foundation
import SocketIO

let kConversationCount = "conversation_count"

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()

    let manager: SocketManager = SocketManager(socketURL: URL(string: AppConstant.serverAPI.URL.kSocketUrl)!)
    var arrActiveChatList: [ChatUsersModel]?
    var arrChatUserList: [ChatUsersModel]?
    var unreadConversationCount = 0
    
    // handler
    var receiveMessageHandler: ((ChatModel)->())?
    var getMessageToSenderHandler: ((ChatModel)->())?
    var onlineStatusHandler: (([Int])->())?
    var updateUnreadConversationCountHandler : (()->())?
    var getLastMessageHandler : (()->())?
    var getChatHistoryRecallHandler : (()->())?
    var getChatUsersRecallHandler : (()->())?
    
    override init() {
        super.init()
        addHandler()
    }
    
    // MARK:- Socket basic rquired methods
    func establishConnection() {
        manager.defaultSocket.connect()
    }
    
    func closeConnection() {
        manager.defaultSocket.disconnect()
    }
    
    func addHandler(){
        manager.defaultSocket.on(clientEvent: .connect) {[weak self] (data, ack) in
            print("connected")
            print("Got event data: \(data), with ack: \(ack)")
            self?.setUserInfo()
            self?.getUnreadConversationCount()
            if self?.getChatHistoryRecallHandler != nil {
                self?.getChatHistoryRecallHandler!()
            }
            if self?.getChatUsersRecallHandler != nil {
                self?.getChatUsersRecallHandler!()
            }
            return
        }
        
        manager.defaultSocket.on(clientEvent: .statusChange) {(data, ack) in
            print("statusChange")
            print("Got event data: \(data), with ack: \(ack)")
            return
        }
        
        manager.defaultSocket.on(clientEvent: .error) {(data, ack) in
            print("error")
            print("Got event data: \(data), with ack: \(ack)")
            return
        }
        
        manager.defaultSocket.on(clientEvent: .disconnect) { (data, ack) in
            print("disconnect")
            print("Got event data: \(data), with ack: \(ack)")
            return
        }
        
        manager.defaultSocket.on("OnlineStatus") { [weak self] (data, ack) in
//            print("Online Status")
//            print("Got event data: \(data), with ack: \(ack)")
            if let res = data[0] as? [String:Any] {
                if res[kRes] as? String == kSuccess {
                    if let userData = res[kData] as? [[String:Any]] {
                        let arrOnlineUserId = userData.map({$0[kUserId] as? Int ?? 0})
                        self?.manageUserOnline(arrOnlineUserId: arrOnlineUserId)
                        if self?.onlineStatusHandler != nil {
                            self?.onlineStatusHandler!(arrOnlineUserId)
                        }
                    }
                }
            }
            return
        }
        
        manager.defaultSocket.on("GetMessage") { [weak self] (data, ack) in
            print("Get Message")
            print("Got event data: \(data), with ack: \(ack)")
            
            if let res = data[0] as? [String:Any] {
                if res[kRes] as? String == kSuccess {
                    if let chatData = res[kData] as? [String:Any] {
                        let objChatModel = ChatModel().modelWithDictionary(data: chatData)
                        if self?.receiveMessageHandler != nil {
                             self?.receiveMessageHandler!(objChatModel)
                        }
                    }
                }
            }
            self?.getUnreadConversationCount()
            return
        }
        
        manager.defaultSocket.on("GetLastMessage") { [weak self] (data, ack) in
            print("Get Last Message")
            print("Got event data: \(data), with ack: \(ack)")
            if let res = data[0] as? [String:Any] {
                if res[kRes] as? String == kSuccess {
                    if let userData = res[kData] as? [String:Any] {
                        let objChatUsersModel = ChatUsersModel().modelWithDictionary(data: userData)
                        self?.updateActiveChatList(objChatUsersModel: objChatUsersModel)
                        if self?.getLastMessageHandler != nil {
                            self?.getLastMessageHandler!()
                        }
                    }
                }
            }
            return
        }
        
        manager.defaultSocket.on("GetMessageToSender") { [weak self] (data, ack) in
            print("Get Message To Sender")
            print("Got event data: \(data), with ack: \(ack)")
            
            if let res = data[0] as? [String:Any] {
                if res[kRes] as? String == kSuccess {
                    if let data = res[kData] as? [String:Any] {
                        let objChatModel = ChatModel().modelWithDictionary(data: data)
                        let objChatUsersModel = ChatUsersModel().modelWithDictionary(data: data)
                        self?.updateActiveChatList(objChatUsersModel: objChatUsersModel)
                        if self?.getMessageToSenderHandler != nil {
                            self?.getMessageToSenderHandler!(objChatModel)
                        }
                    }
                }
            }
            return
        }
        
//        manager.defaultSocket.onAny {print("Extra call Got event: \($0.event), with items: \($0.items!)")}
    }
    
    // MARK:- Socket Emit Calls
    // Set  User Info
    func setUserInfo(){
        var dictParam = [String : Any]()
        dictParam[kCompanyId] = AppSingleton.sharedInstance.activeUser?.company?.company_id ?? 0
        dictParam[kUserId] = AppSingleton.sharedInstance.activeUser?.user?.user_id
        manager.defaultSocket.emitWithAck("UserInfo", dictParam).timingOut(after: 0) { data in
            print(data)
        }
    }
    
    // Get All Users
    func getAllUsers(search: String, pageNo: Int, success withResponse: @escaping ([ChatUsersModel],Int) -> (), failure: @escaping (_ error: String) -> Void){
        if (Utilities.checkInternetConnection()) {
            if SocketIOManager.sharedInstance.isSocketConnected() {
                var dictParam = [String : Any]()
                dictParam[kCompanyId] = AppSingleton.sharedInstance.activeUser?.company?.company_id ?? 0
                dictParam[kUserId] = AppSingleton.sharedInstance.activeUser?.user?.user_id
                dictParam[KRoleId] = AppSingleton.sharedInstance.activeUser?.role?.role_id
                dictParam[kPageRecord] = 50
                dictParam[kPageNo] = pageNo
                dictParam[kSearch] = search
                
                manager.defaultSocket.emitWithAck("GetAllUsers", dictParam).timingOut(after: 0) { data in
                    print(data)
                    if let res = data[0] as? [String:Any] {
                        if res[kRes] as? String == kSuccess {
                            let count = res[kCount] as? Int
                            var arrChatUsersModel = [ChatUsersModel]()
                            if let userData = res[kData] as? [[String:Any]] {
                                
                                for chatUsersModel in userData {
                                    let objChatUsersModel = ChatUsersModel().modelWithDictionary(data: chatUsersModel)
                                    arrChatUsersModel.append(objChatUsersModel)
                                }
                            }
                            withResponse(arrChatUsersModel, count ?? 0)
                        }else{
                            let msg = res[kMsg] as? String
                            Utilities.showCustomToast(message: msg)
                            failure(msg ?? "")
                        }
                    }
                }
            }else{
                Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kCommanErrorMessage)
                failure(AppConstant.serverAPI.errorMessages.kCommanErrorMessage)
            }
        }else{
            Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
            failure(AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
        }
        
    }
    
    // Get Chat Users
    func getChatUsers(success withResponse: @escaping ([ChatUsersModel]) -> (), failure: @escaping (_ error: String) -> Void){
        if (Utilities.checkInternetConnection()) {
            if SocketIOManager.sharedInstance.isSocketConnected() {
                var dictParam = [String : Any]()
                dictParam[kCompanyId] = AppSingleton.sharedInstance.activeUser?.company?.company_id ?? 0
                dictParam[kUserId] = AppSingleton.sharedInstance.activeUser?.user?.user_id
                manager.defaultSocket.emitWithAck("GetChatUsers", dictParam).timingOut(after: 0) { data in
                    print(data)
                    if let res = data[0] as? [String:Any] {
                        if res[kRes] as? String == kSuccess {
                            var arrChatUsersModel = [ChatUsersModel]()
                            if let userData = res[kData] as? [[String:Any]] {
                                
                                for chatUsersModel in userData {
                                    let objChatUsersModel = ChatUsersModel().modelWithDictionary(data: chatUsersModel)
                                    arrChatUsersModel.append(objChatUsersModel)
                                }
                            }
                            withResponse(arrChatUsersModel)
                        }else{
                            let msg = res[kMsg] as? String
                            Utilities.showCustomToast(message: msg)
                            failure(msg ?? "")
                        }
                    }
                }
            }else{
                Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kCommanErrorMessage)
                failure(AppConstant.serverAPI.errorMessages.kCommanErrorMessage)
            }
        }else{
            Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
            failure(AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
        }
    }
    
    // Send Message
    func SendMessage(to: Int?, mediaType: Int?, message: String, success withResponse: @escaping (ChatModel) -> (), failure: @escaping (_ error: String) -> Void){
        if (Utilities.checkInternetConnection()) {
            if SocketIOManager.sharedInstance.isSocketConnected() {
                var dictParam = [String : Any]()
                dictParam[kCompanyId] = AppSingleton.sharedInstance.activeUser?.company?.company_id ?? 0
                dictParam[kToUserId] = to
                dictParam[kFromUserId] = AppSingleton.sharedInstance.activeUser?.user?.user_id
                dictParam[kMediaType] = mediaType
                dictParam[kMessage] = message
                
                manager.defaultSocket.emitWithAck("SendMessage", dictParam).timingOut(after: 0) { data in
                    print(data)
                    if let res = data[0] as? [String:Any] {
                        if res[kRes] as? String == kSuccess {
                            if let chatData = res[kData] as? [String:Any] {
                                let objChatModel = ChatModel().modelWithDictionary(data: chatData)
                                withResponse(objChatModel)
                            }
                        }else{
                            let msg = res[kMsg] as? String
                            Utilities.showCustomToast(message: msg)
                            failure(msg ?? "")
                        }
                    }
                }
            }else{
                Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kCommanErrorMessage)
                failure(AppConstant.serverAPI.errorMessages.kCommanErrorMessage)
            }
        }else{
            Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
            failure(AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
        }
    }
    
    // Get Chat History
    func getChathistory(to: Int?, pageNo: Int, chat_id: Int, success withResponse: @escaping ([ChatModel],Int) -> (), failure: @escaping (_ error: String) -> Void) {
        if (Utilities.checkInternetConnection()) {
            if SocketIOManager.sharedInstance.isSocketConnected() {
                var dictParam = [String : Any]()
                dictParam[kCompanyId] = AppSingleton.sharedInstance.activeUser?.company?.company_id ?? 0
                dictParam[kToUserId] = to
                dictParam[kFromUserId] = AppSingleton.sharedInstance.activeUser?.user?.user_id
                dictParam[kPageRecord] = 100
                dictParam[kPageNo] = pageNo
                if chat_id > 0 {
                    dictParam[kChatId] = chat_id
                }
                
                manager.defaultSocket.emitWithAck("GetChatHistory", dictParam).timingOut(after: 0) { data in
                    print(data)
                    if let res = data[0] as? [String:Any] {
                        if res[kRes] as? String == kSuccess {
                            let count = res[kCount] as? Int
                            var arrChatModel = [ChatModel]()
                            if let chatData = res[kData] as? [[String:Any]] {
                                for chatModel in chatData {
                                    let objChatModel = ChatModel().modelWithDictionary(data: chatModel)
                                    arrChatModel.append(objChatModel)
                                }
                            }
                            withResponse(arrChatModel,count ?? 0)
                        }else{
                            let msg = res[kMsg] as? String
                            Utilities.showCustomToast(message: msg)
                            failure(msg ?? "")
                        }
                    }
                }
            }else{
                Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kCommanErrorMessage)
                failure(AppConstant.serverAPI.errorMessages.kCommanErrorMessage)
            }
        }else{
            Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
            failure(AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
        }
    }
    
    // Delete Chat
    func deleteChat(to: Int?, success withResponse: @escaping () -> (),failure: @escaping (_ error: String) -> Void) {
        if (Utilities.checkInternetConnection()) {
            if SocketIOManager.sharedInstance.isSocketConnected() {
                var dictParam = [String : Any]()
                dictParam[kCompanyId] = AppSingleton.sharedInstance.activeUser?.company?.company_id ?? 0
                dictParam[kToUserId] = to
                dictParam[kFromUserId] = AppSingleton.sharedInstance.activeUser?.user?.user_id
                
                manager.defaultSocket.emitWithAck("DeleteChat", dictParam).timingOut(after: 0) { data in
                    print(data)
                    if let res = data[0] as? [String:Any] {
                        if res[kRes] as? String == kSuccess {
                            let msg = res[kMsg] as? String
                            Utilities.showCustomToast(message: msg)
                            withResponse()
                        }else{
                            let msg = res[kMsg] as? String
                            Utilities.showCustomToast(message: msg)
                            failure(msg ?? "")
                        }
                    }
                }
            }else{
                Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kCommanErrorMessage)
                failure(AppConstant.serverAPI.errorMessages.kCommanErrorMessage)
            }
        }else{
            Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
            failure(AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
        }
    }
    
    // Update Unread Message
    func updateUnreadMessage(toUserId: Int?) {
        if (Utilities.checkInternetConnection()) {
            if SocketIOManager.sharedInstance.isSocketConnected() {
                var dictParam = [String : Any]()
                dictParam[kCompanyId] = AppSingleton.sharedInstance.activeUser?.company?.company_id ?? 0
                dictParam[kToUserId] = toUserId
                dictParam[kFromUserId] = AppSingleton.sharedInstance.activeUser?.user?.user_id
                
                manager.defaultSocket.emitWithAck("UpdateUnreadMessage", dictParam).timingOut(after: 0) { data in
                    print(data)
                    if let res = data[0] as? [String:Any] {
                        print("\(res[kMsg] as? String ?? "")")
                    }
                    print("All unmessage read")
                }
            }else{
//                Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kCommanErrorMessage)
            }
        }else{
//            Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
        }
    }
    
    // conversation Count
    func getUnreadConversationCount() {
        if (Utilities.checkInternetConnection()) {
            if SocketIOManager.sharedInstance.isSocketConnected() {
                var dictParam = [String : Any]()
                dictParam[kCompanyId] = AppSingleton.sharedInstance.activeUser?.company?.company_id ?? 0
                dictParam[kFromUserId] = AppSingleton.sharedInstance.activeUser?.user?.user_id
                
                manager.defaultSocket.emitWithAck("ConversationCount", dictParam).timingOut(after: 0) { data in
                    print(data)
                    if let res = data[0] as? [String:Any] {
                        if res[kRes] as? String == kSuccess {
                            if let convesationData = res[kData] as? [String:Any]{
                                self.unreadConversationCount = convesationData[kConversationCount] as? Int ?? 0
                                if self.updateUnreadConversationCountHandler != nil {
                                    self.updateUnreadConversationCountHandler!()
                                }
                            }
                        }
                    }
                }
            }else{
//                Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kCommanErrorMessage)
            }
        }else{
//            Utilities.showCustomToast(message: AppConstant.serverAPI.errorMessages.kNoInternetConnectionMessage)
        }
    }
    
    // MARK:- Private Methods
    func manageUserOnline(arrOnlineUserId: [Int]){
        // Update active chat list
        if let arrActiveChatList = self.arrActiveChatList {
            for objChatUser in arrActiveChatList{
                objChatUser.is_online = arrOnlineUserId.contains(objChatUser.to_user_id ?? 0) == true ? 1 : 0
            }
        }
        
        // Update user list
        if let arrChatUserList = self.arrChatUserList {
            for objChatUser in arrChatUserList{
                objChatUser.is_online = arrOnlineUserId.contains(objChatUser.to_user_id ?? 0) == true ? 1 : 0
            }
        }
    }
    
    // Update Active Chat List (based on get last message)
    func updateActiveChatList(objChatUsersModel: ChatUsersModel?) {
        // Update active chat list
        if let objChatUsersModel = objChatUsersModel{
            if let arrActiveChatList = self.arrActiveChatList {
                if let index = arrActiveChatList.map({$0.to_user_id}).firstIndex(of: objChatUsersModel.to_user_id) {
                    self.arrActiveChatList?.remove(at: index)
                    self.arrActiveChatList?.insert(objChatUsersModel, at: 0)
                }else{
                    self.arrActiveChatList?.insert(objChatUsersModel, at: 0)
                }
            }
        }
    }
    
    func isSocketConnected() -> Bool {
        
        if SocketIOManager.sharedInstance.manager.defaultSocket.status == .connected{
            return true
        }else{
            return false
        }
    }
}
