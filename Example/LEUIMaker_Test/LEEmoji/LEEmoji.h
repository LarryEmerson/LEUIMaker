//
//  LEEmoji.h
//  guguxinge
//
//  Created by emerson larry on 2016/12/9.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LEFoundation/LEFoundations.h>
#import <UIKit/UIKit.h>
#import <LEUIMaker/LEUIMaker.h>

#define LEEmojiActivity @"🎭\n👾\n🎨\n🎰\n🏆\n🎫\n⚽\n⚾ \n🏀\n🏈\n🏉\n🎾\n🎳\n🎪\n🎱\n🎯\n⛸\n⛳\n🎣\n🎽\n🏄\n🏂\n⛷\n🎿\n🚣\n🏇\n🏊\n⛹\n🚵\n🚴\n🎼\n🎤\n🎮\n🎧\n🎷\n🎻\n🎲\n🎹\n🎬\n🎸\n🎺"
#define LEEmojiAnimals @"🙈\n🙉\n🙊\n💥\n💦\n💨\n💫\n🐵\n🐒\n🐶\n🐕\n🐩\n🐺\n🐱\n🐈\n🐯\n🐅\n🐆\n🐴\n🐎\n🐮\n🐂\n🐃\n🐄\n🐷\n🐖\n🐗\n🐽\n🐏\n🐑\n🐐\n🐪\n🐫\n🐘\n🐭\n🐁\n🐀\n🐹\n🐰\n🐇\n🐻\n🐨\n🐼\n🐾\n🐔\n🐓\n🐣\n🐤\n🐥\n🐦\n🐧\n🐸\n🐊\n🐢\n🐍\n🐲\n🐉\n🐳\n🐋\n🐬\n🐟\n🐠\n🐡\n🐙\n🐚\n🐌\n🐛\n🐜\n🐝\n🐞\n💐\n🌸\n💮\n🌹\n🌺\n🌻\n🌼\n🌷\n🌱\n🌲\n🌳\n🌴\n🌵\n🌾\n🌿\n🍀\n🍁\n🍂\n🍃\n🍄\n🌰\n🌍\n🌎\n🌏\n🌐\n🌑\n🌒\n🌓\n🌔\n🌕\n⛈\n🌖\n🌗\n🌘\n🌙\n🌚\n🌛\n🌜\n🌝\n🌞\n⭐\n🌟\n🌠\n⛅\n🌈\n⛄\n🔥\n💧\n🌊\n🎄\n✨\n🎋\n🎍\n"
#define LEEmojiFlags @"🏁\n🚩\n🎌\n🇦🇨\n🇦🇪\n🇦🇫\n🇦🇬\n🇦🇮\n🇦🇱\n🇦🇲\n🇦🇴\n🇦🇶\n🇦🇷\n🇦🇸\n🇦🇹\n🇦🇺\n🇦🇼\n🇦🇽\n🇦🇿\n🇧🇦\n🇧🇧\n🇧🇩\n🇧🇪\n🇧🇫\n🇧🇬\n🇧🇭\n🇧🇮\n🇧🇯\n🇧🇱\n🇧🇲\n🇧🇳\n🇧🇴\n🇧🇶\n🇧🇷\n🇧🇸\n🇧🇹\n🇧🇻\n🇧🇼\n🇧🇾\n🇧🇿\n🇨🇦\n🇨🇨\n🇨🇩\n🇨🇫\n🇨🇬\n🇨🇮\n🇨🇰\n🇨🇭\n🇨🇱\n🇨🇲\n🇨🇵\n🇨🇷\n🇨🇺\n🇨🇻\n🇨🇳\n🇨🇴\n🇨🇼\n🇨🇽\n🇨🇾\n🇨🇿\n🇩🇬\n🇩🇯\n🇩🇰\n🇩🇲\n🇩🇴\n🇩🇪\n🇩🇿\n🇪🇦\n🇪🇨\n🇪🇪\n🇪🇬\n🇪🇭\n🇪🇷\n🇪🇹\n🇪🇺\n🇫🇯\n🇫🇰\n🇫🇲\n🇫🇴\n🇬🇦\n🇬🇩\n🇬🇪\n🇬🇫\n🇬🇬\n🇬🇭\n🇬🇮\n🇬🇱\n🇬🇲\n🇪🇸\n🇬🇳\n🇬🇵\n🇬🇶\n🇬🇷\n🇫🇮\n🇬🇸\n🇬🇹\n🇬🇺\n🇬🇼\n🇬🇾\n🇫🇷\n🇭🇰\n🇬🇧\n🇭🇲\n🇭🇳\n🇭🇷\n🇭🇹\n🇭🇺\n🇮🇨\n🇮🇩\n🇮🇪\n🇮🇱\n🇮🇲\n🇮🇳\n🇮🇴\n🇮🇶\n🇮🇷\n🇮🇸\n🇯🇪\n🇯🇲\n🇯🇴\n🇰🇪\n🇰🇬\n🇰🇭\n🇰🇮\n🇰🇲\n🇰🇳\n🇰🇵\n🇰🇼\n🇰🇾\n🇰🇿\n🇱🇦\n🇱🇧\n🇱🇨\n🇱🇮\n🇱🇰\n🇱🇷\n🇱🇸\n🇱🇹\n🇱🇺\n🇱🇻\n🇱🇾\n🇮🇹\n🇲🇦\n🇲🇨\n🇲🇩\n🇲🇪\n🇲🇫\n🇯🇵\n🇲🇬\n🇲🇭\n🇲🇰\n🇲🇱\n🇲🇲\n🇲🇳\n🇲🇴\n🇰🇷\n🇲🇵\n🇲🇶\n🇲🇷\n🇲🇸\n🇲🇹\n🇲🇺\n🇲🇻\n🇲🇼\n🇲🇽\n🇲🇾\n🇲🇿\n🇳🇦\n🇳🇨\n🇳🇪\n🇳🇫\n🇳🇬\n🇳🇮\n🇳🇱\n🇳🇴\n🇳🇵\n🇳🇷\n🇳🇺\n🇴🇲\n🇵🇦\n🇵🇪\n🇵🇫\n🇵🇬\n🇵🇰\n🇵🇱\n🇵🇲\n🇵🇳\n🇵🇷\n🇵🇸\n🇵🇼\n🇵🇾\n🇶🇦\n🇷🇪\n🇷🇴\n🇷🇸\n🇷🇼\n🇸🇧\n🇸🇨\n🇸🇩\n🇸🇪\n🇸🇬\n🇸🇭\n🇸🇮\n🇸🇯\n🇳🇿\n🇸🇰\n🇸🇱\n🇸🇲\n🇸🇳\n🇸🇴\n🇵🇭\n🇸🇷\n🇸🇸\n🇸🇹\n🇸🇻\n🇸🇽\n🇵🇹\n🇸🇾\n🇸🇿\n🇹🇦\n🇹🇨\n🇷🇺\n🇸🇦\n🇹🇩\n🇹🇫\n🇹🇬\n🇹🇭\n🇹🇯\n🇹🇰\n🇹🇱\n🇹🇲\n🇹🇳\n🇹🇴\n🇹🇷\n🇹🇹\n🇹🇻\n🇹🇿\n🇺🇦\n🇺🇬\n🇺🇲\n🇺🇾\n🇺🇿\n🇻🇦\n🇻🇨\n🇻🇪\n🇻🇬\n🇻🇮\n🇻🇳\n🇻🇺\n🇼🇫\n🇼🇸\n🇽🇰\n🇾🇪\n🇾🇹\n🇿🇲\n🇿🇼\n🇺🇸\n🇿🇦\n🇦🇩"
#define LEEmojiFood @"🍄\n🌰\n🍉\n🍈\n🍌\n🍇\n🍊\n🍎\n🍍\n🍑\n🍋\n🍅\n🍐\n🍆\n🍒\n🍏\n🍓\n🌽\n🍞\n🍔\n🍖\n🍟\n🍕\n🍳\n🍗\n🍲\n🍘\n🍚\n🍙\n🍛\n🍜\n🍠\n🍣\n🍝\n🍢\n🍱\n🍤\n🍥\n🍦\n🍩\n🍧\n🎂\n🍪\n🍨\n🍡\n🍫\n🍰\n🍬\n🍼\n🍯\n🍭\n🍮\n🍶\n🍷\n🍵\n🍹\n🍺\n🍸\n🍴\n🍻"
#define LEEmojiObjects @"⛱\n💴\n💵\n💶\n💷\n🗿\n💌\n💣\n🔪\n💎\n💈\n🚪\n🚿\n🚽\n🛀\n⏰\n⏳\n🛁\n⏱\n🎈\n🎎\n⏲\n🎀\n🎁\n🎊\n📯\n🎐\n🎏\n📻\n📱\n📲\n📞\n🎉\n🔌\n📠\n📟\n🔋\n💾\n💽\n💻\n💿\n🎥\n📷\n📹\n📼\n📺\n🔎\n🔍\n🔭\n📡\n🔬\n🔦\n💡\n🏮\n📕\n📖\n📗\n📘\n📔\n📚\n📓\n📙\n📜\n📄\n📑\n🔖\n📃\n💰\n📰\n💳\n📨\n📩\n📥\n📦\n📤\n💸\n📫\n📪\n📮\n📧\n📭\n📀\n📝\n📁\n📂\n📬\n📅\n📆\n📉\n📊\n📋\n📍\n📌\n📇\n📎\n📏\n📐\n🔒\n📈\n🔏\n🔐\n🔓\n🔨\n⛏\n🔑\n🔫\n🔩\n🔧\n🔗\n⛓\n🚬\n💊\n🏁\n🎌\n🔮\n🚰\n💉\n🚩"
#define LEEmojiSmileys @"😁\n😂\n😃\n😄\n😅\n😆\n😉\n😊\n😋\n😎\n😍\n😘\n😚\n😐\n😶\n😏\n😣\n😥\n😪\n😫\n😌\n😜\n😝\n😒\n😓\n😔\n😲\n😖\n😞\n😤\n😢\n😭\n😨\n😩\n😰\n😱\n😳\n😵\n😡\n😠\n😇\n😷\n😈\n👿\n👹\n👺\n💀\n👻\n👽\n💩\n😺\n😸\n😹\n😻\n😼\n😽\n🙀\n😿\n😾\n👦\n👧\n👨\n👩\n👴\n👵\n👶\n👼\n👮\n💂\n👷\n👳\n👱\n🎅\n👸\n👰\n👲\n🙍\n🙎\n🙅\n🙆\n💁\n🙋\n🙇\n💆\n💇\n🚶\n🏃\n💃\n👯\n👤\n👥\n👫\n👬\n👭\n💏\n💑\n👪\n💪\n👈\n👉\n👆\n👇\n✋\n👌\n👍\n👎\n✊\n👊\n👋\n👏\n👐\n🙌\n🙏\n💅\n👂\n👃\n👣\n👀\n👅\n👄\n💋\n👓\n👔\n👕\n👖\n👗\n👘\n👙\n👚\n👛\n👜\n👝\n🎒\n👞\n👟\n👠\n👡\n👢\n👑\n👒\n🎩\n🎓\n⛑\n💄\n💍\n🌂\n💼"
#define LEEmojiSymbols @"💮\n💈\n📯\n🚰\n💖\n💕\n💓\n💗\n💙\n💜\n💚\n💝\n💘\n💞\n💛\n💟\n💢\n💬\n💔\n💤\n🕛\n🕑\n🕜\n🕧\n💭\n🕐\n🕝\n🕒\n🕓\n🕞\n🕟\n🕕\n🕠\n🕖\n🕗\n🕢\n🕡\n🕣\n🕘\n🕔\n🕙\n🕤\n🕥\n🕦\n🌀\n🕚\n🀄\n🃏\n🔊\n🔇\n🎴\n🔈\n📣\n🎶\n📢\n🔕\n🔉\n🎵\n🔔\n🚮\n🏧\n🚺\n🚹\n🚻\n🚼\n🚫\n🚸\n⛔\n🚾\n🚭\n🚳\n🚷\n🚱\n🚯\n🔞\n🔙\n🔄\n🔃\n🔚\n🔜\n🔝\n🔛\n🔯\n📛\n🔱\n❌\n🔰\n➕\n➗\n✅\n➖\n➿\n❎\n❗\n➰\n❔\n❓\n❕\n🔁\n🔀\n🔂\n⛎\n⏩\n🔼\n⏫\n🔽\n📶\n⏬\n📳\n🎦\n🔅\n🔆\n📴\n💯\n🔟\n⏪\n🔡\n🔠\n🔢\n🆎\n🅱 \n🔣\n🅰 \n🆑\n🆓\n🆒\n🆔\n🔤\n🆕\n🅿 \n🆖\n🅾 \n🆙\n🈁\n🆘\n🆚\n🆗\n🈷 \n🈂 \n🉐 \n🈶 \n🈹 \n🈯 \n🈸 \n🈲 \n🈚 \n🈴 \n🈳 \n🈵 \n🈺 \n⬜\n🔶\n🔹\n⬛\n🔺\n🔷\n🔸\n🔻\n🔲\n🔴\n🔳\n💠\n🉑 \n🔵\n⭕"
#define LEEmojiTravel @"🗾\n⛰\n🌋\n🗻\n🏠\n🏡\n🏢\n🏣\n🏤\n🏥\n🏦\n🏨\n🏩\n🏪\n🏫\n🏬\n🏭\n🏯\n🏰\n💒\n🗼\n🗽\n⛪\n⛩\n⛲\n⛺\n🌁\n🌃\n🌅\n🌆\n🌇\n🌉\n🌌\n🎠\n🎡\n🎢\n🚂\n🚃\n🚄\n🚅\n🚆\n🚇\n🚈\n🚉\n🚊\n🚝\n🚞\n🚋\n🚌\n🚍\n🚎\n🚐\n🚑\n🚒\n🚓\n🚔\n🚕\n🚖\n🚗\n🚘\n🚚\n🚛\n🚜\n🚲\n🚏\n⛽\n⛴\n🚨\n🚥\n🚦\n🚧\n⛵\n🚤\n🚢\n✈ \n⛱\n💺\n🚁\n🚟\n🚠\n🚡\n🚀\n🌠\n🎆\n🎇\n🎑\n🚣\n💴\n💵\n💶\n💷\n🗿\n🛂\n🛃\n🛄\n🛅\n🌄"

