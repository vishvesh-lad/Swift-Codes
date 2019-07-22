//
//  GlobalDataValues.swift
//  HomeInspectTech
//
//  Created by Vicky Prajapati on 2/6/18.
//  Copyright © 2018 Differenz System Pvt. Ltd. All rights reserved.
//

import Foundation

enum UserRoleEnum : Int, CustomStringConvertible {
    case SuperAdmin = 1,
    CompanyAdmin = 2,
    Inspector = 3,
    Owner = 4,
    Customer = 5,
    Agent = 6,
    OfficeManager = 7,
    MarketingCompany = 8,
    CallCenter = 10,
    SalesPerson = 11,
    Developer = 12,
    Support = 13,
    AnonymousUser = 14
    var description: String {
        switch self {
        case .SuperAdmin:
            return "Super Admin"
        case .CompanyAdmin:
            return "Company Admin"
        case .Inspector:
            return "Inspector"
        case .Owner:
            return "Owner"
        case .Customer:
            return "Client"
        case .Agent:
            return "Agent"
        case .OfficeManager:
            return "Office Manager"
        case .MarketingCompany:
            return "Marketing Company"
        case .CallCenter:
            return "Call Center"
        case .SalesPerson:
            return "Sales Person"
        case .Developer:
            return "Developer"
        case .Support:
            return "Support"
        case .AnonymousUser:
            return "Anonymous User"
        }
    }
}

enum PaymentServiceEnum : Int {
    case Stripe = 1,
    AuthorizeDotNet,
    EProcessingNetwork,
    SignatureCard,
    SquareUp
}

enum PaymentTypeEnum: Int{
    case Cash = 1,
    Cheque = 2,
    CardManually = 3,
    CardSwipe = 4,
    WaivedFee = 5,
    MoneyOrder = 6,
    ETransfer = 7
}

enum DrawerItemType: CaseIterable{
    case Dashboard,
    CreateAppointment,
    MyProfile,
    InspectionHistory,
    ManageExpenses,
    Chat,
    ChangePassword,
    Settings,
    Sync,
    Subscription,
    SupportTickets,
    Logout;
}

enum SectionDetailsRefreshFlow{
    case ChooseCommentFlowInSection,
    AddUseItSectionMediaFlow,
    CopiedMedia
}

enum OptionCategoryEnum : Int64 {
    case ContactTypes = 1,
    FeeTypes,
    PayRateTypes,
    PropertyTypes,
    VendorType,
    TemplatesType,
    ItemType
}

enum FetchInspectionTypeEnum : CaseIterable{
    case isDashBoardData,
    isYesterDayToLastweekData,
    isCustomRange
    
    var name: String {
        get { return String(describing: self) }
    }
}

enum FilterTypeEnum : Int{
    case Schedule = 1,
    Today,
    Yesterday,
    Tommorow,
    ThisWeek,
    LastWeek,
    LastMonth,
    Custom,
    ExceptToday,
    All,
    Before7Days
}

enum FeeTypesEnum: Int{
    case Variable = 5
    case Quotation = 6
    case Fixed = 7
}

enum CountryEnum: Int, CustomStringConvertible{
    case USA = 1
    case Canada = 2
    var description: String{
        switch self{
        case .USA:
            return "US"
        case .Canada:
            return "CA"
        }
    }
}

enum TemplateDetailOptionIdEnum : Int {
    case ReportIntroduction = 28,
    Sections = 29,
    BackPage = 75
}

enum SectionItemOptionIdEnum : Int {
    case SectionStandard = 32,
    Limitation = 33,
    ImportantInformation = 34,
    InspectionItem = 35,
    HomeEnergy = 36,
    RecallCheck = 76
}

enum SwipeCellAction {
    case copy, edit, delete
}

enum JPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
}

enum MainExpandCellType {
    case report, section, summary, backPage, priority, media, question, reportVideo, review
}

enum InspectionTemplatePriority: Int16 {
    case none = 0
    case high = 1
    case medium = 2
    case low = 3
    case finalReview = 4
    case bookmark = 5
}

enum EntityListPriorityEnum: Int16, CaseIterable {
    case Inspection_Property = 1,
    Brand,
    Inspection_Templates,
    Template_Summary,
    Template_Section,
    Template_Section_Item,
    Material_Categories,
    Material_Options,
    Section_Item_Status,
    Item_Comment_Master,
    Item_Comment,
    Item_Comment_Media,
    Item_Comment_Summary,
    Item_Comment_Contractor,
    Item_Comment_Diy_Information,
    Item_Comment_Industry_Pricing,
    Section_Item_Appliances,
    Section_Item_Appliances_Media,
    Section_Media,
    Template_Questions,
    Inspection_Template_Videos
    
    var name: String {
        get { return String(describing: self) }
    }
}

enum HomeEnergyEntityListPriorityEnum: Int16, CaseIterable {
    case Home_Energy_Score_About_Home = 1,
    Home_Energy_Score_Roof_Attic_Foundation,
    Home_Energy_Score_Walls,
    Home_Energy_Score_Heating_Cooling,
    Home_Energy_Score_Windows_Skylights,
    Home_Energy_Score_Photovoltaic,
    Home_Energy_Score_Home_Performance
    
    var name: String {
        get { return String(describing: self) }
    }
}

