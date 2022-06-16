
module Halftag::Badge {
    use std::option::{Self, Option, some};
    use std::vector::length;
    use std::errors;
    use std::signer;
    use std::GUID::GUID;
    use 0x1::Vector;
    use 0x1::Signer;
    use 0x1::Errors;

    // const MAX_TEXT_LENGTH: u64 = 512;
    const ETextOverflow: u64 = 0;

    struct Badge<T: store + drop> has key, store {
        id: GUID,
        type: T,
        name: vector<u8>,
        // holder: address,
        issuer: address,
        meta_data: vector<u8>,
        // amount: u64,
        accepted: bool,
    }    

    struct BadgeCollection<T: store + drop> has key {
        badge_list: vector<Badge<T>>,
    }    

    struct BadgeIssued has key, store {
        badge_list: vector<Badge>,
    }    

    struct PendingBadges has key, store {
        pending_list: vector<Badge>,
    }    

    public fun initialize<T: store + drop>(account: &signer) {
        if (!exists<BadgeCollection<T>>(Signer::address_of(account))) {
            move_to(account, BadgeCollection { badge_list: Vector::empty<Badge<T>>() });
        };
    }

    public fun badge_issuance<T: store + drop>(
        issuer: &signer, type: T, name: vector<u8>, meta_data: vector<u8>
    ): Badge<T> {
        let token_id = GUID::create(issuer);
        Badge { id: token_id, type, name, Signer::address_of(issuer), meta_data, accepted: false }
        // move to acceptance account's pendingbadges collection
    }


    public fun badge_acceptance<T: store + drop>(account: address, badge: Badge<T>) acquires BadgeCollection {
                    assert!(Signer::address_of(&account) == ADMIN, ENOT_ADMIN);

        assert!(exists<BadgeCollection<T>>(account), Errors::not_published(ENFT_COLLECTION_NOT_PUBLISHED));
        assert!(!has_token<T>(account, &GUID::id(&nft.id)), Errors::already_published(EID_EXISTS));
        let nft_collection = &mut borrow_global_mut<BadgeCollection<T>>(account).nfts;
        Vector::push_back(
            nft_collection,
            nft,
        );
    }
    
    public fun badge_acceptance(
        lr_account: &signer,
    ) {

    }  

    public fun badge_recall(
        lr_account: &signer,
    ) {

    }  

    public fun get_issuer(
        lr_account: &signer,
    ) {

    }  

    public fun get_badge_amount(
        lr_account: &signer,
    ) {

    }  
}        