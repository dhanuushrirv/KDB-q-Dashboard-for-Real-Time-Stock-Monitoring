// load data
// Number of rows to generate
n:1000


// Generate random time between 9:15 AM and 3:30 PM - trading time
start_time: 09:15:00t
end_time: 15:30:00t
rand_time: start_time + (n?((end_time - start_time) * 1j))

// Symbols for stocks
symbols: `APPL`MSFT`GOOGL`TSLA`META`NFLX`BABA`V

// Bid, Ask, and Price generation (random between 20 and 300)
rand_price: {0.01 * floor 100 * (20 + 280 * n?1f)}  // Helper function to generate random prices

// Quantities between 1 and 15
quantities: 1 + n?15

// Statuses for the stocks
statuses: `Accepted`Done`Customer_Timeout`Dealer_Timeout`Customer_Rejected`Dealer_Rejected`Partially_Done`Expired`Cancelled`Pending_Approval`In_Progress`On_hold

// Currencies
currencies: `EUR`USD`GBP`JPY`INR

// Buy/Sell symbols
buy_sell: `b`s

// Create the table with random data
stock_data: ([] 
    Time: rand_time;
    Symbol: n?symbols; 
    Bid: rand_price[];
    Ask: rand_price[];
    Price: rand_price[];
    Quantity: quantities;
    Status: n?statuses;
    Currency: n?currencies;
    buy_sell: n?buy_sell)

// Display the generated data
// stock_data


//create a new column that updates the quantity and price as TotalPrice
stock_data : update TotalPrice : Quantity * Price from stock_data; 

//Order the stock_data table by time
stock_data: `Time xasc stock_data

//Now add the additional code to build the dashboard or to perform calculation of your choice
//Statistical arbitrage