enum ReportQuestionSelectionFormatEnum: Int64{
    case DropDown = 2
    case TextField = 6
    case RadioButton = 8
    case CheckBox = 9
    case NumberField = 10
}

enum UserAthenticationStatusEnum: String{
    case UserAuthorized = "200",
    CompanySubscriptionExpired = "1",
    UserSubscriptionExpired = "0",
    UserNotExistAnyMore = "3"
}

enum HomeEnergyAssessmentsEnum: String, CaseIterable {
    case AboutThisHomeVC = "AboutThisHomeVC",
    RoofAtticFoundationVC = "RoofAtticFoundationVC",
    WallVC = "WallVC",
    WindowsAndSkylightsVC = "WindowsAndSkylightsVC",
    HeatingAndCoolingVC = "HeatingAndCoolingVC",
    PhotovoltaicSystemVC = "PhotovoltaicSystemVC",
    HomePerformanceVC = "HomePerformanceVC"
}

enum HomeEnergyFormEnum: Int {
    case AboutThisHomeVC = 0,
    RoofAtticFoundationVC,
    WallVC,
    WindowsAndSkylightsVC,
    HeatingAndCoolingVC,
    PhotovoltaicSystemVC,
    HomePerformanceVC
}

enum HomeEnergyScoreDropDown {
    case AssessmentTypeOptions,
    DirectionFacedByFrontOfHomeOptions,
    DirectionPanelsFaceOptions,
    PanesOptions,
    FrameMaterialOptions,
    GlazingTypeOptions,
    HeatingSystemOptions,
    CoolingSystemOptions,
    HotWaterSystemOptions,
    DuctOptions,
    TownhouseUnitOptions,
    WallConstructionOptions,
    WallExteriorFinishOptions,
    WallInsulationLevelOptions,
    RoofConstructionOptions,
    RoofExteriorFinishOptions,
    RoofInsulationLevelOptions,
    RoofColorOptions,
    RoofAtticOrCeilingTypeOptions,
    RoofAtticFloorInsulationLevelOptions,
    RoofFoundationTypeOptions,
    RoofFoundationFloorInsulationLevelOptions,
    RoofFoundationWallInsulationLevelOptions,
    InteriorFloorToCeilingHeightOptions
}

enum CopiedMediaType: Int16{
    case MediaFromItemComment = 1,
    MediaFromSection = 2
}

struct GlobalDataValues {
    //Refresh Inspection Dashboard
    static var isRefreshDashboard = false
    
    static var pageRecordCount = 10
    
    static var isHomeEnergyEnabled = false
    
    //Menu Drawer Sections
    static var arrSection = ["lblMenu"]
    
    //Menu Drawer Rows
    static var arrMenu = [[kTitle:"lblDashboard",kImageName:"Dashboard", kIsIncludedId: [3,4,5,6]],[kTitle:"CreateAppointmentVC",kImageName:"CreateAppoinment", kIsIncludedId: [3,4]],[kTitle:"lblMyProfile",kImageName:"MyProfile", kIsIncludedId: [3,4,5,6]],[kTitle:"lblInspectionHistory",kImageName:"InspectionHistory", kIsIncludedId: [3,4,5,6]],[kTitle:"lblManageExpenses",kImageName:"ManageExpenses", kIsIncludedId: [3,4]],
                          [kTitle:"lblChat",kImageName:"Message", kIsIncludedId: [3,4,5,6]],
                          [kTitle:"lblChangePassword",kImageName:"ChangePassword", kIsIncludedId: [5,6]],
                          [kTitle:"lblSettings",kImageName:"Settings", kIsIncludedId: [3,4]],
                          [kTitle:"lblSyncData",kImageName:"Refresh", kIsIncludedId: [3,4]],
                          [kTitle:"lblSubscription",kImageName:"Subscription", kIsIncludedId: [3,4]],
                          [kTitle:"lblSupportTickets",kImageName:"SupportTicket", kIsIncludedId: [3,4,5,6]],
                          [kTitle:"lblLogout",kImageName:"Logout", kIsIncludedId: [3,4,5,6]]]
    
    // Default Image Configuration
    static var defaultShapeColor = UIColor.red.toHexString
    static var defaultFontType = "Roboto-Regular"
    
    //Default Damaged Image Url
    static var DamagedImageUrl = "https://s3-us-west-2.amazonaws.com/home-inspection/General/placeholder_damage_image.png"
    
    // Copied Media flow
    static var isCopiedOrDeleteMedia = true
    static var objCopiedMedia : Copied_Media?
    
