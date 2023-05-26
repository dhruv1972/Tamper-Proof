pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventLog is Ownable {
    using ECDSA for bytes32;
    
    struct Event {
        uint256 timestamp;
        string data;
        address recorder;
        bytes signature;
    }

    mapping(uint256 => Event) public eventLog;
    uint256 public eventCount;
    mapping(address => bool) private _isAdmin;

    event NewEvent(uint256 indexed eventId, string data, address indexed recorder);
    event EventVerified(uint256 indexed eventId, address verifier, bool isVerified);

    modifier isAdmin() {
        require(_isAdmin[msg.sender], "Not an admin");
        _;
    }

    constructor() {
        _isAdmin[msg.sender] = true;
    }

    function addAdmin(address admin) public onlyOwner {
        _isAdmin[admin] = true;
    }

    function removeAdmin(address admin) public onlyOwner {
        _isAdmin[admin] = false;
    }

    function recordEvent(string calldata data, bytes calldata signature) public {
        bytes32 hash = keccak256(abi.encodePacked(msg.sender, data));
        address signer = hash.toEthSignedMessageHash().recover(signature);

        require(signer == msg.sender, "Invalid signature");

        eventLog[eventCount] = Event(block.timestamp, data, msg.sender, signature);

        emit NewEvent(eventCount, data, msg.sender);

        eventCount++;
    }

    function verifyEvent(uint256 eventId, bytes calldata signature) public view returns (bool) {
        Event memory event = eventLog[eventId];
        
        bytes32 hash = keccak256(abi.encodePacked(event.recorder, event.data));
        address signer = hash.toEthSignedMessageHash().recover(signature);

        bool isVerified = signer == event.recorder && keccak256(abi.encodePacked(signature)) == keccak256(abi.encodePacked(event.signature));
        
        emit EventVerified(eventId, msg.sender, isVerified);

        return isVerified;
    }

    function getEvent(uint256 eventId) public view returns (uint256, string memory, address, bytes memory) {
        Event memory event = eventLog[eventId];
        return (event.timestamp, event.data, event.recorder, event.signature);
    }

    function getEventsByRecorder(address recorder) public view returns (uint256[] memory, string[] memory, bytes[] memory) {
        uint256[] memory timestamps = new uint256[](eventCount);
        string[] memory datas = new string[](eventCount);
        bytes[] memory signatures = new bytes[](eventCount);

        for (uint256 i = 0; i < eventCount; i++) {
            if (eventLog[i].recorder == recorder) {
                timestamps[i] = eventLog[i].timestamp;
                datas[i] = eventLog[i].data;
                signatures[i] = eventLog[i].signature;
            }
        }

        return (timestamps, datas, signatures);
    }
}
