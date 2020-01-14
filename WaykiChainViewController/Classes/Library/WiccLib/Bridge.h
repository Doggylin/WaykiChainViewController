//
//  Bridge.h
//  CommApp
//
//  Created by sorath on 2019/3/6.
//  Copyright © 2019 sorath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BridgeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface Bridge : NSObject
//创建钱包、助记词
+ (NSString *)createNewWalletMnemonics;

//获取钱包地址和私钥
+ (NSArray *)getAddressAndPrivateKeyWithHelpString:(NSString *)helpStr;

//获取钱包哈希
+ (NSString *)getWalletHashFrom:(NSString *)codestring;

//检验钱包地址格式
+ (BOOL)addressIsAble:(NSString *)address;

//检查助记词列表

+(BOOL) checkMnemonicCode:(NSString*)words;

//打乱助记词数组词语顺序
//+ (NSArray *)getRamdomArrayWithArray:(NSArray *)array;

//获取激活hex
+ (NSString *)getActrivateHexWithHelpStr:(NSString *)helpStr privateKey:(NSString*)privateKey Fees:(double)fees validHeight:(double)validHeight ;

//获取转账wicc hex
+ (NSString *)getTransfetWICCHexWithHelpStr:(NSString *)helpStr privateKey:(NSString*)privateKey Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId destAddr:(NSString *)destAddr transferValue:(NSString *)value ;

//获取合约签名
+ (NSString *)getContractHexByContractStrWithHelpStr:(NSString *)helpStr privateKey:(NSString*)privateKey blockHeight:(double)validHeight regessID:(NSString *)regessID appid:(NSString *)appid contractStr:(NSString *)contractStr handleValue:(double)value fee:(double)fee;

///发布合约
+ (NSString *)contractPub:(NSString *)helpStr privateKey:(NSString*)privateKey blockHeight:(double)validHeight regessId:(NSString *)regessID contractStr:(NSString *)contractStr desc:(NSString *)desc fee:(double)fee;

///投票
+ (NSString *)nodeVote:(NSString *)helpStr blockHeight:(double)validHeight regessId:(NSString *)regessID beVotePubkey:(NSArray *)beVotePubkey beVoteAmounts:(NSArray *)beVoteAmounts fee:(double)fee;

///私钥登陆签名
+ (NSArray *)privateKeyToSingHex:(NSString *)privateKey randomStr:(NSString *)randomStr;

///检查私钥是否正确
+(BOOL) checkPrivateKey:(NSString*)private;

///通过私钥获取地址
+(NSString *)getAdressFromePrivateKey:(NSString*)privateKey;

///检查地址是否可用
+(BOOL)checkAddress:(NSString*)address;


///多币种合约签名
+ (NSString *)getUcoinContractHexWithHelpStr:(NSString *)helpStr privateKey:(NSString*)privateKey Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId appid:(NSString *)appid coinSymbol:(NSString *)coinSymbol coinAmount:(NSString*)coinAmount feeSymbol:(NSString *)feeSymbol contractHex:(NSString *)contractHex;

///多币种转账签名
+ (NSString *)getUcoinTXHexWithHelpStr:(NSString *)helpStr privateKey:(NSString*)privateKey Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId destAddr:(NSString *)destAddr coinSymbol:(NSString *)coinSymbol transferValue:(NSString*)value feeSymbol:(NSString *)feeSymbol memo:(NSString *)memo;

///发布资产签名
+ (NSString *)getAssetIssueStr:(NSString *)helpStr privateKey:(NSString*)privateKey Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId assetSymbol:(NSString *)assetSymbol assetName:(NSString *)assetName assetTotal:(double)assetTotal feeSymbol:(NSString *)feeSymbol assetOwner:(NSString *)assetOwner minTable:(BOOL)minTable;

///更新资产签名
+ (NSString *)getAssetUpdateStr:(NSString *)helpStr privateKey:(NSString*)privateKey Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId assetSymbol:(NSString *)assetSymbol feeSymbol:(NSString *)feeSymbol updateValue:(NSString *)updateValue updateType:(NSInteger)updateType;

///CDP创建和追加
+ (NSString *)getCdpCreateHexWithBridgeModel:(BridgeModel *)bridgeModel cdpId:(NSString *)cdpId scoinSymbol:(NSString*)scoinSymbol scoinMint:(NSString *)scoinMint assetAmount:(NSString*)assetAmount assetSymbol:(NSString *)assetSymbol;
///CDP赎回
+ (NSString *)getCdpRedeemHexWithBridgeModel:(BridgeModel *)bridgeModel cdpId:(NSString *)cdpId scoinsToRepay:(NSString*)scoinsToRepay assetAmount:(NSString*)assetAmount assetSymbol:(NSString *)assetSymbol;

///清算cdp
+ (NSString *)getCdpdLiquidHexWithBridgeModel:(BridgeModel *)bridgeModel cdpId:(NSString *)cdpId scoinsLiquidate:(NSString*)scoinsLiquidate assetSymbol:(NSString *)assetSymbol;

///Dex限价
+ (NSString *)getDexLimitHexWithBridgeModel:(BridgeModel *)bridgeModel assetSymbol:(NSString *)assetSymbol coinSymbol:(NSString *)coinSymbol price:(NSString *)price assetAmount:(NSString *)assetAmount dexTxType:(NSString*)dexTxType;

///Dex市价
+ (NSString *)getDexMarketHexWithBridgeModel:(BridgeModel *)bridgeModel assetSymbol:(NSString *)assetSymbol coinSymbol:(NSString *)coinSymbol assetAmount:(NSString *)assetAmount dexTxType:(NSString *)dexTxType;
///Dex取消
+ (NSString *)getDexCancelHexWithBridgeModel:(BridgeModel *)bridgeModel dexTxid:(NSString *)dexTxid;

///decimal处理字符串->乘10的8次方
+ (uint64_t)handelNumMultiply8:(NSString*) strValue;
///decimal处理字符串->除以10的8次方
+ (NSString *)handelNumDivide8:(NSString*) strValue;
///两数相乘返回字符串
+ (NSString*)handelA_Mul_B_withA:(NSString *)A B:(NSString*)B;
@end

NS_ASSUME_NONNULL_END
