//
//  Bridge.m
//  CommApp
//
//  Created by sorath on 2019/3/6.
//  Copyright © 2019 sorath. All rights reserved.
//

#import "Bridge.h"
#import "WaykiChainViewCOntroller-Swift.h"
#import "Wiccwallet.framework/Headers/Wiccwallet.h"

@implementation Bridge
//NetType：   2测试网 1 主网
+ (long )getNetType{
    if ([OtherTools getWalletConfigure] == 1) {
        return 1;
    }
    return 2;
}


//根据助记词获取私钥和地址
+ (NSArray *)getAddressAndPrivateKeyWithHelpString:(NSString *)helpStr{
    NSError *error = nil;
    NSString *privateKey = WiccwalletGetPrivateKeyFromMnemonic(helpStr, [self getNetType],&error);
    NSString *address = WiccwalletGetAddressFromMnemonic(helpStr,[self getNetType],&error);

    return  @[address,privateKey];
}

+ (NSString *)createNewWalletMnemonics{
    NSString *mnemonics = WiccwalletGenerateMnemonics();
    return mnemonics;
}

+ (NSArray *)getWalletHelpCodesFrom:(NSString *)codestring
{
    NSArray *arr = [codestring componentsSeparatedByString:@" "];
    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:arr];
    [arr1 removeObject:@" "];
    [arr1 removeObject:@""];
    return arr1;
}

+ (NSString *)getWalletHashFrom:(NSString *)codestring
{
    NSArray * helpcodes = [self getWalletHelpCodesFrom:codestring];
    int size = (int)helpcodes.count;
    int i = 0;
    NSMutableString* strWords = [[NSMutableString alloc]init];
    for(id word in helpcodes) {
        [strWords appendString:word];
        if(i != size - 1) {
            [strWords appendString:@" "];
        }
        i++;
    }
    return  strWords.sha512String;
}

+ (NSString *)getWaletHelpStringWithCodes:(NSArray *)helpcodes{
    // 产生钱包字符串
    int size = (int)helpcodes.count;
    int i = 0;
    NSMutableString* strWords = [[NSMutableString alloc]init];
    for(id word in helpcodes) {
        [strWords appendString:word];
        if(i != size - 1) {
            [strWords appendString:@" "];
        }
        i++;
    }
    return  strWords;
}

+ (BOOL)addressIsAble:(NSString *)address{
    return YES;
}

//检验助记词
+(BOOL) checkMnemonicCode:(NSString*)words{
    NSError *error = nil;
    NSString *address = WiccwalletGetAddressFromMnemonic(words, [self getNetType],&error);
    if (address){
        return YES;
    }
    return NO;
}
//检验私钥
+(BOOL) checkPrivateKey:(NSString*)private{
    BOOL isTrue = true;
    NSError *error = nil;
    BOOL isRight  = WiccwalletCheckPrivateKey(private, [self getNetType], &isTrue, &error);
    NSLog(@"%d",isTrue);
    return isRight;
}



//获取激活hex
+ (NSString *)getActrivateHexWithHelpStr:(NSString *)helpStr privateKey:(NSString*)privateKey Fees:(double)fees validHeight:(double)validHeight{
    NSError *error = nil;
    NSString *private = @"";
    if ([privateKey isEqualToString:@""]){
        private = WiccwalletGetPrivateKeyFromMnemonic(helpStr, [self getNetType],&error);
    }else{
        private = privateKey;
    }
    NSInteger fee = fees*100000000+(arc4random() % 100);
    WiccwalletRegisterAccountTxParam * para = [[WiccwalletRegisterAccountTxParam alloc] init];
    para.fees = fee;
    para.validHeight = validHeight;
    NSString *hex =  WiccwalletSignRegisterAccountTx(private,para,&error);
    return hex;
}

