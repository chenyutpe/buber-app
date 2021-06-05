"""
pip install pymongo
pip install pymongo[srv]
"""
from pymongo import MongoClient
from bson import *
from gridfs import *
import os
import io
import time

#host = '127.0.0.1'
#port = 27017
db = 'database'
url = 'mongodb+srv://root:SAD_PrOjEcT@database.pnnbu.mongodb.net/myFirstDatabase?retryWrites=true&w=majority'

class Connection():
    """
    連線到資料庫
    """

    #__host = host
    #__port = port
    __db = db
    __client = None
    def __init__(self):
        """
        建立一個新的實例，如果還沒有的話
        """
        if Connection.__client == None:
            Connection.__client = MongoClient(url)
        self.db = Connection.__client[Connection.__db]
    
    #註冊
    def newUser(self, sid:str, password:str, name:str):
        """
        註冊

        @param sid: str: 學號
        @param password: str: 密碼
        @param name: str: 暱稱

        @return: objid : 成功的話返回objid
               : None : 失敗返回None
        """
        check = self.db.user.find_one({"sid": sid})
        if not check:
            print("可以註冊")
            doc = {
                'sid': sid,
                'name': name,
                'password': password,
                'dept': '',
                'grade': 0,
                'gender': '-',
                'is_driver': 0,
                'prate': 0,
                'drate': 0,
                'cert': None
            }
            result = self.db.user.insert_one(doc)
            return result.inserted_id
        print('帳號已經存在')
        return None

    #登入
    def login(self, sid: str, password: str):
        """
        登入

        @param sid: str: 學號
        @param password: str: 密碼

        @return: dict : 成功的話返回使用者資料
               : None : 失敗返回None
        """
        result = self.db.user.find_one({'sid': sid, 'password': password}, {'password': False})
        if result != None:
            print('登入成功')
            return result
        print('登入失敗')
        return None

    #拿到用戶資料
    def getUserData(self, oid: ObjectId):
        """
        拿到用戶資料

        @param oid: 用戶的object id

        @return: dict : 成功的話返回用戶的資料
               : None : 失敗返回None
        """
        return self.db.user.find_one({'_id': oid}, {'password': False})

    #新的共乘
    def newRequest(self, pid: ObjectId, s: str, d: str):
        """
        新增一個共乘

        @param pid: 乘客的object id
        @param s: str: 起點
        @param d: str: 終點
        @return: objid : 返回訂單的oid
        """
        doc = {
            'pid': pid,
            'did': None,
            's': s,
            'd': d, 
            'state': 0, 
            'prate': None,
            'drate': None,
            'time': time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        }
        result = self.db.request.insert_one(doc)
        return result.inserted_id

    #拿到特定共乘的資料
    def getRequestData(self, oid: ObjectId()):
        """
        拿到特定共乘的資料

        @param oid: 共乘的object id

        @return: dict : 成功的話返回共乘的資料
               : None : 失敗返回None
        """
        return self.db.request.find_one({'_id': oid})

    def getReqListOf(self, pid: ObjectId()):
        return self.db.request.find({'pid': pid})
    
    def getDriveListOf(self, did: ObjectId()):
        return self.db.request.find({'did': did})

    #搜尋共乘
    def search(self, s: str = '', d: str = ''):
        """
        搜尋共乘

        @param s: str: 起點
            default = ''
        @param d: str: 終點
            default = ''

        @return: cursor: 回傳mongodb的清單物件
        """
        doc = {'state': 0}
        if s != '': doc['s'] = {'$regex': s, '$options': 'i'}
        if d != '': doc['d'] = {'$regex': d, '$options': 'i'}
        print(doc)
        return self.db.request.find(doc)
    
    #接受共乘
    def takeRequest(self, oid: ObjectId, did: ObjectId):
        """
        駕駛接受一個共乘

        @param oid: 共乘的object id
        @param did: 駕駛的object id

        @return: dict : 成功的話返回共乘的資料
               : None : 失敗返回None
        """
        data = self.db.request.find_one({'_id': oid, 'state': 0})
        if data == None:
            print('訂單已經不存在')
            return data
        if did == data['pid']:
            print('錯誤，駕駛和乘客是同一人')
            return None
        result = self.db.request.update_one({'_id': oid}, {'$set': {'state': 1, 'did': did}})
        if result.raw_result['nModified'] != 1:
            print('錯誤')
            return None
        
        data['state'] = 1
        data['did'] = did
        return data

    #取消共乘
    def cancelReq(self, oid: ObjectId, id: ObjectId):
        """
        取消共乘

        @param oid: objid: 訂單的oid
        @param id: objid: 按下取消的人的id

        @return: boolean: 成功失敗
        """
        result = self.db.request.find_one({
            '_id': oid,
            '$or': [
                {'state': 0},
                {'state': 1}
            ]
        })
        if result == None:
            print('取消訂單失敗，訂單已經完成或取消，或訂單id不正確')
            return False
        
        state = 0
        if result['state'] == 0 and result['pid'] == id:
            state = 3
        elif result['state'] == 1 and result['pid'] == id: # 乘客許消
            state = 4
        elif result['state'] == 1 and result['did'] == id: # 司機取消
            state = 5
        
        if state == 0:
            print('取消訂單失敗，使用者id不正確')
            return False
        result = self.db.request.update_one(
            {'_id': result['_id']},
            {
                '$set': {'state': state}
            }
        )
        if result.raw_result['nModified'] != 1:
            print('錯誤')
            return False
        return True

    #完成共乘
    def finishReq(self, oid: ObjectId, id: ObjectId):
        """
        乘客確認訂單完成

        @param oid: objid: 訂單的oid
        @param id: objid: 乘客的oid

        @return: boolean: 成功失敗
        """
        result = self.db.request.find_one({
            '_id': oid,
            'pid': id,
            'state': 1
        })
        if result == None:
            print('完成訂單失敗，訂單不存在或乘客錯誤，或狀態已改變')
            return False
        result = self.db.request.update_one(
            {'_id': oid},
            {
                '$set': {'state': 2}
            }
        )
        if result.raw_result['nModified'] != 1:
            print('錯誤')
            return False

        return True
    
    #評價
    def review(self, oid: ObjectId, id: ObjectId, rate: int):
        """
        給予評價

        @param oid: 訂單的oid,
        @param id: 乘客或者司機的oid

        @return: boolean: 成功失敗
        """
        if rate < 1 or rate > 5:
            print('評分失敗，分數超出範圍')
            return False
        result = self.db.request.find_one({
            '_id': oid, '$or': [{'state': 2}, {'state': 4}, {'state': 5}]
        })
        if result == None:
            print('評價失敗，找不到訂單或不是可評價的狀態')
            return False
        
        doc = {
            '$set':{}
        }
        toUpdate = '-'
        whoToUpdate = None
        if result['state'] == 2: #訂單完成
            if result['pid'] == id and result['drate'] == None: #給司機評分
                doc['$set']['drate'] = rate
                toUpdate = 'd'
                whoToUpdate = result['did']
            elif result['did'] == id and result['prate'] == None: #給乘客評分
                doc['$set']['prate'] = rate
                toUpdate = 'p'
                whoToUpdate = result['pid']
            else:
                print('評分失敗，用戶id錯誤或已經評分')
                return False
        elif result['state'] == 4 and result['did'] == id and result['prate'] == None: #乘客取消，司機評分
            doc['$set']['prate'] = rate
            toUpdate = 'p'
            whoToUpdate = result['pid']
        elif result['state'] == 5 and result['pid'] == id and result['drate'] == None: #司機取消，乘客評分
            doc['$set']['drate'] = rate
            toUpdate = 'd'
            whoToUpdate = result['did']
        else:
            print('評分失敗，訂單狀態或用戶id錯誤')
            return False
        
        
        result = self.db.request.update_one(
            {'_id': oid}, doc
        )
        if result.raw_result['nModified'] != 1:
            print('錯誤')
            return False
        self.__updateRate(whoToUpdate, toUpdate)
        return True

    def setDriver(self, oid: ObjectId):
        """
        把某個使用者設定成駕駛

        @param oid: objid: 使用者的oid
        @return: boolean: 成功失敗
        """
        result = self.db.user.update_one(
            {'_id': oid},
            {
                '$set': {'is_driver': 1}
            }
        )
        if result.raw_result['nModified'] != 1:
            print('錯誤')
            return False
        return True

    #修改個人資料
    def editProfile(self, oid: ObjectId, name: str = '', dept: str = '', grade: int = 0, gender: str = '-'):
        """
        更新使用者資料

        @param oid: objid: 使用者id
        @param name: str: 新的名字
        @param dept: str: 新的學系
        @param grade: int: 新的年級
        @param gender: str: 新的性別

        @return: boolean: 有無更新
        """
        doc = {'$set': {}}
        edit = False
        if name != '': 
            doc['$set']['name'] = name 
            edit = True
        if dept != '': 
            doc['$set']['dept'] = dept
            edit = True
        if grade != 0: 
            doc['$set']['grade'] = grade
            edit = True
        if gender == 'F' or gender == 'M': 
            doc['$set']['gender'] = gender
            edit = True
        #print(doc)
        if edit:
            result = self.db.user.update_one(
                {'_id': oid},
                doc
            )
            return result.raw_result['nModified'] == 1
        return edit

    def _getUsers(self):
        """
        回傳所有使用者的資料
        """
        return self.db.user.find({})

    def _getReqs(self):
        """
        回傳所有訂單資料
        """
        return self.db.request.find({})

    #更新被評價的人的評分
    def __updateRate(self, oid: ObjectId, operator: str):
        doc = {'$or': [{'state': 2}, {'state': 4}, {'state': 5}]}
        proj = {}
        token = ''
        if operator == 'p':
            token = 'prate'
            doc['pid'] = oid
            proj[token] = True
        elif operator == 'd':
            token = 'drate'
            doc['did'] = oid
            proj[token] = True
        else:
            return

        result = self.db.request.find(doc, proj)
        #for row in result:
        #    print(row)
        count = 0
        sum = 0
        for row in result:
            if row[token] != None:
                sum = sum + row[token]
                count = count + 1
        if count > 0:
            rate = sum / count
            self.db.user.update_one(
                {'_id': oid}, 
                {'$set': {token: rate}}
            )

    # 上傳停車證
    def uplodeCert(self, oid: ObjectId, f: io.BufferedReader, t: str):
        """
        存使用者上傳的圖片

        @param oid: objid: 使用者的id
        @param f: BufferReader: 檔案，mode = 'rb'
        @param t: str: 副檔名: 'jpg'、'png'...

        @return: boolean: 成功失敗
        """
        imgput = GridFS(self.db)
        result = self.db.user.find_one({'_id': oid})
        if not result:
            print('找不到使用者')
            return False

        if result['cert'] != None:
            imgput.delete(result['cert'])
        insertimg = imgput.put(f, type = t, name = str(oid))
        self.db.user.update_one(
            {'_id': oid},
            {'$set': {'cert': insertimg}}
        )

        return True

    # 匯出圖片
    def extractCert(self, oid, dir = './'):
        """
        把使用者上傳的圖片匯出到指定位置

        @param oid: objid: 使用者的id
        @param dir: str: 要匯出的資料夾

        @return: boolean: 成功失敗
        """
        gridFS = GridFS(self.db, collection="fs")
        target = self.db['fs.files'].find_one({'name': str(oid)})

        if target:
            data = gridFS.find_one({'_id': target['_id']}).read() 
            out = open(dir + str(oid) + '.' + target['type'],'wb')
            out.write(data)  
            out.close()
        else:
            print('找不到使用者上傳的圖片')
            return False
        return True