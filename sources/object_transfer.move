module object_transfer::account {
    use sui::transfer::{Self, Receiving};
    use sui::coin::{Self, Coin};
    use sui::object::{Self , UID};
    use sui::tx_context::{Self , TxContext};
    use sui::balance::{Self , Balance};
    use std::debug::print;

     struct AccountData<phantom T> has key {
        id: UID,
        coin: Balance<T>
    }
    
    public entry fun empty<T>(ctx : &mut TxContext) {
       let a =  AccountData<T>{
            id: object::new(ctx),
            coin : balance::zero<T>()
        };

        transfer::transfer(a , tx_context::sender(ctx))
    }

    public entry fun accept_payment<T>(account: &mut AccountData<T>, sent: Receiving<Coin<T>>): u64  {
        let coin = transfer::public_receive(&mut account.id, sent);
         print(&coin);
         let balance : Balance<T> = coin::into_balance(coin);
         print(&balance);
          balance::join( &mut account.coin ,balance )
    }


    public entry fun transfer_account<T>(c: Coin<T>, to: address, _ctx: &mut TxContext) {
        transfer::public_transfer(c, to);
    }
}