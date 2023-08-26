### tỷ lệ
- Challenger: 1%
- Grandmaster: 3%
- Master: 5%
- Diamond: 10%
- Platinum: 15%
- Golden: 15%
- Silver: 20%
- Bronze: 31%

### Lệnh

``` 
yarn hardhat compile 
yarn hardhat deploy --network goerli
```


0x404f79c45D27512D05C1EBfdBA6FF4B3Ffc6b6e5

### Cách nhận các key config

#### ETHERSCAN_API_KEY

Truy cập: 

``` https://etherscan.io/myapikey ```

- Nếu chưa có key thì Add

#### PRIVATE_KEY

Truy cập:

```Extention Metamask -> Show detail -> Private key ```


### GOERLI_RPC_URL

Truy cập:

``` https://dashboard.alchemy.com/apps ```

#### subscriptionId in helper-hardhat-config

Truy cập: 
``` https://vrf.chain.link/goerli/ ```
Tạo mới -> Sau khi deploy thì lấy contract gắn vào consumer



### Phải có ETH mới thực hiện được

Cách nhận ETH:

- https://coinbase.com/faucets

Cách nhận LINK (Dùng trong Subscription VRF):

- https://faucets.chain.link/goerli


## API

### Tạo NFT

```
POST http://localhost:8000/api/nft/mint

```
*Notice: Sau khi tạo NFT, thì phải đợi khoảng 30s-1p để blockchain cập nhật lại smartcontract.
Nguyên nhân phải đợi là để lấy được tokenId của NFT đó (điều kiện để gửi và xem thông tin NFT)

### Chuyển NFT
```
POST http://localhost:8000/api/nft/transfer

Body: address_to ( địa chỉ ví cần chuyển )
```

### Xem thông tin NFT
```
GET http://localhost:8000/api/nft/info

```

