
module Halftag::Badge {
    use std::option::Option;
    use std::vector;
    use std::signer;
    use std::GUID;

    const EID_EXISTS: u8 = 1;

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

    struct PendingBadges<T: store + drop> has store {
        pending_list: vector<Badge<T>>,
    }  

    // register all badge issued
    struct BadgeIssueEvent has copy, drop, store {
        event_id: GUID::ID,
        to: address,   
    }    

    public fun initialize<T: store + drop>(
        account: &signer
    ) acquires BadgeCollection, PendingBadges {
        if (!exists<BadgeCollection<T>>(Signer::address_of(account))) {
            move_to(account, BadgeCollection { badge_list: Vector::empty<Badge<T>>() });
            // move_to(account, PendingBadges { pending_list: Vector::empty<Badge<T>>() });
        };
    }

    public fun badge_issuance<T: store + drop>(
        issuer: &signer, to: address, type: T, name: vector<u8>, meta_data: vector<u8>
    ): Badge<T> acquires PendingBadges {
        if (!exists<PendingBadges<T>>(to)) {
            move_to(to, PendingBadges { pending_list: Vector::empty<Badge<T>>() });
        };
        let token_id = GUID::create(issuer);
        let badge = Badge { id: token_id, type, name, Signer::address_of(issuer), meta_data };
        let pending_list = &mut borrow_global_mut<PendingBadges<T>>(to).pending_list;
        Vector::push_back(pending_list, badge);
    }

    public fun badge_confirm<T: store + drop>(
        account: &signer, badge: Badge<T>
    ) acquires BadgeCollection, PendingBadges {
        // assert!(Signer::address_of(&account) == ADMIN, ENOT_ADMIN);
        // assert!(exists<BadgeCollection<T>>(account), Errors::not_published(ENFT_COLLECTION_NOT_PUBLISHED));
        assert!(!has_badge<T>(Signer::address_of(account), &badge.id), EID_EXISTS);

        let pending_list = &mut borrow_global_mut<PendingBadges<T>>(Signer::address_of(account)).pending_list;
        let badge_collection = &mut borrow_global_mut<BadgeCollection<T>>(Signer::address_of(account)).badge_list;

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
        account: &signer,
    ) {

    }  

    public fun get_badge_amount(
        account: &signer,
    ) {

    }  
}        


#[test_only]
module 0x1::BadgeTests {
    use Std::GUID;
    use 0x1::NFT;
    use 0x1::NFTGallery;
    use Std::Option;
}    