    static func getCopiedMedia(inspection_template_id: Int64) -> Copied_Media?{
        
        if (GlobalDataValues.objCopiedMedia != nil) && (inspection_template_id != GlobalDataValues.objCopiedMedia?.inspection_template_id) {
            
            if let objCopiedMedia = Copied_Media.getCopiedMediaObjectFor(inspection_template_id: inspection_template_id, in: CoreDataService.sharedInstance.getContext()){
                GlobalDataValues.isCopiedOrDeleteMedia = true
                GlobalDataValues.objCopiedMedia = objCopiedMedia
                return GlobalDataValues.objCopiedMedia
            }else{
                GlobalDataValues.isCopiedOrDeleteMedia = false
                GlobalDataValues.objCopiedMedia = nil
                return GlobalDataValues.objCopiedMedia
            }
        }else if (GlobalDataValues.objCopiedMedia != nil) && (inspection_template_id == GlobalDataValues.objCopiedMedia?.inspection_template_id) {
            return GlobalDataValues.objCopiedMedia
        }else if (GlobalDataValues.objCopiedMedia == nil){
            if (GlobalDataValues.isCopiedOrDeleteMedia == false) {
                return GlobalDataValues.objCopiedMedia
            }else{
                if let objCopiedMedia = Copied_Media.getCopiedMediaObjectFor(inspection_template_id: inspection_template_id, in: CoreDataService.sharedInstance.getContext()){
                    GlobalDataValues.isCopiedOrDeleteMedia = true
                    GlobalDataValues.objCopiedMedia = objCopiedMedia
                    return GlobalDataValues.objCopiedMedia
                }else{
                    GlobalDataValues.isCopiedOrDeleteMedia = false
                    GlobalDataValues.objCopiedMedia = nil
                    return GlobalDataValues.objCopiedMedia
                }
            }
        }else{
            return nil
        }
        
        
//        if (inspection_template_id != GlobalDataValues.objCopiedMedia?.inspection_template_id) {
//
//            if (GlobalDataValues.isCopiedOrDeleteMedia == false) && (GlobalDataValues.objCopiedMedia == nil) {
//                return GlobalDataValues.objCopiedMedia
//            }else{
//                if let objCopiedMedia = Copied_Media.getCopiedMediaObjectFor(inspection_template_id: inspection_template_id, in: CoreDataService.sharedInstance.getContext()){
//                    GlobalDataValues.isCopiedOrDeleteMedia = true
//                    GlobalDataValues.objCopiedMedia = objCopiedMedia
//                    return GlobalDataValues.objCopiedMedia
//                }else{
//                    GlobalDataValues.isCopiedOrDeleteMedia = false
//                    GlobalDataValues.objCopiedMedia = nil
//                    return GlobalDataValues.objCopiedMedia
//                }
//            }
//        }else{
//            return GlobalDataValues.objCopiedMedia
//        }
    }
}

let kValue = "value"
let kIsIncludedId = "is_include_id"
let kIsBoiler = "is_boiler"
let kIsEfficiencyValue = "is_efficiency_value"
let kIsSameValue = "is_same_value"
let kIsJustTypeValue = "is_just_type_value"
let kIsNoneValue = "is_none_value"
let kMinValue = "min_value"
let kMaxValue = "max_value"
let kUnitType = "unit"
let kName = "name"
let kIsCloseOrResolve = "is_close_or_resolve"
let kImageName = "imageName"
let kSupportTicketStatusId = "Support Ticket Status Id"

struct SubscriptionPlan{
    static var SubscriptionPlanType = [[kValue: 1 , kName: "Main Plan"],
                                       [kValue: 2 , kName: "Additional Inspector Plan"],
                                       [kValue: 3 , kName: "Add On Package"]]
    enum CouponRateType:Int{
        case FixedAmount = 1,
        Percentage = 2
    }
    
}
struct  SupportTicket{
    static var supportTicketCount = 0
    static var getsupportTicketCount : (()->())?
    static var SupportTicketType = [[kName: "No Filter", kValue:0, kIsIncludedId: [1,2,3,4,5,6,7,8,9,10,11,12,13,14], kSupportTicketStatusId : [], kIsCloseOrResolve: [], kMsg: ""],
                                    [kName: "Customer action pending", kValue:2, kIsIncludedId: [2,3,4,5,6,7,8,9,10], kSupportTicketStatusId : [], kIsCloseOrResolve: ["Submit To Client/Agent"], kMsg: ""],
                                    [kName: "Company action pending", kValue:7, kIsIncludedId: [1,2,3,4,5,6,7,8,9,10,11,13], kSupportTicketStatusId : [], kIsCloseOrResolve: ["Submit To Company"], kMsg: ""],
                                    [kName: "Resolved by company", kValue:3, kIsIncludedId: [5,6], kSupportTicketStatusId : [], kIsCloseOrResolve: ["Resolved Ticket By Company"], kMsg: "Are you sure want to reslove support ticket?"],
                                    [kName: "Support team action pending", kValue:1, kIsIncludedId: [1,2,3,4,7,8,9,10,11,12,13,14], kSupportTicketStatusId: [5,6], kIsCloseOrResolve: ["Submit To Support Team"], kMsg: ""],
                                    [kName: "Resolved by support team", kValue:8, kIsIncludedId: [2,3,4,7,8,9,10,14], kSupportTicketStatusId : [5,6], kIsCloseOrResolve: false, kMsg: ""],
                                    [kName: "Development team action pending", kValue:5, kIsIncludedId: [1,11,12,13], kSupportTicketStatusId : [2,3,4,5,6,7,8,10,14], kIsCloseOrResolve: [], kMsg: ""],
                                    [kName: "Resolved by development team", kValue:6, kIsIncludedId: [1,11,13], kSupportTicketStatusId : [2,3,4,5,6,7,8,10,14], kIsCloseOrResolve: [], kMsg: ""],
                                    [kName: "Closed", kValue:4, kIsIncludedId: [], kIsCloseOrResolve: ["Close Ticket"], kMsg: "Are you sure want to close support ticket?"]]
    
