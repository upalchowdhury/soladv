from woke.testing import *
from pytypes.contracts.Amm import AMM
from pytypes.contracts.Counter import Counter


@default_chain.connect()
def test_counter():
    default_chain.set_default_accounts(default_chain.accounts[0])

    counter = AMM.deploy(0x3123,0x3345)
    assert counter.count() == 0

    counter.increment()
    assert counter.count() == 1

    