//获取转账wicc hex
+ (NSString *)getTransfetWICCHexWithHelpStr:(NSString *)helpStr privateKey:(NSString*)privateKey Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId destAddr:(NSString *)destAddr transferValue:(NSString *)value {
    NSError *error = nil;
    NSString *private = @"";
    if ([privateKey isEqualToString:@""]){
        private = WiccwalletGetPrivateKeyFromMnemonic(helpStr, [self getNetType],&error);
    }else{
        private = privateKey;
    }
    UInt64 fee = fees*100000000+(NSInteger)(arc4random() % 100);
    uint64_t txNum = [self handelNumMultiply8:value];
    NSError *error2 = nil;
    WiccwalletCommonTxParam * para = [[WiccwalletCommonTxParam alloc] init];
    para.fees = fee;
    para.validHeight = validHeight;
    para.values = txNum;
    para.srcRegId = srcRegId;
    para.destAddr = destAddr;
    para.pubKey = WiccwalletGetPubKeyFromPrivateKey(private, &error2);
    NSString *hex =  WiccwalletSignCommonTx(private,para,&error);
    
    return hex;
}



///多币种转账签名
+ (NSString *)getUcoinTXHexWithHelpStr:(NSString *)helpStr privateKey:(NSString*)privateKey Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId destAddr:(NSString *)destAddr coinSymbol:(NSString *)coinSymbol transferValue:(NSString*)value feeSymbol:(NSString *)feeSymbol memo:(NSString *)memo{
    
    NSError *error = nil;
    NSString *private = @"";
    if ([privateKey isEqualToString:@""]){
        private = WiccwalletGetPrivateKeyFromMnemonic(helpStr, [self getNetType],&error);
    }else{
        private = privateKey;
    }
    UInt64 fee = fees*100000000+(NSInteger)(arc4random() % 100);
    uint64_t txNum = [self handelNumMultiply8:value];
    
    NSError *error2 = nil;
    WiccwalletUCoinTransferTxParam * para = [[WiccwalletUCoinTransferTxParam alloc] init];
    
    WiccwalletDestArr * desta = [[WiccwalletDestArr alloc] init];
    WiccwalletDest * dest = [[WiccwalletDest alloc] init];
    dest.coinSymbol = coinSymbol;
    dest.coinAmount = txNum;
    dest.destAddr = destAddr;
    [desta add:dest];
    
    para.fees = fee;
    para.validHeight = validHeight;
    para.srcRegId = srcRegId;
    para.dests = desta;
    para.feeSymbol = feeSymbol;
    para.memo = memo;
    para.pubKey = WiccwalletGetPubKeyFromPrivateKey(private, &error2);
    NSString *hex =  WiccwalletSignUCoinTransferTx(private,para,&error);
//    NSLog(@"多币种转账签名%lld,%@",txNum,hex);
    if (hex){
        return hex;
    }
    NSDictionary * errorMSg = error.userInfo;
    NSString *msg = errorMSg[@"NSLocalizedDescription"];
    NSLog(@"多币种转账签名出错了%@",msg);
    return [NSString stringWithFormat:@"error-%@",msg];
}


///多币种合约签名
+ (NSString *)getUcoinContractHexWithHelpStr:(NSString *)helpStr privateKey:(NSString*)privateKey Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId appid:(NSString *)appid coinSymbol:(NSString *)coinSymbol coinAmount:(NSString*)coinAmount feeSymbol:(NSString *)feeSymbol contractHex:(NSString *)contractHex{
    NSError *error = nil;
    NSString *private = @"";
    if ([privateKey isEqualToString:@""]){
        private = WiccwalletGetPrivateKeyFromMnemonic(helpStr, [self getNetType],&error);
    }else{
        private = privateKey;
    }
    UInt64 fee = fees*100000000+(NSInteger)(arc4random() % 100);
    uint64_t txNum = [self handelNumMultiply8:coinAmount];
    NSError *error2 = nil;
    WiccwalletUCoinContractTxParam * para = [[WiccwalletUCoinContractTxParam alloc] init];
    para.fees = fee;
    para.validHeight = validHeight;
    para.srcRegId = srcRegId;
    para.appId = appid;
    para.feeSymbol = feeSymbol;
    para.coinSymbol = coinSymbol;
    para.coinAmount = txNum;
    para.contractHex = contractHex;
    para.pubKey = WiccwalletGetPubKeyFromPrivateKey(private, &error);
    NSString *hex =  WiccwalletSignUCoinCallContractTx(private,para,&error2);
    if (hex){
        return hex;
    }
    NSDictionary * errorMSg = error2.userInfo;
    NSString *msg = errorMSg[@"NSLocalizedDescription"];
    NSLog(@"多币种合约签名出错了%@,%@",msg,appid);
    return [NSString stringWithFormat:@"error-%@",msg];

}
//获取合约签名
+ (NSString *)getContractHexByContractStrWithHelpStr:(NSString *)helpStr privateKey:(NSString*)privateKey blockHeight:(double)validHeight regessID:(NSString *)regessID appid:(NSString *)appid contractStr:(NSString *)contractStr handleValue:(double)value fee:(double)fee{
    NSError *error = nil;
    NSString *private = @"";
    if ([privateKey isEqualToString:@""]){
        private = WiccwalletGetPrivateKeyFromMnemonic(helpStr, [self getNetType],&error);
    }else{
        private = privateKey;
    }
    
    UInt64 exFee = fee    * 100000000 + (NSInteger)(arc4random() % 100);
    UInt64 exchangeValue = (NSInteger)(value);
    WiccwalletCallContractTxParam* para = [[WiccwalletCallContractTxParam alloc] init];
    para.fees = exFee;
    para.validHeight = validHeight;
    para.srcRegId = regessID;
    para.values = exchangeValue;
    para.appId = appid;
    para.pubKey = WiccwalletGetPubKeyFromPrivateKey(private, &error);
    para.contractHex = contractStr;
    NSString *hex =  WiccwalletSignCallContractTx(private,para,&error);
    NSDictionary * errorMSg = error.userInfo;
    NSString *msg = errorMSg[@"NSLocalizedDescription"];
    if (msg){
        return [NSString stringWithFormat:@"error-%@",msg];
    }
    return hex;
}