    static var SupportTicketMenu = [[kName: "Submit To Company", kIsIncludedId:[5,6,11,13], kCreatedBy: [], kIsCloseOrResolve: false],
                                    [kName: "Submit To Client/Agent", kIsIncludedId:[2,3,4,7,8,9,10,14], kCreatedBy: [5,6], kIsCloseOrResolve: false],
                                    [kName: "Submit To Support Team", kIsIncludedId:[1,2,3,4,7,8,9,10,12,14], kCreatedBy: [], kIsCloseOrResolve: false],
                                    [kName: "Submit To Developer", kIsIncludedId:[1,11,13], kCreatedBy: [], kIsCloseOrResolve: false],
                                    [kName: "Resolved Ticket By Company", kIsIncludedId:[2,3,4,7,8,9,10,14], kCreatedBy: [5,6], kIsCloseOrResolve: true],
                                    [kName: "Resolved Ticket By Support", kIsIncludedId:[1,11,13], kCreatedBy: [], kIsCloseOrResolve: false],
                                    [kName: "Resolved Ticket By Developer", kIsIncludedId:[12], kCreatedBy: [], kIsCloseOrResolve: false],
                                    [kName: "Close Ticket", kIsIncludedId:[], kCreatedBy: [], kIsCloseOrResolve: true]]
    
    enum conversationType:Int{
        case Message = 1,
        Resolve = 3,
        Close = 4
    }
    enum PriorityType:Int, CustomStringConvertible{
        case High = 1,
        Medium = 2,
        Low = 3
        var description: String{
            switch self {
            case .High:
                return "High"
            case .Medium:
                return "Medium"
            case .Low:
                return "Low"
            }
        }
    }
    
    enum MediaType : Int{
        case ImageJPEGPNG = 1
        case VideoMOVMP4 = 2
        case Pdf = 3
    }
}

struct HomeEnergyValues {
    
    static var HomeEnergyWords = [[],["roof","attic","foundation","roofs","attics","foundations"],["wall","walls"],["window","windows","skylight","skylights"],["heating","cooling","heater", "cooler", "water","heaters", "coolers", "waters"],[],[]]
    static var homeEnergyCharaterSet = CharacterSet(charactersIn: " -_&/\\+,;")
    
    static var AssessmentTypeOptions = [
        [ kId : "construction-period testing/daily test out", kValue: "Test" ],
        [ kId : "audit", kValue: "Initial" ],
        [ kId : "preconstruction", kValue: "Preconstruction" ],
        [ kId : "quality assurance/monitoring", kValue: "QA" ],
        [ kId : "job completion testing/final inspection", kValue: "Final" ],
        [ kId : "corrected", kValue: "Corrected" ],
        [ kId : "approved workscope", kValue: "Alternative" ]
    ]
    
    static var DirectionFacedByFrontOfHomeOptions = [
        [ kId : "north", kValue: "North" ],
        [ kId : "northeast", kValue: "Northeast" ],
        [ kId : "east", kValue: "East" ],
        [ kId : "southeast", kValue: "Southeast" ],
        [ kId : "south", kValue: "South" ],
        [ kId : "southwest", kValue: "Southwest" ],
        [ kId : "west", kValue: "West" ],
        [ kId : "northwest", kValue: "Northwest" ]
    ]
    
    static var DirectionPanelsFaceOptions = [
        [ kId : "north", kValue: "North" ],
        [ kId : "north_east", kValue: "Northeast" ],
        [ kId : "east", kValue: "East" ],
        [ kId : "south_east", kValue: "Southeast" ],
        [ kId : "south", kValue: "South" ],
        [ kId : "south_west", kValue: "Southwest" ],
        [ kId : "west", kValue: "West" ],
        [ kId : "north_west", kValue: "Northwest" ]
    ]
    
    static var PanesOptions = [
        [ kId : "s", kValue: "Single-Pane" ],
        [ kId : "d", kValue: "Double-Pane" ],
        [ kId : "t", kValue: "Triple-Pane" ]
    ]
    
    static var FrameMaterialOptions = [
        [ kId : "a", kValue: "Aluminum", kIsIncludedId: ["s","d"] ],
        [ kId : "w", kValue: "Wood or Vinyl", kIsIncludedId: ["s","d","t"] ],
        [ kId : "b", kValue: "Aluminum with Thermal Break", kIsIncludedId: ["d"] ]
    ]
    
    static var GlazingTypeOptions = [
        [ kId : "ca", kValue: "Clear", kIsIncludedId: ["s","a","w","d","b","t"] ],
        [ kId : "ta", kValue: "Tinted", kIsIncludedId: ["s","a","w","d","b","t"] ],
        [ kId : "sea", kValue: "Solar-Control low-E", kIsIncludedId: ["d","a","w","b","t"] ],
        [ kId : "peaa", kValue: "Insulating low-E, argon gas fill", kIsIncludedId: ["d","b","w","t","windows"] ],
        [ kId : "seaa", kValue: "Solar-Control low-E, argon gas fill", kIsIncludedId: ["d","w","t"] ]
    ]
    
