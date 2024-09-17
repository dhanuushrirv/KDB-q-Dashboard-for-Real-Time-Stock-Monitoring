//load the trade data and perform statistical arbitrage calculation

\l /Users/dhanuushri/q/script/KDB-q-Dashboard-for-Real-Time-Stock-Monitoring/KDB-q-Dashboard-for-Real-Time-Stock-Monitoring/tradeData.q

//Statistical arbitrage
//  -> (pair trading strategies) using the stock_data table, the idea is to identify pairs of correlated symbols and then trade based on their spread. 
// Get unique symbols
symbols: distinct stock_data[`Symbol];

// Generate all pairs of symbols
pairs: distinct cross[symbols; symbols];

//give column name to the pairs table
pairs: ([] Symbol1: first each pairs; Symbol2: last each pairs);
pairs : select from pairs where Symbol1 <> Symbol2;

spreadCalc: {
    sym1: first x ;  // First symbol in the pair
    sym2: last x ;  // Second symbol in the pair
    
    // Ensure symbols are different to avoid self-pairing
    // Select prices for each symbol and rename the columns properly using 'as'
    data1: select Time, Price_x :Price from stock_data where Symbol = sym1;
    data2: select Time, Price_y : Price from stock_data where Symbol = sym2;
    
    // Perform an asof join to match prices by Time
    joined: aj[`Time; data1; data2];
    
    // Check if Price_x and Price_y exist in the joined table
    if[not (`Price_x in cols joined) or not (`Price_y in cols joined); : ()];
    
    // Calculate the absolute spread between the two prices
    joined : update Spread: abs Price_x - Price_y from joined;
    
    // Return only non-null spreads
    select Time, Spread, sym1, sym2 from joined where not null Spread};

spreads: raze spreadCalc each pairs