//发布合约
+ (NSString *)contractPub:(NSString *)helpStr privateKey:(NSString*)privateKey blockHeight:(double)validHeight regessId:(NSString *)regessID contractStr:(NSString *)contractStr desc:(NSString *)desc fee:(double)fee{
    NSError *error = nil;
    NSString *private = @"";
    if ([privateKey isEqualToString:@""]){
        private = WiccwalletGetPrivateKeyFromMnemonic(helpStr, [self getNetType],&error);
    }else{
        private = privateKey;
    }
    UInt64 exFee = fee    * 100000000 + (NSInteger)(arc4random() % 100);
    WiccwalletRegisterContractTxParam* para = [[WiccwalletRegisterContractTxParam alloc] init];
    para.fees = exFee;
    para.validHeight = validHeight;
    para.srcRegId = regessID;
    NSData * data = [contractStr dataUsingEncoding:NSUTF8StringEncoding];
    
    para.script = data;
    para.description = desc;
    
    NSString *hex =  WiccwalletSignRegisterContractTx(private,para,&error);
    NSDictionary * errorMSg = error.userInfo;
    NSString *msg = errorMSg[@"NSLocalizedDescription"];
    if (msg){
        return [NSString stringWithFormat:@"error-%@",msg];
    }
    return hex;
}


//节点投票
+ (NSString *)nodeVote:(NSString *)helpStr blockHeight:(double)validHeight regessId:(NSString *)regessID beVotePubkey:(NSArray *)beVotePubkey beVoteAmounts:(NSArray *)beVoteAmounts fee:(double)fee{
    NSError *error = nil;
    NSString *privateKey = WiccwalletGetPrivateKeyFromMnemonic(helpStr,[self getNetType],&error);
    UInt64 exFee = fee * 100000000 + (NSInteger)(arc4random() % 100);
    WiccwalletDelegateTxParam * para = [[WiccwalletDelegateTxParam alloc] init];
    para.validHeight = validHeight;
    para.srcRegId = regessID;
    para.fees = exFee;

    WiccwalletOperVoteFunds * voteFounds = [[WiccwalletOperVoteFunds alloc] init];
    for(int i = 0 ; i < beVotePubkey.count ; i++){
        WiccwalletOperVoteFund * found = [[WiccwalletOperVoteFund alloc] init];
        UInt64 amount = [beVoteAmounts[i] doubleValue];
        found.pubKey = [self convertHexStrToData:beVotePubkey[i]];
        found.voteValue = amount;
        [voteFounds add:found];
       
    }
    para.votes = voteFounds;
    NSString *hex =  WiccwalletSignDelegateTx(privateKey, para , &error);
    NSDictionary * errorMSg = error.userInfo;
    NSString *msg = errorMSg[@"NSLocalizedDescription"];
    if (msg){
        return [NSString stringWithFormat:@"error-%@",msg];
    }
    return hex;
}

