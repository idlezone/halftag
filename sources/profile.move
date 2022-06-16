
module Halftag::Badge {
    use std::option::{Self, Option, some};
    use std::vector::length;
    use std::errors;
    use 0x1::Vector;
    use 0x1::Signer;
    use 0x1::Errors;

    // const MAX_TEXT_LENGTH: u64 = 512;
    // const ETextOverflow: u64 = 0;

    struct AccountTags has key, store {
        id: VersionedID,
    }    

    struct Avatar has key, store {
        id: VersionedID,
    }

    public fun name_initialize(
        lr_account: &signer,
    ) {

    }  
    
    public fun name_update(
        lr_account: &signer,
    ) {

    }  

    public fun avatar_initialize(
        lr_account: &signer,
    ) {

    }    

    public fun avatar_update(
        lr_account: &signer,
    ) {
    }    
}        