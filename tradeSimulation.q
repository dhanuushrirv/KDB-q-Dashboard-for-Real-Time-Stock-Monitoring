//Load the tradeData
\l /tradeData.q

// Initialize variables for the simulation
initial_cash: 1000f;  // Starting cash balance
cash: initial_cash;      // Current cash balance
position: 0;            // Current position (number of shares held)

// Create an empty table to log the trades and P&L calculations
pnl_log: flip `Time`Symbol`Action`Quantity`Price`Cash`Position!()  // Empty log table


simulateTrades : {

	stock_data : x;  //Historical stock data passed to the function
	
	
	// Iterate over each row in stock_data
    	{
        	
        	if[x[`buy_sell] = `buy;{
           		total_cost: x[`Price] * x[`Quantity];  // Calculate total cost of buying the shares
            		if[cash >= total_cost;  // Ensure enough cash is available to buy
                		cash:: cash - total_cost;  // Deduct the cost from cash
                		position:: position + x[`Quantity];  // Add shares to position
                		pnl_log:: pnl_log, flip (`Time`Symbol`Action`Quantity`Price`Cash`Position!((x[`Time]; x[`Symbol]; `buy; x[`Quantity]; x[`Price]; cash; position)));
            		];
        	}]; 
		if[x[`buy_sell] = `sell; {
            		total_sale: x[`Price] * x[`Quantity];  // Calculate total sale amount
            		if[position >= x[`Quantity];  // Ensure enough position to sell
                		cash:: cash + total_sale;  // Add sale amount to cash (global update)
                		position:: position - x[`Quantity];  // Reduce position (global update)
                		pnl_log:: pnl_log, flip (`Time`Symbol`Action`Quantity`Price`Cash`Position!((x[`Time]; x[`Symbol]; `sell; x[`Quantity]; x[`Price]; cash; position)));
            		];
        	}];
    } each stock_data; 

// Final P&L calculation
    last_price: last stock_data[`Price];  // Get the last price from stock data
    final_value: cash + ("f"$position * last_price);  // Value of remaining cash and current position
    final_pnl: final_value - initial_cash;  // Profit and Loss
    show final_pnl;  // Display final P&L

    pnl_log }; 

//run the simulation
pnl_log : simulateTrades stock_data ;

show pnl_log