+ (BOOL)checkAddress:(NSString *)address{
    BOOL b = false;
    NSError *error = nil;
    BOOL a = WiccwalletCheckWalletAddress(address, [self getNetType], &b, &error);
    return a;
}

// 16进制字符串 -> 2进制数据
+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}


+(NSArray *)privateKeyToSingHex:(NSString *)privateKey randomStr:(nonnull NSString *)randomStr{
    NSError *error = nil;
    WiccwalletSignMessageParam *msgParam = WiccwalletSignMessage(privateKey, randomStr, &error);
    NSString *pubKey = msgParam.publicKey;
    NSString *signMsg = msgParam.signMessage;
    NSArray *arr = [NSArray arrayWithObjects:pubKey,signMsg, nil];
    return arr;
}

///通过私钥获取地址
+(NSString *)getAdressFromePrivateKey:(NSString*)privateKey{
    NSString *address = WiccwalletGetAddressFromPrivateKey(privateKey, [self getNetType]);
    return address;
}



///发布资产签名
+ (NSString *)getAssetIssueStr:(NSString *)helpStr privateKey:(NSString*)privateKey Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId assetSymbol:(NSString *)assetSymbol assetName:(NSString *)assetName assetTotal:(double)assetTotal feeSymbol:(NSString *)feeSymbol assetOwner:(NSString *)assetOwner minTable:(BOOL)minTable{
    NSError *error = nil;
    NSString *private = @"";
    if ([privateKey isEqualToString:@""]){
        private = WiccwalletGetPrivateKeyFromMnemonic(helpStr, [self getNetType],&error);
    }else{
        private = privateKey;
    }
    UInt64 fee = fees*100000000+(NSInteger)(arc4random() % 100);
    UInt64 transferValue = (uint64_t)(assetTotal*100000000);
    WiccwalletAssetIssueTxParam * para = [[WiccwalletAssetIssueTxParam alloc] init];
    para.fees = fee;
    para.validHeight = validHeight;
    para.srcRegId = srcRegId;
    para.feeSymbol = feeSymbol;
    para.assetSymbol = assetSymbol;
    para.assetName = assetName;
    para.assetTotal = transferValue;
    para.assetOwner = assetOwner;
    para.minTable = minTable;
//    NSLog(@"------------>%llu",transferValue);
    NSString *hex =  WiccwalletSignAssetCreateTx(private,para,&error);
    if (hex){
        return hex;
    }
    NSDictionary * errorMSg = error.userInfo;
    NSString *msg = errorMSg[@"NSLocalizedDescription"];
    NSLog(@"发布资产签名出错了%@",msg);
    return [NSString stringWithFormat:@"error-%@",msg];
}

///更新资产签名
+ (NSString *)getAssetUpdateStr:(NSString *)helpStr privateKey:(NSString*)privateKey Fees:(double)fees validHeight:(double)validHeight srcRegId:(NSString *)srcRegId assetSymbol:(NSString *)assetSymbol feeSymbol:(NSString *)feeSymbol updateValue:(NSString *)updateValue updateType:(NSInteger)updateType{
    NSError *error = nil;
    NSString *private = @"";
    if ([privateKey isEqualToString:@""]){
        private = WiccwalletGetPrivateKeyFromMnemonic(helpStr, [self getNetType],&error);
    }else{
        private = privateKey;
    }
    UInt64 fee = fees*100000000+(NSInteger)(arc4random() % 100);
    
    WiccwalletAssetUpdateTxParam * para = [[WiccwalletAssetUpdateTxParam alloc] init];
    para.fees = fee;
    para.validHeight = validHeight;
    para.srcRegId = srcRegId;
    para.feeSymbol = feeSymbol;
    
    para.updateType = updateType;
    if (updateType == 1){
        para.assetOwner = updateValue;
    }else if (updateType == 2){
        para.assetName = updateValue;
    }else{
        uint64_t aaaa = [updateValue longLongValue];
        para.assetTotal = aaaa;
    }
    para.assetSymbol = assetSymbol;
    
    NSString *hex =  WiccwalletSignAssetUpdateTx(private,para,&error);
    if (hex){
        return hex;
    }
    NSDictionary * errorMSg = error.userInfo;
    NSString *msg = errorMSg[@"NSLocalizedDescription"];
    NSLog(@"更新资产签名出错了%@",msg);
    return [NSString stringWithFormat:@"error-%@",msg];
}

