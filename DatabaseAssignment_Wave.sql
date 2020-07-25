--Question 1
--Use count on u_id to find the number of users in Wave from u_id column in users
SELECT COUNT(u_id) FROM public.users;

--Question 2
--Rows with CFA(receive_amount_currency) in transfers table
--Use count on transfer_id to find the number of transactions and WHERE clause to determine amount in CFA currency
SELECT COUNT(transfer_id) FROM public.transfers 
WHERE send_amount_currency ='CFA';

--Question 3
--Use COUNT and DISTINCT on u_id to generate number unique different users.
SELECT COUNT(DISTINCT u_id) FROM public.transfers 
WHERE send_amount_currency ='CFA';

--Question 4
SELECT COUNT(atx_id) AS Number_Agent_transactions,TO_CHAR(TO_DATE (EXTRACT(MONTH FROM when_created)::text, 'MM'), 'Month')
--EXTRACT(MONTH FROM agent_transactions.when_created) AS Months 
FROM public.agent_transactions
WHERE EXTRACT(YEAR FROM agent_transactions.when_created) = '2018'
GROUP BY EXTRACT(MONTH FROM agent_transactions.when_created)
; 

--Question 5
--<0 net depositors
-->0 net withdrawers
--INNER JOIN the agents and transactions table to find the agents that were net depositors
SELECT COUNT(agent_transactions.agent_id) AS number_net_depositor
 FROM public.agents INNER JOIN public.agent_transactions
 	ON agents.agent_id = agent_transactions.agent_id
WHERE agent_transactions.amount<0 AND agent_transactions.when_created > current_date-interval '7 days';
;

--Question 6
--create a view table displaying the number of transactions(Volume) in the past week (grouped by city) 
CREATE VIEW atx_volume_city_summary AS SELECT COUNT(atx_id) AS volume, city
FROM public.agent_transactions, public.agents
WHERE agent_transactions.when_created BETWEEN now() And now()-interval'7 days'
GROUP BY city;

--Question 7
--Cascade the temporary table under the atx_volume_city_summary with the column country using the 'REPLACE' clause
CREATE OR REPLACE VIEW atx_volume_city_summary AS 
SELECT COUNT(atx_id) AS volume,city,country 
FROM public.agent_transactions, public.agents 
WHERE agent_transactions.when_created BETWEEN now() And now()-interval'7'  
GROUP BY city, country;

--Question 8
--create a view table summarizing the volume of transaction(count atx_id) by transfer type(kind) and country
CREATE VIEW send_volume AS
SELECT COUNT(atx_id) AS volume,kind,country
FROM public.agent_transactions,public.transfers, public.agents
WHERE agent_transactions.when_created>current_date -interval '7 days'
--agent_transactions.when_created BETWEEN '2018-11-23' AND '2018-12-30'
GROUP BY kind,country;

--Question 9
-- Adding a column to the table to display  
SELECT COUNT(DISTINCT transfers.source_wallet_id) AS Unique_Senders,
COUNT(transfer_id) AS Transaction_count, 
transfers.kind AS Transfer_Kind, wallets.ledger_location AS Country, 
SUM(transfers.send_amount_scalar) AS Volume 
FROM transfers INNER JOIN wallets
ON transfers.source_wallet_id = wallets.wallet_id 
WHERE (transfers.when_created > (NOW() - INTERVAL '7 days')) 
GROUP BY wallets.ledger_location, transfers.kind;

--Question 10
--Display which wallet_id has an amount(send_amount_scalar) has a value > 10000000 in the last month
SELECT transfers.source_wallet_id, sum( transfers.send_amount_scalar) AS total_sent FROM transfers
WHERE send_amount_currency = 'CFA'
AND (transfers.when_created > (now() - INTERVAL '10 month'))
GROUP BY transfers.source_wallet_id
HAVING sum( transfers.send_amount_scalar)>10000000

