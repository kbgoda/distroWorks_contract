pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;
contract jobTrust {
    
    struct Person{
        string name;
        string[] reviews;
        uint index; // This is to keep adding reviews at the end
        bool indexIsNotNull;
    }
    // Reviewed hashmap is possible to track what persons reviewed whom
    // We will not do it in this implementation
    
    mapping(address => uint) balances;
    mapping(address => mapping (address => uint)) allowed;
    mapping(address => Person) persons;
    
    uint totalSupply;
    event Transfer(address sender, address reciever, uint tokenAmount);
    event Approval(address sender, address delegate, uint numTokens);
    
    constructor(uint total) public {
        totalSupply = total;
        balances[msg.sender] = totalSupply;
    }
    // A constructor is a special function automatically 
    // called by Ethereum right after the contract is deployed. 
    // It is typically used to initialize the token’s 
    // state using parameters passed by the contract’s deploying account.

    function totalSupplyOfCoin() public view returns (uint) {
        return totalSupply;
    }
    
    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }
    
    function transfer(address receiver, uint numTokens) public returns (bool) {
        // Require means that balance of sender has to less than toSend amount for it to work
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - numTokens;
        balances[receiver] = balances[receiver] + numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }
    
    /* 
    What approve does is to allow an owner i.e. msg.sender 
    to approve a delegate account, possibly the marketplace 
    itself to withdraw tokens from his account 
    and to transfer them to other accounts.
    */
    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }
    
    // This function returns the current approved number 
    // of tokens by an owner to a specific delegate, 
    // as set in the approve function.
    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }
    
    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] = balances[owner] - numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender] - numTokens;
        balances[buyer] = balances[buyer] + numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
    
    // Initialize a default person's values
    function initializeIfNeeded(string memory _name, address personAddress) view internal returns (Person memory) {
        Person memory person = persons[personAddress];
        
        person.name = _name; 
        if (person.indexIsNotNull == true) {
            person.index = 0;
            person.indexIsNotNull = false;
        }
        
        return person;
    }

    // Owner of address reviews a using b as the other party to review a
    function reviewPerson(address owner, address b, address a, string memory review, string memory ownerName, string memory bName, string memory aName) public {
        // Sets the names of the parties
        persons[owner] = initializeIfNeeded(ownerName, owner);
        persons[b] = initializeIfNeeded(bName, b);
        persons[a] = initializeIfNeeded(aName, a);
        // All the 3 addresses should be different
        require(owner != b && owner != a && b != a);
        owner = msg.sender;
        // Retrieve "a" from persons and add their review
        persons[a].reviews[persons[a].index] = review;
        // Update index to next one
        persons[a].index+=1;
    }
    
    // See all the reviews of the person
    function seeReviews(address owner) public view returns(string[]memory){
        // Return reviews belonging to owner
        string[] memory reviewsToRet;
        for(uint i = 0; i < persons[owner].reviews.length; i++){
            reviewsToRet[i] = persons[owner].reviews[i];
        }
        return (reviewsToRet);
    }
    
    
}