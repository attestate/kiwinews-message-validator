pragma solidity ^0.8.13;

struct Message {
  string title;
  string href;
  string _type;
  uint256 timestamp;
}

library KNMessageVerifier {
  struct EIP712Domain {
    string name;
    string version;
    bytes32 salt;
  }

  bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256(
    "EIP712Domain(string name,string version,bytes32 salt)"
  );

  bytes32 constant MESSAGE_TYPEHASH = keccak256(
    "Message(string title,string href,string type,uint256 timestamp)"
  );

  function hash(EIP712Domain memory eip712Domain) internal pure returns (bytes32) {
    return keccak256(abi.encode(
      EIP712DOMAIN_TYPEHASH,
      keccak256(bytes(eip712Domain.name)),
      keccak256(bytes(eip712Domain.version)),
      eip712Domain.salt
    ));
  }

  function hash(Message memory message) internal pure returns (bytes32) {
    return keccak256(abi.encode(
      MESSAGE_TYPEHASH,
      keccak256(bytes(message.title)),
      keccak256(bytes(message.href)),
      keccak256(bytes(message._type)),
      message.timestamp
    ));
  }

  function verify(Message memory message, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
    bytes32 DOMAIN_SEPARATOR = hash(EIP712Domain({
      name: "kiwinews",
      version: '1.0.0',
      salt: 0xfe7a9d68e99b6942bb3a36178b251da8bd061c20ed1e795207ae97183b590e5b
    }));
    bytes32 digest = keccak256(abi.encodePacked(
      "\x19\x01",
      DOMAIN_SEPARATOR,
      hash(message)
    ));
    return ecrecover(digest, v, r, s);
  }
}
