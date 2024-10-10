program age_verification_platform.aleo;

// Import necessary Aleo libraries
import aleo/cryptography;
import aleo/identity;

// A record to represent a woman's anonymous identity
record Woman {
    public identity: field,
    private secret_key: field,
    private birthdate: field,  // Store birthdate securely
}

// A record to represent a financial opportunity
record FinancialOpportunity {
    public opportunity_id: field,
    public eligible_ids: map<field, bool>,  // Map to store eligible women's identities
}

// Function to register a new woman
function register_woman(private secret_key: field, private birthdate: field) -> Woman {
    // Create a public identity based on the secret key
    let identity = hash(secret_key);
    
    // Create the woman record
    let woman = Woman {
        identity,
        secret_key,
        birthdate,
    };
    
    // Return the registered woman
    return woman;
}

// Function to create a new financial opportunity
function create_opportunity(private secret_key: field) -> FinancialOpportunity {
    // Generate an opportunity ID
    let opportunity_id = hash(secret_key);
    
    // Initialize an empty map of eligible women's identities
    let eligible_ids = map();
    
    // Create the financial opportunity record
    let opportunity = FinancialOpportunity {
        opportunity_id,
        eligible_ids,
    };
    
    // Return the financial opportunity
    return opportunity;
}

// Function to extract year from birthdate
function extract_year(private birthdate: field) -> u32 {
    // Assuming birthdate is in "YYYY-MM-DD" format
    let year_str = substring(birthdate, 0, 4); // Get the first 4 characters
    return parse_u32(year_str); // Convert to u32
}

// Function to verify age and add a woman to a financial opportunity
function add_woman_to_opportunity(private secret_key: field, woman: Woman, opportunity: FinancialOpportunity, required_age: u32) -> FinancialOpportunity {
    // Calculate age 
    let current_year = 2024; // For example purposes
    let birth_year = extract_year(woman.birthdate); 
    let age = current_year - birth_year;

    // Check if the woman meets the age requirement
    if (age >= required_age) {
        // Hash the woman's secret key to create her identity
        let identity = hash(secret_key);
        
        // Add the woman to the opportunity
        map_insert(opportunity.eligible_ids, identity, true);
    }
    
    // Return the updated opportunity
    return opportunity;
}

// Function to check if a woman is eligible for a financial opportunity
function is_woman_eligible(private secret_key: field, opportunity: FinancialOpportunity) -> bool {
    // Hash the woman's secret key to create her identity
    let identity = hash(secret_key);
    
    // Check if the woman is in the eligible list
    let result = map_get(opportunity.eligible_ids, identity);
    
    // Return true if the woman is eligible, otherwise false
    return result;
}

// Optional: Test function
function test() {
    let secret_key = "my_secret_key_12345"; // Example secret key
    let birthdate = "2000-01-01"; // Example birthdate

    let woman = register_woman(secret_key, birthdate);
    let opportunity = create_opportunity(secret_key);
    let updated_opportunity = add_woman_to_opportunity(secret_key, woman, opportunity, 18);
    let is_eligible = is_woman_eligible(secret_key, updated_opportunity);

    print("Woman registered:", woman.identity);
    print("Opportunity created:", opportunity.opportunity_id);
    print("Is woman eligible:", is_eligible);
}
