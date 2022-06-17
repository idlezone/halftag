
module Halftag::Profile {
    use std::option::{Self, Option, some};
    use std::vector::length;
    use std::errors;


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