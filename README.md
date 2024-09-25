# Fate Trigger Script

Archive containing the Network Protocol used by Fate Trigger

## Packet Structure

```
DataPack
|-----20----|------------------ Size ------------------|
|  PackHead |      MsgHead    |        MsgData         |
|---- 20 ---|-- MsgHeadSize --|--- Size-MsgHeadSize ---|

PackHead 数据包头, 固定20字节:
|00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19|
|-----4-----|-1|-1|-1|-1|------4----|------4----|--2--|--2--|
|           | V| F| T| C|           |           | MSG |     |
| G  R A  V | E| L| Y| R|  SEQUENCE |   SIZE    | HEAD|CHECK|
|           | R| A| P| Y|           |           | SIZE| CODE|
|           |  | G| E| P|           |           |     |     |
|-----4-----|-1|-1|-1|-1|------4----|------4----|--2--|--2--|
struct PackHead
{
    char[4]  Name;          // 固定协议头:"grav"
    uint8_t  Version;       // 版本号:1-255
    uint8_t  PackFlag;      // 协议标记:enum PackFlag
    uint8_t  MsgType;       // 消息类型:enum MsgType
    uint8_t  Crypto;        // 加密字段:enum CryptoType
    uint32_t Sequence;      // 序列号(网络字节序)
    uint32_t Size;          // PackHead之后的总长度:0-2^32(网络字节序)
    uint16_t MsgHeadSize;   // msg_head_data长度:0-2^16(网络字节序)
    uint16_t CheckCode;     // 校验码:0-2^16(msg_head+msg_data校验和)(网络字节序)
}
MsgHead 消息头, 长度为: PackHead.MsgHeadSize
MsgData 消息内容, 长度为: PackHead.Size-PackHead.MsgHeadSize
```