pragma solidity ^0.4.11;

contract edctoken_ico {

    // total number of tokens available for sale
    uint public max_tokens = 1000000;

    // USD to edctoken conversion rate
    uint public usd_to_edc = 1000;

    // number of edctoken that have been bought by the investors
    uint public total_edc_bought = 0;

    // mapping the investor address to its equity in edc and usd
    mapping(address => uint) equity_edc_map;
    mapping(address => uint) equity_usd_map;

    // checking if an investor can buy edc token
    modifier can_buy_edc(uint usd_invested) {
        require (usd_invested * usd_to_edc <= max_tokens - total_edc_bought);
        _;
    }

    // getting the equity in edc token of an investor
    function equity_in_edc(address investor) external constant returns (uint) {
        return equity_edc_map[investor];
    }

    // getting the equity in usd of an investor
    function equity_in_usd(address investor) external constant returns (uint) {
        return equity_usd_map[investor];
    }
    
    // buying edc token
    function buy_edc_token(address investor, uint usd_invested) external can_buy_edc(usd_invested) {
        uint edc_bought = usd_invested / usd_to_edc;
        equity_edc_map[investor] += edc_bought;
        equity_usd_map[investor] = equity_edc_map[investor] / usd_to_edc;
        total_edc_bought += edc_bought;
    }

    // sell edc token
    function sell_edc_token(address investor, uint edc_to_sell) external {
        equity_edc_map[investor] -= edc_to_sell;
        equity_usd_map[investor] = equity_edc_map[investor] / usd_to_edc;
        total_edc_bought -= edc_to_sell;
    }

}