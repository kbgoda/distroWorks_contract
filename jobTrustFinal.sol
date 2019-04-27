pragma solidity >=0.4.22 <0.6.0;
// pragma experimental ABIEncoderV2;
contract jobTrust {
     
    struct Person{
        string name;
        string[5] reviews; // Index 0 to 4
        uint reviewIndex;
        //uint index; // This is to keep adding reviews at the end
        string position;
    }
    // Reviewed hashmap is possible to track what persons reviewed whom
    // We will not do it in this implementation
    
    mapping(address => uint) balances;
    mapping(address => mapping (address => uint)) allowed;
    mapping(string => uint) nameToId; // Returns id
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
    // function initializeIfNeeded(string memory _name) internal returns (Person memory){
        
    //     Person memory newP;
    //     uint getId = nameToId[_name];
    //     if(getId == 0) {
    //         newP.name = _name;
    //         newP.index = totalPersons+1;
    //         personIds[totalPersons+1] = _name;
    //         newP.reviewIndex = 0;
    //         // Persons are stored from first index
    //         persons[totalPersons+1] = newP;
    //         totalPersons++;
    //     } else {
    //         newP = persons[nameToId[_name]];
    //     }
    //     return newP;
    // }
    
    // a reviews b
    function reviewPerson(string memory review, string memory aName, string memory bName) public {
        
        require(keccak256(abi.encodePacked(aName)) != keccak256(abi.encodePacked(bName)));
        // Get this person from the persons array
        uint getId = nameToId[bName]; // If name not found, solidity gives this 0 value 
        //keccak256(abi.encodePacked(persons[getId].name)) != keccak256(abi.encodePacked(bName))
        if(getId == 0) { // Person does not exist
            totalPersons++; // This is our indexes for people
            // This is permanent storing
            persons[totalPersons].name = bName;
            personIds[totalPersons] = bName; // index -> name
            persons[getId].reviewIndex = 0;
            nameToId[bName] = totalPersons; // Stores index of person to nameToId
        }
        
        // Adds review and updates index to next to add more reviews
        persons[nameToId[bName]].reviews[persons[getId].reviewIndex] = review;
        persons[nameToId[bName]].reviewIndex++;
        
        emit Reviewed(bName, review);
        
    }
    
    // See a review of the person with id >= 0
    // , uint reviewId
    function seeReview(string memory personName, uint reviewId) public view returns (uint256, string memory){
        require(reviewId >= 0 && reviewId <= 4); // Since their index starts from 0
        uint getId = nameToId[personName];
        
        // Returns person id and their associated review
        return (getId, persons[getId].reviews[reviewId]);
    }
    
    
}