//创建、追加cdp
+ (NSString *)getCdpCreateHexWithBridgeModel:(BridgeModel *)bridgeModel cdpId:(NSString *)cdpId scoinSymbol:(NSString*)scoinSymbol scoinMint:(NSString *)scoinMint assetAmount:(NSString*)assetAmount assetSymbol:(NSString *)assetSymbol{
    
    NSError *error = nil;
    NSString *private = @"";
    if ([bridgeModel.privateKey isEqualToString:@""]){
        private = WiccwalletGetPrivateKeyFromMnemonic(bridgeModel.helpStr, [self getNetType],&error);
    }else{
        private = bridgeModel.privateKey;
    }
    UInt64 fee = bridgeModel.fees*100000000+(NSInteger)(arc4random() % 100);
    WiccwalletCdpStakeTxParam * para = [[WiccwalletCdpStakeTxParam alloc] init];
    para.validHeight = bridgeModel.validHeight;
    para.srcRegId = bridgeModel.srcRegId;
    para.pubKey = WiccwalletGetPubKeyFromPrivateKey(private, &error);
    para.feeSymbol = bridgeModel.feeSymbol;
    para.fees = fee;
    para.cdpTxid = cdpId;
    para.scoinSymbol = scoinSymbol;
    para.scoinMint = [self handelNumMultiply8:scoinMint];
    
    WiccwalletAssetModels * assets = [[WiccwalletAssetModels alloc] init];
    WiccwalletAssetModel * assetM = [[WiccwalletAssetModel alloc] init];
    assetM.assetAmount = [self handelNumMultiply8:assetAmount];
    assetM.assetSymbol = assetSymbol;
    [assets add: assetM];
    para.assets = assets;
    
    NSString *hex = WiccwalletSignCdpStakeTx(private, para, &error);
    if (hex){
        NSLog(@"创建追加cdp签名%@",hex);
        return hex;
    }
    NSDictionary * errorMSg = error.userInfo;
    NSString *msg = errorMSg[@"NSLocalizedDescription"];
    NSLog(@"创建追加cdp签名出错了%@",msg);
    return [NSString stringWithFormat:@"error-%@",msg];
}


//赎回cdp
+ (NSString *)getCdpRedeemHexWithBridgeModel:(BridgeModel *)bridgeModel cdpId:(NSString *)cdpId scoinsToRepay:(NSString*)scoinsToRepay assetAmount:(NSString*)assetAmount assetSymbol:(NSString *)assetSymbol{
    
    NSError *error = nil;
    NSString *private = @"";
    if ([bridgeModel.privateKey isEqualToString:@""]){
        private = WiccwalletGetPrivateKeyFromMnemonic(bridgeModel.helpStr, [self getNetType],&error);
    }else{
        private = bridgeModel.privateKey;
    }
    UInt64 fee = bridgeModel.fees*100000000+(NSInteger)(arc4random() % 100);
    WiccwalletCdpRedeemTxParam * para = [[WiccwalletCdpRedeemTxParam alloc] init];
    para.validHeight = bridgeModel.validHeight;
    para.srcRegId = bridgeModel.srcRegId;
    para.pubKey = WiccwalletGetPubKeyFromPrivateKey(private, &error);
    para.feeSymbol = bridgeModel.feeSymbol;
    para.fees = fee;
    para.cdpTxid = cdpId;
    para.scoinsToRepay = [self handelNumMultiply8:scoinsToRepay];
    
    WiccwalletAssetModels * assets = [[WiccwalletAssetModels alloc] init];
    WiccwalletAssetModel * assetM = [[WiccwalletAssetModel alloc] init];
    assetM.assetAmount = [self handelNumMultiply8:assetAmount];
    assetM.assetSymbol = assetSymbol;
    [assets add:assetM];
    para.assets = assets;
    
    NSString *hex = WiccwalletSignCdpRedeemTx(private, para, &error);
    if (hex){
        return hex;
    }
    NSDictionary * errorMSg = error.userInfo;
    NSString *msg = errorMSg[@"NSLocalizedDescription"];
    NSLog(@"赎回cdp签名出错了%@",msg);
    return [NSString stringWithFormat:@"error-%@",msg];
}


