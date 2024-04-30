%lang starknet

@contract_interface
namespace IERC20:
    func transfer(to: felt, amount: Uint256):
    end

    func transferFrom(from: felt, to: felt, amount: Uint256):
    end

    func balanceOf(account: felt) -> (balance: Uint256):
    end

@contract_interface
namespace IComptroller:
    func enterMarkets(markets: felt):
    end

    func exitMarket(market: felt):
    end

@external
func deposit(
        token: felt,
        amount: Uint256,
        comptroller: felt,
        recipient: felt
    ):
    # 这里应该有一些安全检查，比如确保调用者有足够的余额和授权。
    # 为了简化，我们省略了这些检查。

    # 将代币从用户转移到合约。
    IERC20.transferFrom(token, recipient, contract_address, amount)

    # 在Comptroller中注册市场。
    IComptroller.enterMarkets(comptroller, [contract_address])

    # 实际的业务逻辑会在这里处理，比如更新内部余额等。
    # ...

    return ()
end

@external
func withdraw(
        token: felt,
        amount: Uint256,
        comptroller: felt,
        recipient: felt
    ):
    # 这里应该有一些安全检查，比如确保合约有足够的余额。
    # 为了简化，我们省略了这些检查。

    # 将代币从合约转移到用户。
    IERC20.transfer(token, amount, recipient)

    # 在Comptroller中注销市场。
    IComptroller.exitMarket(comptroller, contract_address)

    # 实际的业务逻辑会在这里处理，比如更新内部余额等。
    # ...

    return ()
end

@view
func checkBalance(token: felt, account: felt) -> (balance: Uint256):
    let (balance) = IERC20.balanceOf(token, account)
    return (balance)
end
