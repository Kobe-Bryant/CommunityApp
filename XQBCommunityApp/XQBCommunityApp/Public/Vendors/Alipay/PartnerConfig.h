//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088511390847392"
//收款支付宝账号
#define SellerID  @"2088511390847392"//@"11014630549003"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"q5o8m2ef8k3u1yfeabfq9dy5l8t54qbo"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOhhzAmf98osNMOhsPOKiqkKweRQXPndfX4gJWjzgpmC67RQ5vVQnT1CsJ06e90eMj88q96eEQ1qvDi1oc/Py7j5PdIXxhlu8IYQfHnIwDnduIupdDRLGyEaQ8l4slmdYmd8aDDqKW8zMbfoqctp6w/KOA2kQn846KVW253dpP6PAgMBAAECgYADANiRO0cJjt6ztJBD5YN7Qc9VsxAwjoNDsQiqvZLvhvii4PTLMNqHYyhDL/FP30cI+DDEdMiFot6B4R8RP39Dg275dihwiK/7urAhGEQlFlFRkNNTaTfCnM/ymu+48MwJmoJK3xEL4wyA1Eals6NvKMrw78KfRjj2Zt5A42J5QQJBAPedTO4nWN1nJrZZtI728ZNpVJOFIMx0qtAZOWVLhr8dQn2CrmMxG4KT1JfgnKeHMWP0ZhGadfxwcWh3O1hLFaECQQDwQHBEjLXzm/xQzx1ceMdlFiBftsmVREjHuuirB1odv26T7xET1xgeg+6Qt6jHfLa8rOrC2K/RtMPZpDtWskYvAkEAoQZXcAyAesLI5w7hH5Oxt/ZofOK3WJ6KMngk3h3Gi+RASBTCyVi3FiyCtR3pYfzF/sWB1vLGxZpt9cyL+Dgj4QJBAOeqi1deg9k7casOfFZ91G/iTSdeX7WCmdeWoOLCfSAwRtV5cnM6NvS97V446xQpayA2cU2fmrJRZ4VHezyXPVsCQByM77o2VBvZxcOlNpiSJBWiP0Tg95ysyJ/sFHFtlg8aHFteSZ/LbHGwbYI4eYjXssOupyB/snVmuKQuWabfH/M="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
