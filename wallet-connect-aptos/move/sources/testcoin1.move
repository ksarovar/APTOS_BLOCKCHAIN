module calculator::Calculator{
    use std::signer;
    use std::string::utf8;
    use std::string;
    use std::string::String;


    use aptos_framework::coin::{Self, MintCapability, FreezeCapability, BurnCapability};
    use aptos_framework::account;
    use aptos_framework::event::EventHandle;
    use aptos_framework::event;
    use std::vector;
    use aptos_framework::resource_account;
    use aptos_framework::account::SignerCapability;


    /// Represents test BTC coin.
    struct BTC {}
    struct USDT {}
    struct DAI {}
    struct TR {}
    
    

    struct CreateNewPoolEvent has store, drop {
        owner_addr: address,
        pool_addr: address,
    }

    // struct AddingEvent has store, drop {
    //     add_res: u256,
    // }

    struct Pools has key {
        pools: vector<address>,
        create_new_pool_events: EventHandle<CreateNewPoolEvent>,
        
    }

    struct PoolInfo has key{
        
        signer_cap: account::SignerCapability,
    }


    struct Add has key,store, drop {
        
        add_res: u256,
        
        
    }

    struct Calc has store,drop,key{
        operation: String,
        result: u64,
    }
    
   
    /// Storing mint/burn capabilities for `USDT` and `BTC` and `DAI` and `TR` coins under user account.
    struct Caps<phantom CoinType> has key {
        mint: MintCapability<CoinType>,
        freeze: FreezeCapability<CoinType>,
        burn: BurnCapability<CoinType>,
    }

    

    /// Initializes `BTC` and `USDT` and `DAI` and `TR` coins.
    public entry fun initialize<coinsymbol>(admin: &signer,
    name:String,
    coinsymbol:String,
    ) {
        let (btc_b, btc_f, btc_m) =
            coin::initialize<coinsymbol>(admin,
                name, coinsymbol, 8, true);        
        move_to(admin, Caps<coinsymbol> { mint: btc_m, freeze: btc_f, burn: btc_b });        
        register_coins_all(admin);
        
    }


    // only resource_account should call this
    public entry fun register_coins_all(account: &signer) {
        let account_addr = signer::address_of(account);
        if (!coin::is_account_registered<BTC>(account_addr)) {
            coin::register<BTC>(account);
        };      
        if (!coin::is_account_registered<USDT>(account_addr)) {
            coin::register<USDT>(account);
        }; 
        if (!coin::is_account_registered<DAI>(account_addr)) {
            coin::register<DAI>(account);
        }; 
        if (!coin::is_account_registered<TR>(account_addr)) {
            coin::register<TR>(account);
        };   
    }


    // Mints new coin `CoinType` on account `acc_addr`.
    public entry fun mint_coin<CoinType>(admin: &signer, acc_addr: address, amount: u64) acquires Caps {
        let admin_addr = signer::address_of(admin);
        let caps = borrow_global<Caps<CoinType>>(admin_addr);
        let coins = coin::mint<CoinType>(amount, &caps.mint);
        coin::deposit(acc_addr, coins);
    }


    public entry fun register<CoinType>(from: &signer) {
        coin::register<CoinType>(from);
    }


    public entry fun transfer<CoinType>(from: &signer, to: address, amount: u64) {
        coin::transfer<CoinType>(from, to, amount);
    }

    // fun create_pool_signer(pool_add: address): signer acquires PoolInfo {
    //     // let signer_cap = SignerCapability { pool_add };
    //      if (!exists<PoolInfo>(pool_add)) {
    //         move_to<PoolInfo>(pool_add, PoolInfo {
                
    //             signer_cap: SignerCapability{pool_add},

    //         });
    //      };
    //     let pool_info = borrow_global_mut<PoolInfo>(pool_add);

    //     account::create_signer_with_capability(&pool_info.signer_cap)
    // }


    public entry fun create_new_pool(owner: &signer) acquires Pools {
        let (pool_signer, signer_cap) = account::create_resource_account(owner, vector::empty());

        let pool_addr = signer::address_of(&pool_signer);
       

        if (!exists<Pools>(signer::address_of(owner))) {
            move_to<Pools>(owner, Pools {
                pools: vector::empty(),
                create_new_pool_events: account::new_event_handle(owner),

            });
        };
        let pools = borrow_global_mut<Pools>(signer::address_of(owner));


        event::emit_event(&mut pools.create_new_pool_events, CreateNewPoolEvent {
            owner_addr: signer::address_of(owner),
            pool_addr,
        });
          let pool = PoolInfo {
            
            signer_cap
        };
        move_to<PoolInfo>(owner, pool);
    }


    public entry fun add(owner: &signer, pool_add: address, a: u256, b: u256) acquires PoolInfo  {
                
      
        let c : u256 = a + b;
        // let pool_signer_res = create_pool_signer(pool_add);
        let pool_info = borrow_global_mut<PoolInfo>(signer::address_of(owner)); 
        let pool_sign =account::create_signer_with_capability(&pool_info.signer_cap);

        if (!exists<Add>(pool_add)) {
            move_to<Add>(&pool_sign, Add {
                
                add_res: c,

            });
        };
        
        // let sums = borrow_global_mut<Add>(signer::address_of(resource_account));


        // event::emit_event(&mut sums.add_events, AddingEvent {
        //             add_res: c,
        //     });
        
    
    }

    public entry fun calaculator(owner: &signer,d: u64, e: u64, option: u64, _operation: String ) acquires Calc{
        if(option == 1){
            let sum : u64 = d + e;
            if(!exists<Calc>(signer::address_of(owner))) {
                move_to<Calc>(owner,Calc{
                  operation: _operation ,
                  result: sum,
                });
            }
            else{
                 let addition = borrow_global_mut<Calc>(signer::address_of(owner));
                 addition.operation = _operation;
                 addition.result = sum;
            };

        };

        if(option == 2){
            let dif : u64 = d - e;
            if(!exists<Calc>(signer::address_of(owner))) {
                move_to<Calc>(owner,Calc{
                  operation: _operation ,
                  result: dif, 
                });
            }
            else{
                let subtraction = borrow_global_mut<Calc>(signer::address_of(owner));
                subtraction.operation = _operation;
                subtraction.result = dif;
            };

        };

        if(option == 3){
            let mul : u64 = d * e;
            if(!exists<Calc>(signer::address_of(owner))) {
                move_to<Calc>(owner,Calc{
                  operation: _operation ,
                  result: mul, 
                });
            }
            else{
                let multilication = borrow_global_mut<Calc>(signer::address_of(owner));
                multilication.operation = _operation;
                multilication.result = mul;
            };

        };

        if(option == 4){
            let rem : u64 = d / e;
            if(!exists<Calc>(signer::address_of(owner))) {
                move_to<Calc>(owner,Calc{
                  operation: _operation ,
                  result: rem, 
                });
            }
            else{
                let division = borrow_global_mut<Calc>(signer::address_of(owner));
                division.operation = _operation;
                division.result = rem;
            };

        };

    }

}