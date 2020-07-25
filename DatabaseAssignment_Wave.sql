--Question 1
--Use count to find the number of users in Wave from u_id column in users
SELECT COUNT(u_id) FROM public.users;

--Question 2
--Rows with CFA(receive_amount_currency) in transfers table
SELECT COUNT(transfer_id) FROM public.transfers 
WHERE send_amount_currency ='CFA';

--Question 3
--Number of rows(using u_id ti identify the users that sent money in CFA
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
--Number of withdrawals vs number of deposits
--<0 net depositors
-->0 net withdrawers
SELECT COUNT(agent_transactions.agent_id) AS number_net_depositor
 FROM public.agents INNER JOIN public.agent_transactions
 	ON agents.agent_id = agent_transactions.agent_id
WHERE agent_transactions.amount<0 AND agent_transactions.when_created > current_date-interval '7 days';
;

--Question 6
--temp table transactions in the past week (order by city)
SELECT COUNT(atx_id) AS volume, city
FROM public.agent_transactions, public.agents
WHERE agent_transactions.when_created BETWEEN now() And now()-interval'7 days'
GROUP BY city;

--Question 7
SELECT COUNT(atx_id) AS volume,city,country 
FROM public.agent_transactions, public.agents 
WHERE agent_transactions.when_created BETWEEN now() And now()-interval'7'  
GROUP BY city, country;

--Question 8
--order by transfer type
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
SELECT source_wallet_id, send_amount_scalar FROM transfers
WHERE send_amount_currency = 'CFA' AND
(send_amount_scalar>10000000) AND
(transfers.when_created > (now() - INTERVAL '1 month'));