    static var HeatingSystemOptions = [
        [ kId : "none", kValue: "None", kIsBoiler: false, kIsEfficiencyValue: false, kIsSameValue: false, kIsJustTypeValue: false, kMinValue: 6.0, kMaxValue: 20.0, kUnitType: "", kIsNoneValue: true ],
        [ kId : "electric__heat_pump", kValue: "Electric heat pump", kIsBoiler: false, kIsEfficiencyValue: false, kIsSameValue: true, kIsJustTypeValue: false, kMinValue: 6.0, kMaxValue: 20.0, kUnitType: "HSPF", kIsNoneValue: false ],
        [ kId : "electric__mini_split", kValue: "Minisplit (ductless) heat pump", kIsBoiler: false, kIsEfficiencyValue: true, kIsSameValue: true, kIsJustTypeValue: false, kMinValue: 6.0, kMaxValue: 20.0, kUnitType: "HSPF", kIsNoneValue: false  ],
        [ kId : "electric__gchp", kValue: "Ground coupled heat pump", kIsBoiler: false, kIsEfficiencyValue: true, kIsSameValue: true, kIsJustTypeValue: false, kMinValue: 2.0, kMaxValue: 5.0, kUnitType: "COP", kIsNoneValue: false ],
        [ kId : "lpg__boiler", kValue: "Propane (LPG) boiler", kIsBoiler: true, kIsEfficiencyValue: false, kIsSameValue: false, kIsJustTypeValue: false, kMinValue: 0.6, kMaxValue: 1.0, kUnitType: "AFUE", kIsNoneValue: false ],
        [ kId : "natural_gas__boiler", kValue: "Gas boiler", kIsBoiler: true, kIsEfficiencyValue: false, kIsSameValue: false, kIsJustTypeValue: false, kMinValue: 0.6, kMaxValue: 1.0, kUnitType: "AFUE", kIsNoneValue: false ],
        [ kId : "fuel_oil__boiler", kValue: "Oil boiler", kIsBoiler: true, kIsEfficiencyValue: false, kIsSameValue: false, kIsJustTypeValue: false, kMinValue: 0.6, kMaxValue: 1.0, kUnitType: "AFUE", kIsNoneValue: false ],
        [ kId : "natural_gas__wall_furnace", kValue: "Room (through-the-wall) gas furnace", kIsBoiler: false, kIsEfficiencyValue: false, kIsSameValue: false, kIsJustTypeValue: false, kMinValue: 0.6, kMaxValue: 1.0, kUnitType: "AFUE", kIsNoneValue: false ],
        [ kId : "electric__central_furnace", kValue: "Electric furnace", kIsBoiler: false, kIsEfficiencyValue: false, kIsSameValue: false, kIsJustTypeValue: false, kMinValue: 0.6, kMaxValue: 1.0, kUnitType: "AFUE", kIsNoneValue: false ],
        [ kId : "fuel_oil__central_furnace", kValue: "Oil furnace", kIsBoiler: false, kIsEfficiencyValue: false, kIsSameValue: false, kIsJustTypeValue: false, kMinValue: 0.6, kMaxValue: 1.0, kUnitType: "AFUE", kIsNoneValue: false ],
        [ kId : "lpg__central_furnace", kValue: "Propane (LPG) furnace", kIsBoiler: false, kIsEfficiencyValue: false, kIsSameValue: false, kIsJustTypeValue: false, kMinValue: 0.6, kMaxValue: 1.0, kUnitType: "AFUE", kIsNoneValue: false ],
        [ kId : "natural_gas__central_furnace", kValue: "Central gas furnace", kIsBoiler: false, kIsEfficiencyValue: false, kIsSameValue: false, kIsJustTypeValue: false, kMinValue: 0.6, kMaxValue: 1.0, kUnitType: "AFUE", kIsNoneValue: false ],
        [ kId : "electric__baseboard", kValue: "Electric baseboard heater", kIsBoiler: false, kIsEfficiencyValue: false, kIsSameValue: false, kIsJustTypeValue: true, kMinValue: 0.0, kMaxValue: 0.0, kUnitType: "", kIsNoneValue: false ],
        [ kId : "cord_wood__wood_stove", kValue: "Wood stove", kIsBoiler: false, kIsEfficiencyValue: false, kIsSameValue: false, kIsJustTypeValue: true, kMinValue: 0.0, kMaxValue: 0.0, kUnitType: "", kIsNoneValue: false ],
        [ kId : "pellet_wood__wood_stove", kValue: "Pellet stove", kIsBoiler: false, kIsEfficiencyValue: false, kIsSameValue: false, kIsJustTypeValue: true, kMinValue: 0.0, kMaxValue: 0.0, kUnitType: "", kIsNoneValue: false ]
    ]
    
    static var CoolingSystemOptions = [
        [ kId : "none", kValue: "None", kIsEfficiencyValue: false, kIsSameValue: false, kMinValue: 0.0, kMaxValue: 0.0, kUnitType: "", kIsNoneValue: true ],
        [ kId : "split_dx", kValue: "Central air conditioner", kIsEfficiencyValue: false, kIsSameValue: false, kMinValue: 8.0, kMaxValue: 40.0, kUnitType: "SEER", kIsNoneValue: false ],
        [ kId : "packaged_dx", kValue: "Room air conditioner", kIsEfficiencyValue: false, kIsSameValue: false, kMinValue: 8.0, kMaxValue: 40.0, kUnitType: "EER", kIsNoneValue: false ],
        [ kId : "heat_pump", kValue: "Electric heat pump", kIsEfficiencyValue: false, kIsSameValue: true, kMinValue: 8.0, kMaxValue: 40.0, kUnitType: "SEER", kIsNoneValue: false ],
        [ kId : "mini_split", kValue: "Minisplit (ductless) heat pump", kIsEfficiencyValue: true, kIsSameValue: true, kMinValue: 8.0, kMaxValue: 40.0, kUnitType: "SEER", kIsNoneValue: false ],
        [ kId : "gchp", kValue: "Ground coupled heat pump", kIsEfficiencyValue: true, kIsSameValue: true, kMinValue: 8.0, kMaxValue: 40.0, kUnitType: "EER", kIsNoneValue: false ]
    ]
    
