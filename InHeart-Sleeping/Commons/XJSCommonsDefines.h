//
//  XJSCommonsDefines.h
//  InHeart-Sleeping
//
//  Created by 项小盆友 on 2018/3/21.
//  Copyright © 2018年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, XJSUserInformationType) {
    XJSUserInformationTypeName = 0,
    XJSUserInformationTypePassword
    //XJSUserInformationTypePhone
};
typedef NS_ENUM(NSInteger, XJSUserGender) {
    XJSUserGenderMale = 1,
    XJSUserGenderFemale = 2
};
typedef NS_ENUM(NSInteger, XJSMaritalStatus) {
    XJSMaritalStatusNone = 0,
    XJSMaritalStatusNot,
    XJSMaritalStatusMarried
};
typedef NS_ENUM(NSInteger, XJSEducationDegree) {
    XJSEducationDegreeNone = 0,
    XJSEducationDegreeFirst,
    XJSEducationDegreeSecond,
    XJSEducationDegreeThird,
    XJSEducationDegreeForth,
    XJSEducationDegreeFifth,
    XJSEducationDegreeSixth,
    XJSEducationDegreeSeventh,
    XJSEducationDegreeEighth,
    XJSEducationDegreeNinth,
    XJSEducationDegreeTenth
};

//notification
extern NSString * const XJSLoginStatusDidChange;
extern NSString * const XJSPatientInformationsDidModify;
extern NSString * const XJSPatientDidDelete;

extern NSString * const USERTOKEN;
extern NSString * const USERID;
extern NSString * const USERNAME;
extern NSString * const USERREALNAME;

extern NSString * const NETWORKERRORTIP;
