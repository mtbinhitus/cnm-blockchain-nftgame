# [CSC13115 - CNM] Đồ án nhóm cuối kì ứng dụng Blockchain
**Đề tài: Tạo một trò chơi khuyến mãi dựa vào cơ chế phát sinh ngẫu nhiên một cách minh bạch, công khai dựa vào Blockchain.(NFT, Smart Contract).**

### Thành viên nhóm
1. 18127139 - Tăng Trường Long
2. 1753030 - Mai Thanh Bình
3. 19127559 - Lương Trường Thịnh

- Tài liệu báo cáo về ý nghĩa đề tài, quá trình thực hiện, cách sử dụng, cách cài đặt: https://drive.google.com/drive/folders/1ONsjYz2uZPOsdIStGzWOeGWMKQhB8EMo?usp=drive_link
- Link video demo: https://drive.google.com/drive/folders/1ONsjYz2uZPOsdIStGzWOeGWMKQhB8EMo?usp=drive_link

## How to run the app
- Mở terminal/cmd/powershell thực hiện clone project:
```
git clone https://github.com/mtbinhitus/cnm-blockchain-nftgame.git
```

**1. Backend**
- Mở terminal/cmd/powershell tại thư mục ``server-blockchain``:
- Cài đặt dependencies:
```
yarn
```
- Compile contract:
```
yarn hardhat compile
```
- Chạy server:
```
node server/index.js
```
![image](https://github.com/mtbinhitus/cnm-blockchain-nftgame/assets/57026807/9f715c0f-bd99-4417-b8b9-15d39a246be7)

**2. Frontend**
- Mở terminal/cmd/powershell tại thư mục ``client-blockchain``:
- Cài đặt dependencies:
```
yarn
```
- Chạy client:
```
yarn run dev
```
- Truy cập Client:
``
http://localhost:5173/
``
![image](https://github.com/mtbinhitus/cnm-blockchain-nftgame/assets/57026807/2cca5f62-855a-4988-92c9-8155d8930499)

**Homepage**
![image](https://github.com/mtbinhitus/cnm-blockchain-nftgame/assets/57026807/03219a6a-ec0d-4ce0-be43-280770fb1a7b)

**Collection**
![image](https://github.com/mtbinhitus/cnm-blockchain-nftgame/assets/57026807/4de41632-8bf9-4692-9275-4ef08f7f6736)

**Mission**
![image](https://github.com/mtbinhitus/cnm-blockchain-nftgame/assets/57026807/f6827c62-0f25-4aed-83d5-870685d18327)

![image](https://github.com/mtbinhitus/cnm-blockchain-nftgame/assets/57026807/f1ff9e1a-1246-4035-8fff-820d72b27d51)

![image](https://github.com/mtbinhitus/cnm-blockchain-nftgame/assets/57026807/ea9ed1da-f82e-4e36-926b-501d36f3c9d1)

**Fortune Wheel**
![image](https://github.com/mtbinhitus/cnm-blockchain-nftgame/assets/57026807/879bd15f-362d-4606-9cec-2204e5afb652)

**Inventory**
![image](https://github.com/mtbinhitus/cnm-blockchain-nftgame/assets/57026807/80063bb3-815b-426c-b2da-69a94f47bcbd)

![image](https://github.com/mtbinhitus/cnm-blockchain-nftgame/assets/57026807/bb250697-70c2-4587-b519-e0edf0040544)
