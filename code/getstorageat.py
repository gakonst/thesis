
$ ipython
In [1]: from web3 import Web3, HTTPProvider
In [2]: import os
In [3]: INFURA_API = os.environ['INFURA_API']
In [4]: w3 = Web3(HTTPProvider('https://mainnet.infura.io/'+INFURA_API))
In [5]: w3.eth.getStorageAt(w3.toChecksumAddress('0xd8993F49F372BB014fB088eaBec95cfDC795CBF6'),  0)
Out[5]: HexBytes('0x0000000000000000000000000000000000000000000000000000000000000001')
