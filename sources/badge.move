
module Halftag::Badge {
    use std::option::{Self, Option, some};
    use std::vector::length;
    use Std::Event;
    use std::errors;
    use std::signer;
    use std::GUID::GUID;
    // use 0x1::Vector;
    // use 0x1::Signer;
    // use 0x1::Errors;

    // const MAX_TEXT_LENGTH: u64 = 512;
    // const ETextOverflow: u64 = 0;

    struct Badge<T: store + drop> has key, store {
        id: GUID::ID,
        type: T,
        name: vector<u8>,
        // holder: address,
        issuer: address,
        meta_data: vector<u8>,
        // amount: u64,
        // accepted: bool,
    }    

    // collection of badges confirmed
    struct BadgeCollection<T: store + drop> has store {
        badge_list: vector<Badge<T>>,
    }    

    // register all badge issued
    struct BadgeIssueEvent has copy, drop, store {
        id: GUID::ID,
        to: address,   
    }    

    struct PendingBadges<T: store + drop> has store {
        pending_list: vector<Badge<T>>,
    }    

    public fun initialize<T: store + drop>(
        account: &signer
    ) acquires BadgeCollection, PendingBadges {
        if (!exists<BadgeCollection<T>>(Signer::address_of(account))) {
            move_to(account, BadgeCollection { badge_list: Vector::empty<Badge<T>>() });
            move_to(account, PendingBadges { pending_list: Vector::empty<Badge<T>>() });
        };
    }

    public fun badge_issuance<T: store + drop>(
        issuer: &signer, type: T, name: vector<u8>, meta_data: vector<u8>
    ): Badge<T> acquires PendingBadges {
        let token_id = GUID::create(issuer);
        Badge { id: token_id, type, name, Signer::address_of(issuer), meta_data }
        // move to acceptance account's pendingbadges collection
        move_to(account, PendingBadges { pending_list: Vector::empty<Badge<T>>() });

    }

    public fun badge_confirm<T: store + drop>(
        account: address, badge: Badge<T>
    ) acquires BadgeCollection, PendingBadges {
        // assert!(Signer::address_of(&account) == ADMIN, ENOT_ADMIN);

        // assert!(exists<BadgeCollection<T>>(account), Errors::not_published(ENFT_COLLECTION_NOT_PUBLISHED));
        assert!(!has_badge<T>(account, &badge.id), Errors::not_in_pendinglist(EID_EXISTS));

        let pending_list = &mut borrow_global_mut<PendingBadges<T>>(account).pending_list;
        let badge_collection = &mut borrow_global_mut<BadgeCollection<T>>(account).badge_list;

        Vector::pop_back(pending_list, badge);        
        Vector::push_back(badge_collection, badge);
    }

    public fun has_badge<T: copy + store + drop>(
        owner: address, badge_id: &GUID::ID
    ): bool acquires PendingBadges {
        Option::is_some(&index_of_badge(&borrow_global<PendingBadges<T>>(owner).pending_list, badge_id))
    }

    fun index_of_badge<T: copy + store + drop>(
        pending_list: &vector<Badge<T>>, id: &GUID::ID
    ): Option<u64> {
        let i = 0;
        let len = Vector::length(pending_list);
        while (i < len) {
            if (get_badge_id<T>(Vector::borrow(pending_list, i)) == *id) {
                return Option::some(i)
            };
            i = i + 1;
        };
        Option::none()
    }

    public fun get_badge_id<T: copy + store + drop>(badge: &Badge<T>): GUID::ID {
        *&badge.id
    }

    // public fun badge_recall(
    //     lr_account: &signer,
    // ) {

    // }  

    public fun get_issuer(
        lr_account: &signer,
    ) {

    }  

    public fun get_badge_amount(
        lr_account: &signer,
    ) {

    }  
}        


#[test_only]
module 0x1::NFTTests {
    use Std::GUID;
    use 0x1::NFT;
    use 0x1::NFTGallery;
    use Std::Option;