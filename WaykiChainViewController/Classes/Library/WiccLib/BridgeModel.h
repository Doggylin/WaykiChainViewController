//
//  BridgeModel.h
//  CommApp
//
//  Created by lcl on 2019/11/5.
//  Copyright © 2019 sorath. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BridgeModel : NSObject

@property (nonatomic,strong) NSString * helpStr;
@property (nonatomic,strong) NSString * privateKey;
@property (nonatomic,strong) NSString * srcRegId;
@property (nonatomic,strong) NSString * feeSymbol;
@property (nonatomic) double fees;
@property (nonatomic) double validHeight;

@end

NS_ASSUME_NONNULL_END
