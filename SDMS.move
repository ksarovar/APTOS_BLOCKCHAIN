module document_management::document_management {
    use std::string::{Self, String};
    use std::vector;
    use std::signer;
    use aptos_framework::account;
    use aptos_framework::timestamp;
    use aptos_std::table::{Self, Table};
    
    // Error codes
    const ENO_PERMISSIONS: u64 = 1;
    const EDOCUMENT_NOT_FOUND: u64 = 2;
    const EALREADY_VERIFIED: u64 = 3;
    const ENOT_VERIFIED: u64 = 4;
    const ENOT_DOCUMENT_OWNER: u64 = 5;

    // Roles
    const ADMIN_ROLE: vector<u8> = b"ADMIN";
    const VERIFIER_ROLE: vector<u8> = b"VERIFIER";
    const STUDENT_ROLE: vector<u8> = b"STUDENT";

    struct DocumentManagement has key {
        students: Table<address, Student>,
        documents: Table<u64, Document>,
        document_access: Table<u64, Table<address, bool>>,
        verifiers: Table<address, String>, // address to name mapping
        admins: Table<address, String>, // address to name mapping
        document_counter: u64,
        owner: address,
    }
struct Document has store, copy {
    id: u64,
    document_type: String,
    document_hash: String,
    metadata: String,
    timestamp: u64,
    added_by: address,
    is_verified: bool,
    verified_by: vector<address>,
    verified_at: u64,
    student_id_number: String,
}

struct Student has store, drop, copy {
    name: String,
    year: u8, // 0=FE, 1=SE, 2=TE, 3=BE
    branch: u8, // 0=Mechanical, 1=Civil, 2=CS, 3=Mechatronics
    id_number: String,
}

    public entry fun initialize(account: &signer) {
        let sender = signer::address_of(account);
        
        let document_management = DocumentManagement {
            students: table::new(),
            documents: table::new(),
            document_access: table::new(),
            verifiers: table::new(),
            admins: table::new(),
            document_counter: 0,
            owner: sender,
        };
        
        table::add(&mut document_management.admins, sender, string::utf8(b"Owner"));
        move_to(account, document_management);
    }

    public entry fun add_admin(
        account: &signer,
        new_admin: address,
        name: String,
    ) acquires DocumentManagement {
        let sender = signer::address_of(account);
        let document_management = borrow_global_mut<DocumentManagement>(@document_management);
        assert!(sender == document_management.owner, ENO_PERMISSIONS);
        
        if (!table::contains(&document_management.admins, new_admin)) {
            table::add(&mut document_management.admins, new_admin, name);
        };
    }

    public entry fun add_student(
        account: &signer,
        student_address: address,
        name: String,
        year: u8,
        branch: u8,
        id_number: String,
    ) acquires DocumentManagement {
        let sender = signer::address_of(account);
        let document_management = borrow_global_mut<DocumentManagement>(@document_management);
        assert!(table::contains(&document_management.admins, sender), ENO_PERMISSIONS);
        
        let student = Student {
            name,
            year,
            branch,
            id_number,
        };
        
        table::add(&mut document_management.students, student_address, student);
    }

    public entry fun add_document(
        account: &signer,
        document_type: String,
        document_hash: String,
        metadata: String,
        student_id_number: String,
    ) acquires DocumentManagement {
        let sender = signer::address_of(account);
        let document_management = borrow_global_mut<DocumentManagement>(@document_management);
        assert!(table::contains(&document_management.students, sender), ENO_PERMISSIONS);
        
        let document = Document {
            id: document_management.document_counter + 1,
            document_type,
            document_hash,
            metadata,
            timestamp: timestamp::now_microseconds(),
            added_by: sender,
            is_verified: false,
            verified_by: vector::empty(),
            verified_at: 0,
            student_id_number,
        };
        
        table::add(&mut document_management.documents, document_management.document_counter + 1, document);
        document_management.document_counter = document_management.document_counter + 1;
    }

    public entry fun verify_document(
        account: &signer,
        document_id: u64,
    ) acquires DocumentManagement {
        let sender = signer::address_of(account);
        let document_management = borrow_global_mut<DocumentManagement>(@document_management);
        
        assert!(table::contains(&document_management.verifiers, sender), ENO_PERMISSIONS);
        assert!(table::contains(&document_management.documents, document_id), EDOCUMENT_NOT_FOUND);
        
        let document = table::borrow_mut(&mut document_management.documents, document_id);
        assert!(!document.is_verified, EALREADY_VERIFIED);
        
        document.is_verified = true;
        document.verified_at = timestamp::now_microseconds();
        vector::push_back(&mut document.verified_by, sender);
    }

    public entry fun grant_access(
        account: &signer,
        document_id: u64,
        to: address,
    ) acquires DocumentManagement {
        let sender = signer::address_of(account);
        let document_management = borrow_global_mut<DocumentManagement>(@document_management);
        
        assert!(table::contains(&document_management.documents, document_id), EDOCUMENT_NOT_FOUND);
        let document = table::borrow(&document_management.documents, document_id);
        assert!(document.added_by == sender, ENOT_DOCUMENT_OWNER);
        
        if (!table::contains(&document_management.document_access, document_id)) {
            table::add(&mut document_management.document_access, document_id, table::new());
        };
        
        let access_table = table::borrow_mut(&mut document_management.document_access, document_id);
        table::add(access_table, to, true);
    }

    #[view]
    public fun get_document(document_id: u64): Document acquires DocumentManagement {
        let document_management = borrow_global<DocumentManagement>(@document_management);
        assert!(table::contains(&document_management.documents, document_id), EDOCUMENT_NOT_FOUND);
        *table::borrow(&document_management.documents, document_id)
    }

    #[view]
    public fun get_student(student_address: address): Student acquires DocumentManagement {
        let document_management = borrow_global<DocumentManagement>(@document_management);
        *table::borrow(&document_management.students, student_address)
    }

    #[view]
    public fun has_access(document_id: u64, user: address): bool acquires DocumentManagement {
        let document_management = borrow_global<DocumentManagement>(@document_management);
        if (!table::contains(&document_management.document_access, document_id)) {
            return false
        };
        let access_table = table::borrow(&document_management.document_access, document_id);
        table::contains(access_table, user)
    }
}
