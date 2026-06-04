  struct TweetDetails{
    uint id;
    address author;
    string content;
    uint creationTimestamp;
    }
    
    struct Message{
    uint id;
    string content;
    address sender;
    address receiver;
    uint timestamp;
    }
    
    mapping(uint => TweetDetails) public tweets;
    mapping(address =>uint[]) public tweetsof;
    mapping(address=>mapping(address => Message[])) public conversation;
    mapping(address => mapping(address => bool)) public operators;
    mapping(address => address[]) public following;