//清算cdp
+ (NSString *)getCdpdLiquidHexWithBridgeModel:(BridgeModel *)bridgeModel cdpId:(NSString *)cdpId scoinsLiquidate:(NSString*)scoinsLiquidate assetSymbol:(NSString *)assetSymbol{
    
    NSError *error = nil;
    NSString *private = @"";
    if ([bridgeModel.privateKey isEqualToString:@""]){
        private = WiccwalletGetPrivateKeyFromMnemonic(bridgeModel.helpStr, [self getNetType],&error);
    }else{
        private = bridgeModel.privateKey;
    }
    UInt64 fee = bridgeModel.fees*100000000+(NSInteger)(arc4random() % 100);
    WiccwalletCdpLiquidateTxParam * para = [[WiccwalletCdpLiquidateTxParam alloc] init];
    para.validHeight = bridgeModel.validHeight;
    para.srcRegId = bridgeModel.srcRegId;
    para.pubKey = WiccwalletGetPubKeyFromPrivateKey(private, &error);
    para.feeSymbol = bridgeModel.feeSymbol;
    para.fees = fee;
    para.cdpTxid = cdpId;
    para.scoinsLiquidate = [self handelNumMultiply8:scoinsLiquidate];
    para.assetSymbol = assetSymbol;
    
    NSString *hex = WiccwalletSignCdpLiquidateTx(private, para, &error);
    NSLog(@"清算的签名%@",hex);
    if (hex){
        return hex;
    }
    NSDictionary * errorMSg = error.userInfo;
    NSString *msg = errorMSg[@"NSLocalizedDescription"];
    NSLog(@"清算cdp签名出错了%@",msg);
    return [NSString stringWithFormat:@"error-%@",msg];
}


//Dex限价
+ (NSString *)getDexLimitHexWithBridgeModel:(BridgeModel *)bridgeModel assetSymbol:(NSString *)assetSymbol coinSymbol:(NSString *)coinSymbol price:(NSString *)price assetAmount:(NSString *)assetAmount dexTxType:(NSString*)dexTxType{
    
    NSError *error = nil;
    NSString *private = @"";
    if ([bridgeModel.privateKey isEqualToString:@""]){
        private = WiccwalletGetPrivateKeyFromMnemonic(bridgeModel.helpStr, [self getNetType],&error);
    }else{
        private = bridgeModel.privateKey;
    }
    UInt64 fee = bridgeModel.fees*100000000+(NSInteger)(arc4random() % 100);
    WiccwalletDexLimitTxParam * para = [[WiccwalletDexLimitTxParam alloc] init];
    para.validHeight = bridgeModel.validHeight;
    para.srcRegId = bridgeModel.srcRegId;
    para.pubKey = WiccwalletGetPubKeyFromPrivateKey(private, &error);
    para.feeSymbol = bridgeModel.feeSymbol;
    para.fees = fee;
    para.assetSymbol = assetSymbol;
    para.coinSymbol = coinSymbol;
    para.price = [self handelNumMultiply8:price];
    para.assetAmount = [self handelNumMultiply8:assetAmount];
    NSString *hex = @"";
    if ([dexTxType isEqualToString:@"Limit_BUY"]){
        hex = WiccwalletSignDexBuyLimitTx(private, para, &error);
    }else{
        hex = WiccwalletSignDexSellLimitTx(private, para, &error);
    }
    NSLog(@"DexLimitTx==========>%@",hex);
    if (hex){
        return hex;
    }
    NSDictionary * errorMSg = error.userInfo;
    NSString *msg = errorMSg[@"NSLocalizedDescription"];
    NSLog(@"DexLimitTx签名出错了%@",msg);
    return [NSString stringWithFormat:@"error-%@",msg];
}
//Dex市价
+ (NSString *)getDexMarketHexWithBridgeModel:(BridgeModel *)bridgeModel assetSymbol:(NSString *)assetSymbol coinSymbol:(NSString *)coinSymbol assetAmount:(NSString *)assetAmount dexTxType:(NSString *)dexTxType{
    
    NSError *error = nil;
    NSString *private = @"";
    if ([bridgeModel.privateKey isEqualToString:@""]){
        private = WiccwalletGetPrivateKeyFromMnemonic(bridgeModel.helpStr, [self getNetType],&error);
    }else{
        private = bridgeModel.privateKey;
    }
    UInt64 fee = bridgeModel.fees*100000000+(NSInteger)(arc4random() % 100);
    WiccwalletDexMarketTxParam * para = [[WiccwalletDexMarketTxParam alloc] init];
    para.validHeight = bridgeModel.validHeight;
    para.srcRegId = bridgeModel.srcRegId;
    para.pubKey = WiccwalletGetPubKeyFromPrivateKey(private, &error);
    para.feeSymbol = bridgeModel.feeSymbol;
    para.fees = fee;
    para.assetSymbol = assetSymbol;
    para.coinSymbol = coinSymbol;
    para.assetAmount = [self handelNumMultiply8:assetAmount];
    NSString *hex = @"";
    if ([dexTxType isEqualToString:@"Market_BUY"]){
        hex = WiccwalletSignDexMarketBuyTx(private, para, &error);
    }else{
        hex = WiccwalletSignDexMarketSellTx(private, para, &error);
    }
    NSLog(@"DexMarketTx=======>%@",hex);
    if (hex){
        return hex;
    }
    NSDictionary * errorMSg = error.userInfo;
    NSString *msg = errorMSg[@"NSLocalizedDescription"];
    NSLog(@"DexMarketTx签名出错了%@",msg);
    return [NSString stringWithFormat:@"error-%@",msg];
}

