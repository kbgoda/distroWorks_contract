import json 
from web3 import Web3 

ganache_url = "HTTP://127.0.0.1:7545"
web3 = Web3(Web3.HTTPProvider(ganache_url))

web3.eth.defaultAccount = web3.eth.accounts[9]

# Abi is json contract array explaining how contract works
abi = json.loads('[{"constant":true,"inputs":[],"name":"totalSupplyOfCoin","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"tokenOwner","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"personName","type":"string"},{"name":"reviewId","type":"uint256"}],"name":"seeReview","outputs":[{"name":"","type":"uint256"},{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"receiver","type":"address"},{"name":"numTokens","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"review","type":"string"},{"name":"aName","type":"string"},{"name":"bName","type":"string"}],"name":"reviewPerson","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"total","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"sender","type":"address"},{"indexed":false,"name":"reciever","type":"address"},{"indexed":false,"name":"tokenAmount","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"sender","type":"address"},{"indexed":false,"name":"delegate","type":"address"},{"indexed":false,"name":"numTokens","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"name","type":"string"},{"indexed":false,"name":"message","type":"string"}],"name":"Reviewed","type":"event"}]')
# Address of smart contract
address = web3.toChecksumAddress("0x97585308d24a1974eb51f970cf26a200d270507c")

contract = web3.eth.contract(address=address, abi=abi)

# Writes review
tx_hash = contract.functions.reviewPerson('This is a awesome bloke!', 'Rob', 'Joseph').transact()
# signed = w3.eth.account.signTransaction(transaction, key)
web3.eth.waitForTransactionReceipt(tx_hash)
receipt = web3.eth.waitForTransactionReceipt(tx_hash)

print(receipt.gasUsed)

# Print first review of B.
# print(
#     contract.functions.seeReview('Joseph', 0).call()
#     )
print('returned value: {}'.format(contract.functions.seeReview('Joseph', 0).call()))

# Print reviews
# print()