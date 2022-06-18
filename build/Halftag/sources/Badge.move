
module Halftag::Badge {
    use std::option::{Self, Option};
    use std::vector;
    use std::signer;
    use std::guid;

    const EID_NOT_FOUND: u64 = 1;
    const EPENDING_BADGES_EXISTS: u64 = 2;

    struct Badge<T: store + drop> has drop, key, store {
        id: guid::ID,
        type: T,
        name: vector<u8>,
        // holder: address,
        issuer: address,
        meta_data: vector<u8>,
        // amount: u64,
        // accepted: bool,
    }    

    // collection of badges confirmed
    struct BadgeCollection<T: store + drop> has key {
        badge_list: vector<Badge<T>>,
    }    

    struct PendingBadges<T: store + drop> has key {
        pending_list: vector<Badge<T>>,
    }  

    // register all badge issued
    struct BadgeIssueEvent has copy, drop, store {
        event_id: guid::ID,
        to: address,   
    }    

    public fun initialize<T: store + drop>(
        account: &signer
    ) {
        if (!exists<BadgeCollection<T>>(signer::address_of(account))) {
            move_to(account, BadgeCollection { badge_list: vector::empty<Badge<T>>() });
            move_to(account, PendingBadges { pending_list: vector::empty<Badge<T>>() });
        };
    }

    public fun badge_issuance<T: store + drop>(
        issuer: &signer, to: address, type: T, name: vector<u8>, meta_data: vector<u8>
    ) acquires PendingBadges {
        // if (!exists<PendingBadges<T>>(to)) {
        //     move_to(to, PendingBadges { pending_list: vector::empty<Badge<T>>() });
        // };
        assert!(exists<PendingBadges<T>>(to), EPENDING_BADGES_EXISTS);
        
        let addr = signer::address_of(issuer);
        let creation_num = guid::get_next_creation_num(addr);
        let token_id = guid::create_id(addr, creation_num);
        let badge = Badge { id: token_id, type, name, issuer: addr, meta_data };
        let pending_list = &mut borrow_global_mut<PendingBadges<T>>(to).pending_list;
        vector::push_back(pending_list, badge);
    }

    public fun badge_confirm<T: copy + store + drop>(
        account: &signer, badge: Badge<T>
    ) acquires BadgeCollection, PendingBadges {
        assert!(!has_badge<T>(signer::address_of(account), &badge.id), EID_NOT_FOUND);

        let pending_list = &mut borrow_global_mut<PendingBadges<T>>(signer::address_of(account)).pending_list;
        let badge_collection = &mut borrow_global_mut<BadgeCollection<T>>(signer::address_of(account)).badge_list;
        
        let index_opt = index_of_badge<T>(pending_list, &badge.id);
        assert!(option::is_some(&index_opt), EID_NOT_FOUND);
        let from_token_idx = option::extract(&mut index_opt);
        let b = vector::remove(pending_list, from_token_idx);  
        vector::push_back(badge_collection, b);
    }

    public fun has_badge<T: copy + store + drop>(
        owner: address, badge_id: &guid::ID
    ): bool acquires PendingBadges {
        option::is_some(&index_of_badge(&borrow_global<PendingBadges<T>>(owner).pending_list, badge_id))
    }

    fun index_of_badge<T: copy + store + drop>(
        pending_list: &vector<Badge<T>>, id: &guid::ID
    ): Option<u64> {
        let i = 0;
        let len = vector::length(pending_list);
        while (i < len) {
            if (get_badge_id<T>(vector::borrow(pending_list, i)) == *id) {
                return option::some(i)
            };
            i = i + 1;
        };
        option::none()
    }

    public fun get_badge_id<T: copy + store + drop>(badge: &Badge<T>): std::guid::ID {
        *&badge.id
    }

    // public fun badge_recall(
    //     lr_account: &signer,
    // ) {

    // }  

    // public fun get_issuer(
    //     account: &signer,
    // ) {

    // }  

    // public fun get_badge_amount(
    //     account: &signer,
    // ) {

    // }  
}        


#[test_only]
module 0x1::BadgeTests {
    use std::guid;
    use 0x1::NFT;
    use 0x1::NFTGallery;
    use std::option;
}    