//Dex取消
+ (NSString *)getDexCancelHexWithBridgeModel:(BridgeModel *)bridgeModel dexTxid:(NSString *)dexTxid{
    
    NSError *error = nil;
    NSString *private = @"";
    if ([bridgeModel.privateKey isEqualToString:@""]){
        private = WiccwalletGetPrivateKeyFromMnemonic(bridgeModel.helpStr, [self getNetType],&error);
    }else{
        private = bridgeModel.privateKey;
    }
    UInt64 fee = bridgeModel.fees*100000000+(NSInteger)(arc4random() % 100);
    WiccwalletDexCancelTxParam * para = [[WiccwalletDexCancelTxParam alloc] init];
    para.validHeight = bridgeModel.validHeight;
    para.srcRegId = bridgeModel.srcRegId;
    para.pubKey = WiccwalletGetPubKeyFromPrivateKey(private, &error);
    para.feeSymbol = bridgeModel.feeSymbol;
    para.fees = fee;
    para.dexTxid = dexTxid;
    NSString *hex = WiccwalletSignDexCancelTx(private, para, &error);
    NSLog(@"DexMarketTx=========>%@",hex);
    if (hex){
        return hex;
    }
    NSDictionary * errorMSg = error.userInfo;
    NSString *msg = errorMSg[@"NSLocalizedDescription"];
    NSLog(@"DexMarketTx签名出错了%@",msg);
    return [NSString stringWithFormat:@"error-%@",msg];
}















+ (uint64_t)handelNumMultiply8:(NSString*) strValue{
    
    NSDecimalNumber * num = [NSDecimalNumber decimalNumberWithString:strValue];
    NSDecimalNumber * bbb = [NSDecimalNumber decimalNumberWithString:@"100000000"];
    NSDecimalNumber * ccc = [num decimalNumberByMultiplyingBy:bbb];
    uint64_t aaaa = [ccc longLongValue];
    return aaaa;
}
+ (NSString *)handelNumDivide8:(NSString *)strValue{
//    NSLog(@"%@",strValue);
    if ([strValue isEqualToString:@"- -"] || [strValue isEqualToString:@""]){
        return @"";
    }
    NSDecimalNumber * num = [NSDecimalNumber decimalNumberWithString:strValue];
    NSDecimalNumber * bbb = [NSDecimalNumber decimalNumberWithString:@"100000000"];
    NSDecimalNumber * ccc = [num decimalNumberByDividingBy:bbb];
    return ccc.description;
}

+ (NSString*)handelA_Mul_B_withA:(NSString *)A B:(NSString*)B{
    
//    NSLog(@"%@,%@",A,B);
    
    if ([A isEqualToString:@"— —"] || [B isEqualToString:@"— —"] || [A isEqualToString:@""] || [B isEqualToString:@""]){
        return @"";
    }
    NSDecimalNumber * aaa = [NSDecimalNumber decimalNumberWithString:A];
    NSDecimalNumber * bbb = [NSDecimalNumber decimalNumberWithString:B];
    
    NSDecimalNumber * ccc = [aaa decimalNumberByMultiplyingBy:bbb];

    return ccc.description;
}


@end
