//
//  OutcryModel.h
//  ixit
//
//  Created by litong on 16/10/26.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "BaseMO.h"

@interface OutcryModel : BaseMO

@property (nonatomic, strong, readonly) NSNumber *outcryId;      /**< 喊单id */
@property (nonatomic, copy, readonly) NSString *title;           /**< 标题 */
@property (nonatomic, strong, readonly) NSNumber *operation;     /**< 操作方向 */
@property (nonatomic, copy, readonly) NSString *stopProfitPrice; /**< 止盈 */
@property (nonatomic, copy, readonly) NSString *stopLossPrice;   /**< 止损 */
@property (nonatomic, copy, readonly) NSString *limitation;      /**< 时效 */
@property (nonatomic, copy, readonly) NSString *remark;          /**< 备注 */
@property (nonatomic, copy, readonly) NSString *operationName;   /**< 操作方向名称 */
@property (nonatomic, copy, readonly) NSString *operationPrice;  /**< 行情价格 */
@property (nonatomic, copy, readonly) NSString *createTime;      /**< 创建时间 */


@property (nonatomic,copy) NSString *label;//(多个标签逗号分隔)
@property (nonatomic,copy) NSString *styleContent;// 带样式的内容
@property (nonatomic,assign) NSInteger top;//(大于0的代表置顶。),


- (NSString *)createTime_fmt;
- (NSArray *)lable_fmt;
- (NSAttributedString *)styleContent_fmt;
- (BOOL)top_fmt;

//label: "OPEC,LMCI,PCE,ADP,GDP,美联储",
//styleContent: "<p><em><strong>dfsasafsafdsafafdsaf</strong></em></p> ",
//top: 3


@end
