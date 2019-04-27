pragma solidity >=0.4.22 <0.6.0;
// pragma experimental ABIEncoderV2;
contract jobTrust {
     
    struct Person{
        string name;
        string[5] reviews;
        uint index; // This is to keep adding reviews at the end
        bool indexIsNotNull;
        uint reviewIndex;
        string position;
    }
    // Reviewed hashmap is possible to track what persons reviewed whom
    // We will not do it in this implementation
    
    mapping(address => uint) balances;
    mapping(address => mapping (address => uint)) allowed;
    mapping(string => uint) nameToId;
    mapping(uint => string) personIds;
    Person[10] persons; // uint is id of person. unique to each person
    uint totalPersons = 0;
    
    uint totalSupply;
    event Transfer(address sender, address reciever, uint tokenAmount);
    event Approval(address sender, address delegate, uint numTokens);
    event Reviewed(string name, string message);
    
    constructor(uint total) public {
        totalSupply = total;
        balances[msg.sender] = totalSupply; // Total supply is given to contract creator
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
    
    // Initialize a default person's values
    // Gets the person if exists
    function initializeIfNeeded(string memory _name) internal returns (Person memory){
        
        Person memory newP;
        uint getId = nameToId[_name];
        if(getId == 0) {
            newP.name = _name;
            newP.index = totalPersons+1;
            personIds[totalPersons+1] = _name;
            newP.reviewIndex = 0;
            // Persons are stored from first index
            persons[totalPersons+1] = newP;
            totalPersons++;
        } else {
            newP = persons[nameToId[_name]];
        }
        return newP;
    }

    // a reviews b
    function reviewPerson(string memory review, string memory aName, string memory bName) public {
        // , string memory aName, string memory bName,
        // Sets the names of the parties or obtain the persons
        // Person memory a = initializeIfNeeded(aName);
        Person memory b;
        // Person memory newP;
        uint getId = nameToId[cName];
        if(getId == 0) {
            c.name = cName;
            c.index = totalPersons+1;
            personIds[totalPersons+1] = cName;
            c.reviewIndex = 0;
            // Persons are stored from first index
            persons[totalPersons+1] = c;
            totalPersons++;
        } else {
            c = persons[nameToId[cName]];
        }
        
        // Person memory b = initializeIfNeeded(bName);
        // Person memory c = initializeIfNeeded(cName);
        
        // All the 3 addresses should be different
        // require(a.index != b.index && c.index != a.index && b.index != c.index);
        // Retrieve "a" from persons and add their review and update review Index
        persons[c.index].reviews[c.reviewIndex] = review;
        persons[c.index].reviewIndex++;
        emit Reviewed(cName, review);
        
    }
    
    // See a review of the person with id >= 0
    // , uint reviewId
    function seeReview(uint personId, uint reviewId) public view returns (string memory){
        // Return reviews belonging to owner
        // string[] memory reviewsToRet;
        // for(uint i = 0; i < persons[personId].reviews.length; i++){
        require(personId >= 0);
            // reviewsToRet[i] = persons[personId].reviews[i];
        // }
        // return reviewsToRet;
        return persons[personId].reviews[reviewId];
    }
    
    
}