    static var HotWaterSystemOptions = [
        [ kId : "storage__electric", kValue: "Electric Storage", kIsBoiler: false, kIsEfficiencyValue: false, kMinValue: 0.45, kMaxValue: 1.0 ],
        [ kId : "storage__natural_gas", kValue: "Natural Gas Storage", kIsBoiler: false, kIsEfficiencyValue: false, kMinValue: 0.45, kMaxValue: 1.0 ],
        [ kId : "storage__lpg", kValue: "LPG Storage", kIsBoiler: false, kIsEfficiencyValue: false, kMinValue: 0.45, kMaxValue: 1.0 ],
        [ kId : "storage__fuel_oil", kValue: "Oil Storage", kIsBoiler: false, kIsEfficiencyValue: false, kMinValue: 0.45, kMaxValue: 1.0 ],
        [ kId : "heat_pump__electric", kValue: "Electric Heat Pump", kIsBoiler: false, kIsEfficiencyValue: true, kMinValue: 1.0, kMaxValue: 4.0 ],
        [ kId : "space-heating boiler with storage tank", kValue: "Space-heating boiler with storage tank", kIsBoiler: true, kIsEfficiencyValue: false, kMinValue: 0.0, kMaxValue: 0.0 ],
        [ kId : "space-heating boiler with tankless coil", kValue: "Space-heating boiler with tankless coil", kIsBoiler: true, kIsEfficiencyValue: false, kMinValue: 0.0, kMaxValue: 0.0 ]
    ]
    
    static var DuctOptions = [
        [ kId : "conditioned space", kValue: "Conditioned space" ],
        [ kId : "vented crawlspace", kValue: "Vented Crawlspace" ],
        [ kId : "unconditioned attic", kValue: "Unconditioned Attic" ]
    ]
    
    static var TownhouseUnitOptions = [
        [ kId : "back_front", kValue: "Middle" ],
        [ kId : "back_front_left", kValue: "Left" ],
        [ kId : "back_right_front", kValue: "Right" ]
    ]
    
    static var WallConstructionOptions = [
        [ kId : "WoodStud", kValue: "Wood Frame" ],
        [ kId : "WoodStudFoamSheathing", kValue: "Wood Frame with rigid foam sheathing" ],
        [ kId : "WoodStudEngineering", kValue: "Wood Frame with Optimum Value Engineering (OVE)" ],
        [ kId : "StructuralBrick", kValue: "Structural Brick" ],
        [ kId : "Stone", kValue: "Concrete Block or Stone" ],
        [ kId : "StrawBale", kValue: "Straw Bale" ]
    ]
    
    static var WallExteriorFinishOptions = [
        [ kId : "none", kValue: "None",  kIsIncludedId: ["StructuralBrick", "Stone"] ],
        [ kId : "asbestos siding", kValue: "Wood Siding, Fiber Cement, Composite Shingle, or Masonite Siding", kIsIncludedId: ["WoodStud", "WoodStudFoamSheathing", "WoodStudEngineering"] ],
        [ kId : "stucco", kValue: "Stucco", kIsIncludedId: ["WoodStud", "WoodStudFoamSheathing", "WoodStudEngineering", "Stone", "StrawBale"] ],
        [ kId : "vinyl siding", kValue: "Vinyl Siding", kIsIncludedId: ["WoodStud", "WoodStudFoamSheathing", "WoodStudEngineering"] ],
        [ kId : "aluminum siding", kValue: "Aluminum Siding", kIsIncludedId: ["WoodStud", "WoodStudFoamSheathing", "WoodStudEngineering"] ],
        [ kId : "brick veneer", kValue: "Brick Veneer", kIsIncludedId: ["WoodStud", "WoodStudFoamSheathing", "WoodStudEngineering", "Stone"] ]
    ]
    
