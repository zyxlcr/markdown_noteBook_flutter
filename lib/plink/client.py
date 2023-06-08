import socket
import struct
import io

HOST = '127.0.0.1'
PORT = 8989
class Message:
    def __init__(self):
        self.id = 0
        self.header_len = 0
        self.header = bytearray()
        self.body_len = 0
        self.body = bytearray()

    def get_id(self):
        return self.id

    def set_id(self, id):
        self.id = id

    def get_header_len(self):
        return self.header_len

    def set_header_len(self, header_len):
        self.header_len = header_len

    def get_header(self):
        return self.header

    def set_header(self, header):
        self.header = header

    def get_body_len(self):
        return self.body_len

    def set_body_len(self, body_len):
        self.body_len = body_len

    def get_body(self):
        return self.body

    def set_body(self, body):
        self.body = body


def pack( Message):
        # 创建一个存放bytes字节的缓冲
        data_buff = bytearray()

        # 写msgID
        data_buff += struct.pack("<I", Message.get_id())

        # 写headerLen
        data_buff += struct.pack("<I", Message.get_header_len())

        # 写bodyLen
        data_buff += struct.pack("<I", Message.get_body_len())

        # 写header
        data_buff += bytes(Message.get_header())

        # 写data数据
        data_buff += bytes(Message.get_body())

        return bytes(data_buff)


def Unpack( binaryData):
        # 创建一个从输入二进制数据的ioReader
        dataBuff = io.BytesIO(binaryData)

        # 只解压head的信息，得到dataLen和msgID
        # msg = Message()

        # 读msgID
        Id = struct.unpack("<I", dataBuff.read(4))[0]
        s = str(binaryData[:4])
        print("msgid", s,Id)

        # 读headerLen
        HeaderLen = struct.unpack("<I", dataBuff.read(4))[0]

        # 读bodyLen
        BodyLen = struct.unpack("<I", dataBuff.read(4))[0]
        s3 = str(binaryData[8:12])
        print("BodyLen", s3,BodyLen)

        # 读header
        headerBytes = dataBuff.read(HeaderLen)
        Header = headerBytes if len(headerBytes) == HeaderLen else b''

        # 读body
        bodyBytes = dataBuff.read(BodyLen)
        Body = bodyBytes if len(bodyBytes) == BodyLen else b''

        # 判断dataLen的长度是否超出我们允许的最大包长度
        # if (utils.GlobalObject.MaxPacketSize > 0 and msg.DataLen > utils.GlobalObject.MaxPacketSize):
        #     return None, Exception("Too large msg data recieved")

        # 这里只需要把head的数据拆包出来就可以了，然后再通过head的长度，再从conn读取一次数据
        return Body, Header

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    try:
        # 连接到服务端
        s.connect((HOST, PORT))
        print('Connected to server')

        m = Message()
        m.set_id(4196270080)
        m.set_header_len(33)
        m.set_body_len(9)
        m.set_header(b'{"Url":"/ping","From":"","To":""}')
        m.set_body(b'okkkk ooo')
        data2 = pack(m)

        # 发送数据到服务器
        s.sendall(data2)

        # 接收服务器响应
        data = s.recv(1024)
        message = data.decode().strip()
        # //message, header = Unpack(data)
        print(f'Received from server: {message} ')
    except Exception as e:
        print(f'Error: {e}')