#define LEEmojiIcons @[@"emoji_icon_history",@"emoji_icon_smileys",@"emoji_icon_animals",@"emoji_icon_food",@"emoji_icon_activity",@"emoji_icon_travel",@"emoji_icon_objects",@"emoji_icon_symbols",@"emoji_icon_flags"]
#define LEEmojiData @[LEEmojiSmileys,LEEmojiAnimals,LEEmojiFood,LEEmojiActivity,LEEmojiTravel,LEEmojiObjects,LEEmojiSymbols,LEEmojiFlags]
#define LEEmojiKeyboardShow @"LEEmojiKeyboardShow"
#define LEEmojiKeyboardHide @"LEEmojiKeyboardHide"
#define LEEmojiDeleteIcon @"emoji_icon_delete"
#define LEEmojiSwitchToEmoji @"emoji_icon_switchtoemoji"
#define LEEmojiSwitchToKeyboard @"emoji_icon_switchtokeyboard"
 
#define LEEmojiBGColor [UIColor colorWithRed:0.965 green:0.966 blue:0.970 alpha:1.000]
@protocol LEEmojiDelegate <NSObject>
-(void) leOnInputEmoji:(NSString *) emoji;
-(void) leOnDeleteEmoji;
@optional
-(void) leOnKeyboardHeightChanged:(CGFloat) height;
-(void) leOnSwitchedToEmoji:(BOOL) emoji;
@end

@interface LEEmoji : NSObject
LESingleton_interface(LEEmoji)
-(void) leInitEmojiWithDeleteIcon:(UIImage *) del KeyboardIcon:(UIImage *) keyboard EmojiIcon:(UIImage *) emoji;
-(void) leSetDelegate:(id<LEEmojiDelegate>) delegate;
-(void) leSetCategoryIcons:(NSArray *) icons Emojis:(NSArray *) emojis;
-(UIView *) leGetEmojiInputView;
-(UIView *) leGetSwitchBar;
+(NSString *) leDeleteLastFrom:(NSString *) string;
@end
