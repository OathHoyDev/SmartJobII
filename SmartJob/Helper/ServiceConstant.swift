//
//  ServiceConstant.swift
//  SmartJob
//
//  Created by SilVeriSm on 11/15/2558 BE.
//  Copyright © 2558 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class ServiceConstant: NSObject {
    
    static let FONT_NAME = "supermarket"
    
    static let IPHONE_FONT_SIZE = CGFloat(15)
    static let IPAD_FONT_SIZE = CGFloat(22)
    
    static let BAR_COLOR = UIColor(red: 76/255, green: 21/255, blue: 17/255, alpha: 1.0)
    static let ENABLE_LABEL_COLOR = UIColor(red: 102/255, green: 62/255, blue: 50/255, alpha: 1.0) // Brown
    static let DISABLE_LABEL_COLOR = UIColor(red: 149/255, green: 58/255, blue: 134/255, alpha: 1.0) // Pink
    static let DASH_BORDER_COLOR = UIColor(red: 242/255, green: 214/255, blue: 174/255, alpha: 1.0) // Cream
    
    static let URL = "http://164.115.24.197:8080" // SIT

    // static let URL = "http://111.223.34.154/WS_EGA1503" // DEV 2015
    
    // static let URL = "http://111.223.34.154/WS_EGA1603" // DEV 2016
    
    
//     static let URL = "http://164.115.24.172" // Prod
    
//    static let URL = "https://smartjob.apps.go.th:8080" // New Prod
    
    
    static let SHARE_URL = "\(URL)/jobannounce"
    
    static let SERVICE_URL = "\(URL)/services.asmx"
    static let SERVICE_EGA_URL_GET_TOKEN = "https://ws.ega.or.th/ws/auth/validate"
    static let SERVICE_EGA_URL_GET_PROFILE = "https://ws.ega.or.th/ws/dopa/personal/profile/extra"
    
    static let CONSUMER_KEY = "252c1fb5-73fd-461e-a1d3-ed4f52d21cb8"
    static let CONSUMER_SECRET = "brvKnxtTILh"
    static let AGENT_ID = "1719900106042"
    
    static let SERVICE_EGA_URL_CHECK_LASERCODE = "https://ws.ega.or.th/ws/dopa/verification/personal"
        
