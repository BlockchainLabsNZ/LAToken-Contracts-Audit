pragma solidity ^0.4.15;

import "./base-token/LATToken.sol";

contract ExchangeContract {
using SafeMath for uint256;

	address public founder;
	uint256 public prevCourse;
	uint256 public nextCourse;

	address public prevTokenAddress;
	address public nextTokenAddress;

	LATToken public prevToken;
	LATToken public nextToken;

	modifier onlyFounder() {
        if (msg.sender != founder) {
            revert();
        }
        _;
    }

    modifier onlyPreviousToken() {
    	if (msg.sender != prevTokenAddress) {
            revert();
        }
        _;
    }

	function changeCourse(uint256 _prevCourse, uint256 _nextCourse)
		public
		onlyFounder
	{
		prevCourse = _prevCourse;
		nextCourse = _nextCourse;
	}

	function exchange(address _for, uint256 prevTokensAmount)
		public
		onlyPreviousToken
		returns (bool)
	{
		// проверить на отсылаемого
		if (prevToken.balanceOf(_for) >= prevTokensAmount) {
			uint256 amount = div(prevTokensAmount, prevCourse);

			assert(prevToken.burnTokens(_for, mul(amount, prevCourse)));
			assert(nextToken.issueTokens(_for, mul(amount, nextCourse)));

			return true;
		} else {
			revert();
		}
	}

	function ExchangeContract(address _prevTokenAddress, address _nextTokenAddress, uint256 _prevCourse, uint256 _nextCourse) {
		founder = msg.sender;

		prevTokenAddress = _prevTokenAddress;
		nextTokenAddress = _nextTokenAddress;

		prevToken = LATToken(_prevTokenAddress);
		nextToken = LATToken(_nextTokenAddress);

		prevCourse = _prevCourse;
		nextCourse = _nextCourse;
	}
}