    static var WallInsulationLevelOptions = [
        [ kId : "0", kValue: "R-0", kIsIncludedId: ["WoodStud", "StructuralBrick", "Stone", "StrawBale"] ],
        [ kId : "3", kValue: "R-3", kIsIncludedId: ["WoodStud", "WoodStudFoamSheathing", "Stone"] ],
        [ kId : "5", kValue: "R-5", kIsIncludedId: ["StructuralBrick"] ],
        [ kId : "6", kValue: "R-6", kIsIncludedId: ["Stone"] ],
        [ kId : "7", kValue: "R-7", kIsIncludedId: ["WoodStud", "WoodStudFoamSheathing"] ],
        [ kId : "10", kValue: "R-10", kIsIncludedId: ["StructuralBrick"] ],
        [ kId : "11", kValue: "R-11", kIsIncludedId: ["WoodStud", "WoodStudFoamSheathing"] ],
        [ kId : "13", kValue: "R-13", kIsIncludedId: ["WoodStud", "WoodStudFoamSheathing"] ],
        [ kId : "15", kValue: "R-15", kIsIncludedId: ["WoodStud", "WoodStudFoamSheathing"] ],
        [ kId : "19", kValue: "R-19", kIsIncludedId: ["WoodStud", "WoodStudFoamSheathing", "WoodStudEngineering"] ],
        [ kId : "21", kValue: "R-21", kIsIncludedId: ["WoodStud", "WoodStudFoamSheathing", "WoodStudEngineering"] ],
        [ kId : "27", kValue: "R-27", kIsIncludedId: ["WoodStudEngineering"] ],
        [ kId : "33", kValue: "R-33", kIsIncludedId: ["WoodStudEngineering"] ],
        [ kId : "38", kValue: "R-38", kIsIncludedId: ["WoodStudEngineering"] ]
    ]
    
    static var RoofConstructionOptions = [
        [ kId : "false", kValue: "Standard roof" ],
        [ kId : "true", kValue: "Roof with radiant Barrier" ]
    ]
    
    static var RoofExteriorFinishOptions = [
        [ kId : "co", kValue: "Composition Shingles or Metal" ],
        [ kId : "wo", kValue: "Wood Shakes" ],
        [ kId : "lc", kValue: "Concrete Tile" ],
        [ kId : "v", kValue: "Tar or Gravel" ]
    ]
    
    static var RoofInsulationLevelOptions = [
        [ kId : "0", kValue: "R-0", kIsIncludedId: ["false","true"] ],
        [ kId : "11", kValue: "R-11", kIsIncludedId: ["false"] ],
        [ kId : "13", kValue: "R-13", kIsIncludedId: ["false"] ],
        [ kId : "15", kValue: "R-15", kIsIncludedId: ["false"] ],
        [ kId : "19", kValue: "R-19", kIsIncludedId: ["false"] ],
        [ kId : "21", kValue: "R-21", kIsIncludedId: ["false"] ],
        [ kId : "27", kValue: "R-27", kIsIncludedId: ["false"] ],
        [ kId : "30", kValue: "R-30", kIsIncludedId: ["false"] ]
    ]
    
    static var RoofColorOptions = [
        [ kId : "reflective", kValue: "White" ],
        [ kId : "light", kValue: "Light" ],
        [ kId : "medium", kValue: "Medium" ],
        [ kId : "medium dark", kValue: "Medium Dark" ],
        [ kId : "dark", kValue: "Dark" ]
    ]
    
    static var RoofAtticOrCeilingTypeOptions = [
        [ kId : "vented attic", kValue: "Unconditioned Attic" ],
        [ kId : "cathedral ceiling", kValue: "Cathedral Ceiling" ]
    ]
    
    static var RoofAtticFloorInsulationLevelOptions = [
        [ kId : "0", kValue: "R-0"],
        [ kId : "3", kValue: "R-3"],
        [ kId : "6", kValue: "R-6"],
        [ kId : "9", kValue: "R-9"],
        [ kId : "11", kValue: "R-11" ],
        [ kId : "19", kValue: "R-19" ],
        [ kId : "21", kValue: "R-21" ],
        [ kId : "25", kValue: "R-25" ],
        [ kId : "30", kValue: "R-30" ],
        [ kId : "38", kValue: "R-38" ],
        [ kId : "44", kValue: "R-44" ],
        [ kId : "49", kValue: "R-49" ],
        [ kId : "60", kValue: "R-60" ]
    ]
    
    static var RoofFoundationTypeOptions = [
        [ kId : "slab_on_grade", kValue: "Slab-on-grade foundation" ],
        [ kId : "uncond_basement", kValue: "Unconditioned Basement" ],
        [ kId : "cond_basement", kValue: "Conditioned Basement" ],
        [ kId : "unvented_crawl", kValue: "Unvented Crawlspace" ],
        [ kId : "vented_crawl", kValue: "Vented Crawlspace" ]
    ]
    
    static var RoofFoundationFloorInsulationLevelOptions = [
        [ kId : "0", kValue: "R-0"],
        [ kId : "11", kValue: "R-11" ],
        [ kId : "13", kValue: "R-13"],
        [ kId : "15", kValue: "R-15"],
        [ kId : "19", kValue: "R-19" ],
        [ kId : "21", kValue: "R-21" ],
        [ kId : "25", kValue: "R-25" ],
        [ kId : "30", kValue: "R-30" ],
        [ kId : "38", kValue: "R-38" ]
    ]

    static var RoofFoundationWallInsulationLevelOptions = [
        [ kId : "0", kValue: "R-0", kIsIncludedId: ["slab_on_grade","uncond_basement","cond_basement","unvented_crawl","vented_crawl"] ],
        [ kId : "5", kValue: "R-5", kIsIncludedId: ["slab_on_grade"] ],
        [ kId : "11", kValue: "R-11", kIsIncludedId: ["uncond_basement","cond_basement","unvented_crawl","vented_crawl"] ],
        [ kId : "19", kValue: "R-19", kIsIncludedId: ["uncond_basement","cond_basement","unvented_crawl","vented_crawl"] ]
    ]
    