//        ?CitizenID=<CitizenID>& FirstName=<FirstName>&LastName=<LastName>&BEBirthDate=<BEBirthDate>& LaserCode=<LaserCode>"
    
    static let LASERCODE_CONSUMER_KEY = "d152a5c3-c560-4ebd-b2ac-4ebcd054180e"
    static let LASERCODE_CONSUMER_SECRET = "ZXmcEj2Y8ws"
    static let LASERCODE_AGENT_ID = "1719900106042"
    
    //static let FONT = UIFont(name: "supermarket.ttf", size: 6)
    
    static let SERVICE_APPLY = "ws_apply"
    static let SERVICE_EMPLOYEE_APPLY = "ws_employeeApply"
    static let SERVICE_EMPLOYEE_DETAIL = "ws_employeeDetail"
    static let SERVICE_EMPLOYEE_INTERESTED = "ws_employeeInterested"
    static let SERVICE_EMPLOYEE_MATCHING = "ws_employeeMatching"
    static let SERVICE_EMPLOYEE_MATCHING_GROUP = "ws_employeeMatchingGroup"
    static let SERVICE_EMPLOYEE_BRANCH_NAME = "ws_employerBranchName"
    static let SERVICE_INSERT_EMPLOYEE_REGISTER = "ws_insertEmployeeRegister"
    static let SERVICE_UPDATE_MEMBER_DETAIL = "ws_updateMemberDetail"
    static let SERVICE_INSERT_MSG = "ws_insertMsg"
    static let SERVICE_GET_MSG = "ws_getMsg"
    static let SERVICE_JOB_APPLY = "ws_jobApply"
    static let SERVICE_JOB_APPLY_GROUP = "ws_jobApplyGroup"
    static let SERVICE_JOB_DETAIL = "ws_jobDetail"
    static let SERVICE_JOB_LIST = "ws_jobList"
    static let SERVICE_JOB_MATCHING = "ws_jobMatching"
    static let SERVICE_JOB_SEARCH = "ws_jobSearch"
    static let SERVICE_MASTER_DEPARTMENT = "ws_masterDepartment"
    static let SERVICE_MASTER_EDUCATION = "ws_masterEducation"
    static let SERVICE_MASTER_JOB_TYPE = "ws_masterJobType"
    static let SERVICE_MASTER_PROVINCE = "ws_masterProvince"
    static let SERVICE_MASTER_AMPHOE = "ws_masterAmphoe"
    static let SERVICE_MASTER_TAMBON = "ws_masterTambon"
    static let SERVICE_MASTER_TITLE_NAME = "ws_masterTitleName"
    static let SERVICE_MEMBER_DETAIL = "ws_memberDetail"
    static let SERVICE_SUGGEST_JOB_POSITION = "ws_suggestJobPosition"
    static let SERVICE_EMPLOYER_LOGIN = "ws_employerLogin"
    static let SERVICE_EMPLOYEE_LOGIN = "ws_employeeLogin"
    
    static let SERVICE_GET_PRESENT_DATE = "getPresentDate"
    static let SERVICE_PRESENT_INSURED = "presentInsured"
    
    static let SERVICE_HISTORY_REGISTERD = "historyRegisterd"
    
    static let JOB_LIST_TYPE_NORMAL = ""
    static let JOB_LIST_TYPE_SEARCH = "JobSeach"
    static let JOB_LIST_TYPE_SPECIAL_SEARCH = "JobSpecialSeach"
    static let JOB_LIST_TYPE_MATCHING = "JobMatching"
    static let JOB_LIST_TYPE_YOUR_JOB = "YourJob"
    static let JOB_LIST_TYPE_EMPLOYER_INTERESTED = "EmployerInterested"

    static let TITLE_JOB_NEW = "งานใหม่ล่าสุด"
    static let TITLE_JOB_SEARCH_RESULT = "แสดงตำแหน่งงาน"
    static let TITLE_JOB_SEARCH = "ค้นหางาน"
    static let TITLE_JOB_MATCHING = "งานที่ตรงกับคุณ"
    static let TITLE_YOUR_JOB = "งานที่คุณสมัคร"
    static let TITLE_EMPLOYEE_APPLY = "ผู้สมัครงานเข้ามา"
    static let TITLE_EMPLOYEE_MATCHING = "ผู้สมัครที่ตรงตามคุณสมบัติ"
    static let TITLE_EMPLOYER_INTERESTED = "นายจ้างสนใจคุณ"
    static let TITLE_EMPLOYER_REGISTRATION = "ลงทะเบียน"
    static let TITLE_EMPLOYER_EDIT_PROFILE = "แก้ไขข้อมูลลงทะเบียน"
    
    static let EMPLOYEE_GROUP_TYPE_APPLY = "employeeGroupApply"
    static let EMPLOYEE_GROUP_TYPE_MATCHING = "employeeGroupMatching"
    
    static let EMPLOYEE_PROFILE_PAGE_TYPE_REGISTER = "employeeRegister"
    static let EMPLOYEE_PROFILE_PAGE_TYPE_EDIT_PROFILE = "employeeEditProfile"
    
    static let GET_COMPANY_INFO_FUNC = "getCompanyInfo_func"
    
    static let GET_COMPANY_DETAIL_FUNC = "getCompanyDetail_func"
    
    static let WORK_ABROAD_INFO = "workAbroadInfo"
    
    static let UPDATE_LACER_CODE = "updateLaserCode"
    
    static let WS_CHECK_ACCOUNT = "ws_checkAccount"
    static let WS_CHANGE_PASSWORD = "ws_changePassword"
    static let WS_CHECK_CHANGE_PASSWORD = "ws_checkChangePwd"
    
    static let GET_HOSPITAL_INFO_FUNC = "getHospitalInfo_func"
    static let GET_HOSPITAL_DETAIL_FUNC = "getHospitalDetail_func"
    
    static let GET_TEST_PLACE_INFO_FUNC = "getTestPlaceInfo_func"
    static let GET_TEST_PLACE_DETAIL_FUNC = "getTestPlaceDetail_func"
    
    static let GET_STATUS_TRAVEL_FUND_FUNC = "getStatusTravelFund_func"
    
    static let GET_PROVINCE_FUNC = "getProvince_func"
    static let GET_COUNTRY_TRAVEL_FUNC = "getCountryTravel_func"
    static let GET_BRANCH_TEST_PLACE_FUNC = "getBranchTestPlace_func"

    static let EMPUI_REGISTRATION = "registerEmpuiMember"
    
    static let REGISTER_INSURED = "registerInsured"
    static let UPDATE_INSURED = "updateInsured"
    static let GET_INFO_TRACKING = "getInfoTracking"
    
    static let QR_CODE_INSURED_URL = "http://empui.doe.go.th/doe_print"
    
    static let NATIONAL_COMPANY_STATUS =   [1 : "ดำเนินการ" ,
                                            2 : "พักใช้" ,
                                            3 : "ยกเลิก" ,
                                            4 : "สิ้นสภาพ" ,
                                            5 : "เพิกถอน" ,
                                            6 : "ไม่ต่ออายุ" ,
                                            7 : "ไม่มีสถานะ"]

    
    
}
