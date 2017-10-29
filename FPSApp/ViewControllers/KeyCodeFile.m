//
//  KeyCodeFile.m
//  FPSApp
//
//  Created by Rex on 2016/8/9.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "KeyCodeFile.h"

@implementation KeyCodeFile

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        [self setUp];
    }
    
    return self;
}

-(void)setUp{
    
    
   
}


-(NSString *)returnKeyboardKey:(int)keycode{
    
    NSString *key = @" ";
   
    switch (keycode) {
        case 0:
            key = @"None";
            break;
        case 1:
            key = @"ErrorRollOver";
            break;
        case 2:
            key = @"PostFail";
            break;
        case 3:
            key = @"ErrorUndefined";
            break;
            
        case 4:
            key = @"A";
            break;
        case 5:
            key = @"B";
            break;
        case 6:
            key = @"C";
            break;
        case 7:
            key = @"D";
            break;
        case 8:
            key = @"E";
            break;
        case 9:
            key = @"F";
            break;
        case 10:
            key = @"G";
            break;
        case 11:
            key = @"H";
            break;
        case 12:
            key = @"I";
            break;
        case 13:
            key = @"J";
            break;
        case 14:
            key = @"K";
            break;
        case 15:
            key = @"L";
            break;
        case 16:
            key = @"M";
            break;
        case 17:
            key = @"N";
            break;
        case 18:
            key = @"O";
            break;
        case 19:
            key = @"P";
            break;
        case 20:
            key = @"Q";
            break;
        case 21:
            key = @"R";
            break;
        case 22:
            key = @"S";
            break;
        case 23:
            key = @"T";
            break;
        case 24:
            key = @"U";
            break;
        case 25:
            key = @"V";
            break;
        case 26:
            key = @"W";
            break;
        case 27:
            key = @"X";
            break;
        case 28:
            key = @"Y";
            break;
        case 29:
            key = @"Z";
            break;
        
        case 30:
            key = @"1";
            break;
        case 31:
            key = @"2";
            break;
        case 32:
            key = @"3";
            break;
        case 33:
            key = @"4";
            break;
        case 34:
            key = @"5";
            break;
        case 35:
            key = @"6";
            break;
        case 36:
            key = @"7";
            break;
        case 37:
            key = @"8";
            break;
        case 38:
            key = @"9";
            break;
        case 39:
            key = @"0";
            break;
            
        case 40:
            key = @"L Enter";
            break;
        case 41:
            key = @"Esc";
            break;
        case 42:
            key = @"Backspace"; //2016.10.20
            break;
        case 43:
            key = @"Tab";
            break;
        case 44:
            key = @"Space";
            break;
        case 45:
            key = @"_";
            break;
        case 46:
            key = @"=";
            break;
        case 47:
            key = @"[";
            break;
        case 48:
            key = @"]";
            break;
        case 49:
            key = @"\\";
            break;
            
        case 50:
            key = @"#";
            break;
        case 51:
            key = @";";
            break;
        case 52:
            key = @"R ,";
            break;
        case 53:
            key = @"`";
            break;
        case 54:
            key = @"L ,";
            break;
        case 55:
            key = @".";
            break;
        case 56:
            key = @"/";
            break;
        case 57:
            key = @"Caps Lock";
            break;
        case 58:
            key = @"F1";
            break;
        case 59:
            key = @"F2";
            break;
            
        case 60:
            key = @"F3";
            break;
        case 61:
            key = @"F4";
            break;
        case 62:
            key = @"F5";
            break;
        case 63:
            key = @"F6";
            break;
        case 64:
            key = @"F7";
            break;
        case 65:
            key = @"F8";
            break;
        case 66:
            key = @"F9";
            break;
        case 67:
            key = @"F10";
            break;
        case 68:
            key = @"F11";
            break;
        case 69:
            key = @"F12";
            break;
            
        case 70:
            key = @"Prt Sc";
            break;
        case 71:
            key = @"Scroll";
            break;
        case 72:
            key = @"Pause";
            break;
        case 73:
            key = @"Insert";
            break;
        case 74:
            key = @"Home";
            break;
        case 75:
            key = @"Page Up";
            break;
        case 76:
            key = @"Delete";
            break;
        case 77:
            key = @"End";
            break;
        case 78:
            key = @"Page Down";
            break;
        case 79:
            key = @"→";
            break;

        case 80:
            key = @"←";
            break;
        case 81:
            key = @"↓";
            break;
        case 82:
            key = @"↑";
            break;
        case 83:
            key = @"Num Lock";
            break;
        case 84:
            key = @"R /";
            break;
        case 85:
            key = @"R *";
            break;
        case 86:
            key = @"R -";
            break;
        case 87:
            key = @"R +";
            break;
        case 88:
            key = @"R Enter";
            break;
        case 89:
            key = @"Num 1";
            break;
        case 90:
            key = @"Num 2";
            break;
        case 91:
            key = @"Num 3";
            break;
        case 92:
            key = @"Num 4";
            break;
        case 93:
            key = @"Num 5";
            break;
        case 94:
            key = @"Num 6";
            break;
        case 95:
            key = @"Num 7";
            break;
        case 96:
            key = @"Num 8";
            break;
        case 97:
            key = @"Num 9";
            break;
        case 98:
            key = @"Num 0";
            break;
        case 99:
            key = @"Del";
            break;
            
        case 100:
            key = @"'\'";
            break;
        case 101:
            key = @"Apps";
            break;
            
        case 105:
            key = @"Left";//MOUSE
            break;
        case 106:
            key = @"Right";//MOUSE
            break;

        case 112:
            key = @"L Ctrl";
            break;
        case 113:
            key = @"L Shift";
            break;
        case 114:
            key = @"L Alt";
            break;
        case 115:
            key = @"L Win";
            break;
            
        case 116:
            key = @"R Ctrl";
            break;
        case 117:
            key = @"R Shift";
            break;
        case 118:
            key = @"R Alt";
            break;
        case 119:
            key = @"R Win";
            break;
            
        default:
            break;
    }
    
    return key;
    
}







@end