    static var InteriorFloorToCeilingHeightOptions = [ [kId : "6", kValue: "6 Feet"],[kId : "7", kValue: "7 Feet"],[kId : "8", kValue: "8 Feet"], [kId : "9", kValue: "9 Feet"],[kId : "10", kValue: "10 Feet"],[kId : "11", kValue: "11 Feet"],[kId : "12", kValue: "12 Feet"] ]
    
    static func getDropDownValues(HomeEnergyScoreDropDownType:HomeEnergyScoreDropDown, isGetIdFromValue:Bool, text: String) -> String {
        var retrunDataString = ""
        switch HomeEnergyScoreDropDownType {
        
        case .AssessmentTypeOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.AssessmentTypeOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.AssessmentTypeOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        case .DirectionFacedByFrontOfHomeOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.DirectionFacedByFrontOfHomeOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.DirectionFacedByFrontOfHomeOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        case .PanesOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.PanesOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.PanesOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        case .FrameMaterialOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.FrameMaterialOptions.first{$0[kValue] as? String == text}?[kId] as? String ?? ""
            }else{
                retrunDataString = HomeEnergyValues.FrameMaterialOptions.first{$0[kId] as? String == text}?[kValue] as? String ?? ""
            }
            break
        case .GlazingTypeOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.GlazingTypeOptions.first{$0[kValue] as? String == text}?[kId] as? String ?? ""
            }else{
                retrunDataString = HomeEnergyValues.GlazingTypeOptions.first{$0[kId] as? String == text}?[kValue] as? String ?? ""
            }
            break
        case .HeatingSystemOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.HeatingSystemOptions.first{$0[kValue] as? String == text}?[kId] as? String ?? ""
            }else{
                retrunDataString = HomeEnergyValues.HeatingSystemOptions.first{$0[kId] as? String == text}?[kValue] as? String ?? ""
            }
            break
        case .CoolingSystemOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.CoolingSystemOptions.first{$0[kValue] as? String == text}?[kId] as? String ?? ""
            }else{
                retrunDataString = HomeEnergyValues.CoolingSystemOptions.first{$0[kId] as? String == text}?[kValue] as? String ?? ""
            }
            break
        case .HotWaterSystemOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.HotWaterSystemOptions.first{$0[kValue] as? String == text}?[kId] as? String ?? ""
            }else{
                retrunDataString = HomeEnergyValues.HotWaterSystemOptions.first{$0[kId] as? String == text}?[kValue] as? String ?? ""
            }
            break
        case .DuctOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.DuctOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.DuctOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        case .TownhouseUnitOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.TownhouseUnitOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.TownhouseUnitOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        case .WallConstructionOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.WallConstructionOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.WallConstructionOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        case .WallExteriorFinishOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.WallExteriorFinishOptions.first{$0[kValue] as? String == text}?[kId] as? String ?? ""
            }else{
                retrunDataString = HomeEnergyValues.WallExteriorFinishOptions.first{$0[kId] as? String == text}?[kValue] as? String ?? ""
            }
            break
        case .WallInsulationLevelOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.WallInsulationLevelOptions.first{$0[kValue] as? String == text}?[kId] as? String ?? ""
            }else{
                retrunDataString = HomeEnergyValues.WallInsulationLevelOptions.first{$0[kId] as? String == text}?[kValue] as? String ?? ""
            }
            break
        case .RoofConstructionOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.RoofConstructionOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.RoofConstructionOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        case .RoofExteriorFinishOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.RoofExteriorFinishOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.RoofExteriorFinishOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        case .RoofInsulationLevelOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.RoofInsulationLevelOptions.first{$0[kValue] as? String == text}?[kId] as? String ?? ""
            }else{
                retrunDataString = HomeEnergyValues.RoofInsulationLevelOptions.first{$0[kId] as? String == text}?[kValue] as? String ?? ""
            }
            break
        case .RoofColorOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.RoofColorOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.RoofColorOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        case .RoofAtticOrCeilingTypeOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.RoofAtticOrCeilingTypeOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.RoofAtticOrCeilingTypeOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        case .RoofAtticFloorInsulationLevelOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.RoofAtticFloorInsulationLevelOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.RoofAtticFloorInsulationLevelOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        case .RoofFoundationTypeOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.RoofFoundationTypeOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.RoofFoundationTypeOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        case .RoofFoundationFloorInsulationLevelOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.RoofFoundationFloorInsulationLevelOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.RoofFoundationFloorInsulationLevelOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        case .RoofFoundationWallInsulationLevelOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.RoofFoundationWallInsulationLevelOptions.first{$0[kValue] as? String == text}?[kId] as? String ?? ""
            }else{
                retrunDataString = HomeEnergyValues.RoofFoundationWallInsulationLevelOptions.first{$0[kId] as? String == text}?[kValue] as? String ?? ""
            }
            break
        case .DirectionPanelsFaceOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.DirectionPanelsFaceOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.DirectionPanelsFaceOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        case .InteriorFloorToCeilingHeightOptions:
            if isGetIdFromValue {
                retrunDataString = HomeEnergyValues.InteriorFloorToCeilingHeightOptions.first{$0[kValue] == text}?[kId] ?? ""
            }else{
                retrunDataString = HomeEnergyValues.InteriorFloorToCeilingHeightOptions.first{$0[kId] == text}?[kValue] ?? ""
            }
            break
        }
        return retrunDataString
    }
}
