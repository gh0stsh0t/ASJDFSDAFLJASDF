-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 11, 2017 at 04:43 AM
-- Server version: 10.1.19-MariaDB
-- PHP Version: 7.0.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `amc`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `displayCapitalsTable` (IN `yr` INT, IN `accountstatus` INT, IN `likephrase` VARCHAR(75))  READS SQL DATA
BEGIN

SELECT m.member_id, CAST(c.capital_account_id AS CHAR(5)) AS 'Acc. No.', CONCAT(m.family_name, ', ', m.first_name, ' ', m.middle_name) AS 'Member Name', COALESCE(amc.getCapitalBeginningBalance(yr,ct.capital_account_id),0) as 'Beginning Balance for the Year',
COALESCE(amc.computeCapitalOutstandingBalance(yr,ct.capital_account_id),0) as 'Outstanding Balance',
COALESCE(amc.computeCapitalAvgMonthlyBalance(yr,ct.capital_account_id),0) as 'Average Monthly Balance',
COALESCE(amc.computeDividend(yr,ct.capital_account_id),0) as 'Interest on Share Capital or Dividend',
COALESCE(amc.computeCapitalDifference(yr,ct.capital_account_id),0) as 'Increase / Decrease in SC for the Year',
(SELECT amount FROM amc.capital_general_log WHERE fund_type = 3 AND YEAR(date) <= yr ORDER BY date DESC LIMIT 1)  as 'Targeted Increase for the Year',
COALESCE(amc.computeCapitalPercentAccomplished(yr,ct.capital_account_id),0) as '% Accomplished',
COALESCE(amc.computeCapitalNetBookValue(yr,ct.capital_account_id),0) as 'Net Book Value of Share Capital'
FROM capitals c LEFT JOIN capitals_transaction ct ON c.capital_account_id = ct.capital_account_id INNER JOIN members m ON c.member_id = m.member_id WHERE m.status = 1 AND c.account_status = accountstatus  AND (c.capital_account_id LIKE likephrase OR m.family_name LIKE likephrase OR m.first_name LIKE likephrase OR m.middle_name LIKE likephrase ) GROUP BY c.capital_account_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `displayMonthTable` (IN `mn` INT, IN `yr` INT, IN `accountstatus` INT, IN `likephrase` VARCHAR(75))  READS SQL DATA
BEGIN

SELECT m.member_id, s.savings_account_id AS 'Acc. No.', CONCAT(m.family_name, ', ', m.first_name, ' ', m.middle_name) AS 'Member Name', COALESCE(amc.getMonthBeginningBalance(mn,yr,st.savings_account_id),0) as 'Beginning Balance', COALESCE(amc.computeMonthOutstandingBalance(mn,yr,st.savings_account_id),0) as 'Outstanding Balance', COALESCE(amc.computeMonthInterest(mn,yr,st.savings_account_id),0) AS 'Computed Interest',
COALESCE(amc.computeMonthInterestExpense(mn,yr,st.savings_account_id),0) AS 'Interest Expense for the Month',
COALESCE(amc.computeMonthEndBalance(mn,yr,st.savings_account_id),0) AS 'Month End Balance',
COALESCE(amc.computeMonthAvgDailyBalance(mn,yr,st.savings_account_id),0) AS 'Average Daily Balance',
COALESCE(amc.computeMonthBalanceDifference(mn,yr,st.savings_account_id),0) AS 'Increase (Decrease) for the Month'
FROM savings s LEFT JOIN savings_transaction st ON s.savings_account_id = st.savings_account_id INNER JOIN members m ON s.member_id = m.member_id WHERE m.status = 1 AND s.account_status = accountstatus AND MONTH(s.opening_date) <= mn AND YEAR(s.opening_date) <= yr AND (s.savings_account_id LIKE likephrase OR m.family_name LIKE likephrase OR m.first_name LIKE likephrase OR m.middle_name LIKE likephrase ) GROUP BY s.savings_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `displayQuarterMonthTable` (IN `mn` INT, IN `yr` INT, IN `accountstatus` INT, IN `likephrase` VARCHAR(75))  READS SQL DATA
BEGIN

SELECT m.member_id, s.savings_account_id AS 'Acc. No.', CONCAT(m.family_name, ', ', m.first_name, ' ', m.middle_name) AS 'Member Name', COALESCE(amc.getMonthBeginningBalance(mn,yr,st.savings_account_id),0) as 'Beginning Balance', COALESCE(amc.computeMonthOutstandingBalance(mn,yr,st.savings_account_id),0) as 'Outstanding Balance', COALESCE(amc.computeMonthInterest(mn,yr,st.savings_account_id),0) AS 'Computed Interest',
COALESCE(amc.computeMonthInterestExpense(mn,yr,st.savings_account_id),0) AS 'Interest Expense for the Month',
COALESCE(amc.computeQuarterInterest(mn,yr,st.savings_account_id),0) AS 'Interest Credited for the Quarter',
COALESCE(amc.computeMonthEndBalance(mn,yr,st.savings_account_id),0) AS 'Month End Balance',
COALESCE(amc.computeMonthAvgDailyBalance(mn,yr,st.savings_account_id),0) AS 'Average Daily Balance',
COALESCE(amc.computeMonthBalanceDifference(mn,yr,st.savings_account_id),0) AS 'Increase (Decrease) for the Month'
FROM savings s LEFT JOIN savings_transaction st ON s.savings_account_id = st.savings_account_id INNER JOIN members m ON s.member_id = m.member_id WHERE m.status = 1 AND s.account_status = accountstatus AND MONTH(s.opening_date) <= mn AND YEAR(s.opening_date) <= yr AND (s.savings_account_id LIKE likephrase OR m.family_name LIKE likephrase OR m.first_name LIKE likephrase OR m.middle_name LIKE likephrase ) GROUP BY s.savings_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `displayYearTable` (IN `yr` INT, IN `accountstatus` INT, IN `likephrase` VARCHAR(75))  READS SQL DATA
BEGIN

SELECT m.member_id, s.savings_account_id AS 'Acc. No.', CONCAT(m.family_name, ', ', m.first_name, ' ', m.middle_name) AS 'Member Name', COALESCE(amc.getMonthBeginningBalance(1,yr,st.savings_account_id),0) as 'Beginning Balance for the Year',
COALESCE(amc.computeYearOutstandingBalance(yr,st.savings_account_id),0) as 'Outstanding Balance, End of Year',
COALESCE(amc.computeYearOutstandingBalance(yr,st.savings_account_id),0) - COALESCE(amc.getMonthBeginningBalance(1,yr,st.savings_account_id),0) as 'Increase (Decrease)',
COALESCE(amc.computeYearInterest(yr,st.savings_account_id),0) as 'Total Computed Interest for the Year',
COALESCE(amc.computeYearInterestExpense(yr,st.savings_account_id),0) as 'Total Interest Credit for the Year',
COALESCE(amc.computeYearQuarterInterest(yr,st.savings_account_id),0) as 'Interest Expense for the Year (Based on Quarterly Credit)'
FROM savings s LEFT JOIN savings_transaction st ON s.savings_account_id = st.savings_account_id INNER JOIN members m ON s.member_id = m.member_id WHERE m.status = 1 AND s.account_status = accountstatus AND YEAR(s.opening_date) <= yr AND (s.savings_account_id LIKE likephrase OR m.family_name LIKE likephrase OR m.first_name LIKE likephrase OR m.middle_name LIKE likephrase ) GROUP BY s.savings_account_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `loansM` ()  READS SQL DATA
BEGIN
	SELECT members.member_id, concat_ws(',', family_name, first_name) as name FROM members inner JOIN loans on members.member_id=loans.member_id where date_terminated IS NULL AND loan_status=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `monthview` (IN `loanid` INT(11), IN `mo` INT(2))  READS SQL DATA
BEGIN
	SELECT SUM(total_amount) AS Total, SUM(principal) AS Principal, SUM(interest) AS Interest, SUM(penalty) AS Penalty FROM loan_transaction WHERE MONTH(date) = mo AND loan_account_id = loanid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtainHeaderValues` (IN `yr` INT)  READS SQL DATA
BEGIN

SELECT PUC1 AS 'PUC1', PUC2 AS 'PUC2', NET AS 'NET', RF1 AS 'RF1' , CAST((NET * RF1) AS DECIMAL(13,2)) AS 'RF2', CAST(PUC1 - PUC2 AS DECIMAL(13,2)) AS 'DIFF1', CAST(NET - (NET * (RF1 / 100)) AS DECIMAL(13,2)) AS 'DIFF2'  
FROM (SELECT amc.computeTotalCapitalOutstandingBalance(yr) AS 'PUC1', (SELECT amount FROM amc.capital_general_log WHERE fund_type = 2 AND YEAR(date) <= yr ORDER BY date DESC LIMIT 1) AS 'PUC2', (SELECT amount FROM amc.capital_general_log WHERE fund_type = 0 AND YEAR(date) <= yr ORDER BY date DESC LIMIT 1) AS 'NET', (SELECT amount * 100 FROM amc.capital_general_log WHERE fund_type = 1 AND YEAR(date) <= yr ORDER BY date DESC LIMIT 1) AS 'RF1') tb;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSavingsBalanceLog` ()  MODIFIES SQL DATA
BEGIN
INSERT INTO amc.savings_balance_log (savings_account_id, amount, date)
SELECT st.savings_account_id, COALESCE(amc.computeMonthEndBalance(MONTH(CURDATE()) - 1,YEAR(CURDATE()),st.savings_account_id),0) AS 'Month End Balance', CURDATE() 
FROM savings s LEFT JOIN savings_transaction st ON s.savings_account_id = st.savings_account_id INNER JOIN members m ON s.member_id = m.member_id 
WHERE m.status = 1 AND s.account_status = 1 GROUP BY s.savings_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `viewagingsched` ()  READS SQL DATA
BEGIN
SELECT 
    Age,
    `Date Granted to Cut-off date`,
    CASE
        WHEN `Date Granted to Cut-off date` < 1 THEN 'Current'
        ELSE 'Past Due'
    END AS Status,
    CASE
        WHEN `Date Granted to Cut-off date` <= 1 THEN balance
        ELSE 0
    END AS 'Current',
    CASE
        WHEN `Date Granted to Cut-off date` BETWEEN 1 AND 30 THEN balance
        ELSE 0
    END AS '1-30 Days',
    CASE
        WHEN `Date Granted to Cut-off date` BETWEEN 31 AND 60 THEN balance
        ELSE 0
    END AS '31-60 Days',
    CASE
        WHEN `Date Granted to Cut-off date` BETWEEN 61 AND 90 THEN balance
        ELSE 0
    END AS '61-90 Days',
    CASE
        WHEN `Date Granted to Cut-off date` BETWEEN 91 AND 120 THEN balance
        ELSE 0
    END AS '91-120 Days',
    CASE
        WHEN `Date Granted to Cut-off date` BETWEEN 121 AND 180 THEN balance
        ELSE 0
    END AS '121-180 Days',
    CASE
        WHEN `Date Granted to Cut-off date` BETWEEN 181 AND 365 THEN balance
        ELSE 0
    END AS '181-365 Days',
    CASE
        WHEN `Date Granted to Cut-off date` BETWEEN 366 AND 730 THEN balance
        ELSE 0
    END AS '366 to 2 years (730 days)',
    CASE
        WHEN `Date Granted to Cut-off date` >= 731 THEN balance
        ELSE 0
    END AS 'More than 2 years (or 730 days)',
    CASE
        WHEN `Date Granted to Cut-off date` > 1 THEN balance
        ELSE 0
    END AS 'Total Past Due'
FROM
    (SELECT 
        Age,
            term,
            Age - term AS 'Date Granted to Cut-off date',
            balance
    FROM
        (SELECT 
        DATEDIFF(DATE_ADD('2016-11-30', INTERVAL EXTRACT(YEAR FROM CURDATE()) - 2016 YEAR), date_granted) AS Age,
            term,
            outstanding_balance AS balance
    FROM
        loans
    GROUP BY member_id) AS x) AS y;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `viewloanrequests` ()  READS SQL DATA
BEGIN
	SELECT loan_account_id, member_id, concat_ws(', ', family_name, first_name) as Name, cast(loan_type AS char(25)) as loan_type, cast(request_type AS char(25)) as request_type, term, orig_amount, interest_rate FROM loans NATURAL JOIN members where loan_status = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `viewloansched` ()  READS SQL DATA
BEGIN
	SELECT loan_account_id, member_id, term, DATE_ADD(date_granted, INTERVAL term DAY) as due_date, orig_amount, outstanding_balance FROM loans NATURAL JOIN members;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `viewloanschedname` ()  READS SQL DATA
BEGIN
	SELECT loan_account_id, member_id, concat_ws(', ', family_name, first_name) as Name, date_granted FROM loans NATURAL JOIN members;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `viewloanscomplete` ()  BEGIN
	SELECT  loan_account_id, member_id, concat_ws(', ', family_name, first_name) as Name, date_granted, term, DATE_ADD(date_granted, INTERVAL term DAY) as due_date, orig_amount, outstanding_balance FROM loans NATURAL JOIN members WHERE loan_status = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `viewloanstotal` ()  READS SQL DATA
BEGIN
SELECT member_id,
		CASE WHEN SUM(interest) IS NULL THEN 0 
			ELSE SUM(interest)
            END AS 'Total Interest', 
		CASE WHEN SUM(principal) IS NULL THEN 0
			 ELSE SUM(principal)
             END AS 'Total Principal', 
		CASE WHEN SUM(penalty) IS NULL THEN 0
			 ELSE SUM(interest)
             END AS 'Total Penalty', 
		CASE WHEN SUM(outstanding_balance) IS NULL THEN 0
			 ELSE SUM(outstanding_balance)
             END AS balance
		FROM loan_transaction RIGHT JOIN loans on loans.loan_account_id=loan_transaction.loan_account_id
		GROUP BY member_id;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `computeCapitalAvgMonthlyBalance` (`yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN (
    SELECT 
    COALESCE((SUM(
        CASE WHEN DAY(date) <= 7
    THEN COALESCE(transaction_type * total_amount * (13 - MONTH(date)),0)
    ELSE COALESCE(transaction_type * total_amount * (12 - MONTH(date)),0)
    END)
    + (COALESCE(amc.getCapitalBeginningBalance(yr,accountid),0) * 12))
             / 12,0)
    FROM amc.capitals_transaction WHERE YEAR(date) = yr AND capital_account_id = accountid GROUP BY capital_account_id
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeCapitalDifference` (`yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT COALESCE(amc.computeCapitalOutstandingBalance(YEAR(date),capital_account_id) - 		   COALESCE( 		   amc.getCapitalBeginningBalance(YEAR(date),capital_account_id),0), 0)    
    FROM amc.capitals_transaction WHERE YEAR(date) = yr AND capital_account_id = accountid LIMIT 1
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeCapitalNetBookValue` (`yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN (
    SELECT 
    COALESCE(
        amc.computeCapitalOutstandingBalance(YEAR(date),capital_account_id) / amc.computeTotalCapitalOutstandingBalance(YEAR(date)) * amc.computeTotalCapitalOutstandingBalance(YEAR(date))
        ,0)
    FROM amc.capitals_transaction WHERE YEAR(date) = yr AND capital_account_id = accountid GROUP BY capital_account_id
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeCapitalOutstandingBalance` (`yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN (
    SELECT 
    COALESCE(SUM(total_amount * transaction_type),0)
    FROM amc.capitals_transaction WHERE YEAR(date) = yr AND capital_account_id = accountid GROUP BY capital_account_id
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeCapitalPercentAccomplished` (`yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT CONCAT((COALESCE(amc.computeCapitalDifference(YEAR(date),capital_account_id) / (SELECT COALESCE(amount,0) FROM amc.capital_general_log WHERE fund_type = 3 AND YEAR(date) <= 2017 ORDER BY date DESC LIMIT 1), 0)) * 100, ' %')   
    FROM amc.capitals_transaction WHERE YEAR(date) = yr AND capital_account_id = accountid LIMIT 1
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeDividend` (`yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN (
    SELECT 
    COALESCE(
        amc.computeCapitalAvgMonthlyBalance(YEAR(date),capital_account_id) / amc.computeTotalCapitalAvgBalance(YEAR(date)) * (amc.computeDividendMultiplier(YEAR(date)) * 0.65)
        ,0)
    FROM amc.capitals_transaction WHERE YEAR(date) = yr AND capital_account_id = accountid GROUP BY capital_account_id
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeDividendMultiplier` (`yr` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT COALESCE(CONVERT(
        amount * (SELECT 1 - amount FROM `capital_general_log` WHERE fund_type = 1 AND YEAR(date) = yr ORDER BY date DESC LIMIT 1)
        , DECIMAL(13,2)),0) FROM `capital_general_log` WHERE fund_type = 0 AND YEAR(date) = yr ORDER BY date DESC LIMIT 1
    );
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeMonthAvgDailyBalance` (`mn` INT, `yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN 
(
    SELECT COALESCE( amc.computeMonthMultipliedSum(MONTH(date),YEAR(date),savings_account_id) / amc.getMonthDays(MONTH(date),YEAR(date)),0) AS amount FROM amc.savings_transaction WHERE MONTH(date) = mn AND YEAR(date) = yr AND savings_account_id = accountid GROUP BY savings_account_id
);    
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeMonthBalanceDifference` (`mn` INT, `yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT COALESCE(amc.computeMonthOutstandingBalance(MONTH(date),YEAR(date),savings_account_id) - 		   amc.getMonthBeginningBalance(MONTH(date),YEAR(date),savings_account_id), 0)    
    FROM amc.savings_transaction WHERE MONTH(date) = mn AND YEAR(date) = yr AND savings_account_id = accountid GROUP BY savings_account_id
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeMonthEndBalance` (`mn` INT, `yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT CASE
    WHEN mn % 3 = 0 
    THEN COALESCE(COALESCE(amc.computeMonthOutstandingBalance(mn,yr,accountid),0) + COALESCE(amc.computeQuarterInterest(mn,yr,accountid),0),0)
    ELSE COALESCE(amc.computeMonthOutstandingBalance(mn,yr,accountid),0)
    END 
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeMonthInterest` (`mn` INT, `yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT COALESCE(COALESCE(amc.computeMonthMultipliedSum(mn,yr,accountid),0) * (COALESCE(amc.getMonthInterestRate(mn,yr),0) / 365),0)
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeMonthInterestExpense` (`mn` INT, `yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
DECLARE x DECIMAL(13,2);
IF (SELECT COALESCE(amc.computeMonthAvgDailyBalance(mn,yr,accountid),0) FROM amc.savings_transaction LIMIT 1) > (SELECT COALESCE(amc.getMonthAvgDailyBalance(mn,yr),0) FROM amc.avg_daily_balance_log LIMIT 1)
	THEN SET x = (SELECT COALESCE( amc.computeMonthInterest(mn,yr,accountid),0) FROM amc.savings_transaction LIMIT 1);
ELSE SET x = 0;
END IF;
RETURN x;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeMonthMultipliedSum` (`mn` INT, `yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN (SELECT COALESCE(SUM(((total_amount * (amc.getMonthDays(MONTH(date), YEAR(date)) - DAY(date))) * transaction_type)),0) + ((amc.getMonthDays(MONTH(date), YEAR(date)) * COALESCE(amc.getMonthBeginningBalance(mn, yr,accountid),0))) AS amount FROM amc.savings_transaction WHERE MONTH(date) = mn AND YEAR(date) = yr AND savings_account_id = accountid LIMIT 1);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeMonthOutstandingBalance` (`mn` INT, `yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT COALESCE(COALESCE(SUM(total_amount * transaction_type),0) + amc.getMonthBeginningBalance(mn,yr,accountid),0) AS outstanding_balance FROM savings_transaction WHERE MONTH(date) = mn AND YEAR(date) = yr AND savings_account_id = accountid LIMIT 1
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeQuarterInterest` (`mn` INT, `yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT COALESCE(amc.computeMonthInterestExpense(MONTH(date)-2,YEAR(date),savings_account_id),0) + 		   COALESCE(amc.computeMonthInterestExpense(MONTH(date)-1,YEAR(date),savings_account_id),0) +
    COALESCE(amc.computeMonthInterestExpense(MONTH(date),YEAR(date),savings_account_id),0)    
    FROM amc.savings_transaction WHERE MONTH(date) = mn AND YEAR(date) = yr AND savings_account_id = accountid GROUP BY savings_account_id
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeTotalCapitalAvgBalance` (`yr` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN(
    SELECT COALESCE(SUM(DISTINCT amc.computeCapitalAvgMonthlyBalance(yr,capital_account_id)),0) FROM amc.capitals_transaction WHERE YEAR(date) = yr LIMIT 1
    );
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeTotalCapitalOutstandingBalance` (`yr` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN(
    SELECT COALESCE(SUM(DISTINCT amc.computeCapitalOutstandingBalance(yr,capital_account_id)),0) FROM amc.capitals_transaction WHERE YEAR(date) = yr LIMIT 1
    );
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeYearInterest` (`yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT 
    COALESCE(amc.computeMonthInterest(1,yr,accountid),0) +
    COALESCE(amc.computeMonthInterest(2,yr,accountid),0) +
    COALESCE(amc.computeMonthInterest(3,yr,accountid),0) +
    COALESCE(amc.computeMonthInterest(4,yr,accountid),0) +
    COALESCE(amc.computeMonthInterest(5,yr,accountid),0) +
    COALESCE(amc.computeMonthInterest(6,yr,accountid),0) +
    COALESCE(amc.computeMonthInterest(7,yr,accountid),0) +
    COALESCE(amc.computeMonthInterest(8,yr,accountid),0) +
    COALESCE(amc.computeMonthInterest(9,yr,accountid),0) +
    COALESCE(amc.computeMonthInterest(10,yr,accountid),0) +
    COALESCE(amc.computeMonthInterest(11,yr,accountid),0) +
    COALESCE(amc.computeMonthInterest(12,yr,accountid),0)
    AS year_interest 
    FROM amc.savings_transaction WHERE YEAR(date) = yr AND savings_account_id = accountid LIMIT 1
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeYearInterestExpense` (`yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT 
    COALESCE(amc.computeMonthInterestExpense(1,yr,accountid),0) +
    COALESCE(amc.computeMonthInterestExpense(2,yr,accountid),0) +
    COALESCE(amc.computeMonthInterestExpense(3,yr,accountid),0) +
    COALESCE(amc.computeMonthInterestExpense(4,yr,accountid),0) +
    COALESCE(amc.computeMonthInterestExpense(5,yr,accountid),0) +
    COALESCE(amc.computeMonthInterestExpense(6,yr,accountid),0) +
    COALESCE(amc.computeMonthInterestExpense(7,yr,accountid),0) +
    COALESCE(amc.computeMonthInterestExpense(8,yr,accountid),0) +
    COALESCE(amc.computeMonthInterestExpense(9,yr,accountid),0) +
    COALESCE(amc.computeMonthInterestExpense(10,yr,accountid),0) +
    COALESCE(amc.computeMonthInterestExpense(11,yr,accountid),0) +
    COALESCE(amc.computeMonthInterestExpense(12,yr,accountid),0)
    AS year_interest 
    FROM amc.savings_transaction WHERE YEAR(date) = yr AND savings_account_id = accountid LIMIT 1
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeYearOutstandingBalance` (`yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT COALESCE(amc.computeMonthEndBalance((SELECT max(MONTH(date)) FROM amc.savings_transaction WHERE YEAR(date) = yr AND savings_account_id = accountid LIMIT 1) ,yr,accountid),0)
    AS outstanding_balance 
    FROM amc.savings_transaction WHERE YEAR(date) = yr AND savings_account_id = accountid LIMIT 1
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `computeYearQuarterInterest` (`yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT 
    COALESCE(amc.computeQuarterInterest(3,yr,accountid),0) +
    COALESCE(amc.computeQuarterInterest(6,yr,accountid),0) +
    COALESCE(amc.computeQuarterInterest(9,yr,accountid),0) +
    COALESCE(amc.computeQuarterInterest(12,yr,accountid),0)
    FROM amc.savings_transaction WHERE YEAR(date) = yr AND savings_account_id = accountid LIMIT 1
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getCapitalBeginningBalance` (`yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT COALESCE(amount,0) FROM amc.capitals_balance_log WHERE capital_account_id = accountid AND YEAR(date) = yr ORDER BY date ASC LIMIT 1
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getMonthAvgDailyBalance` (`mn` INT, `yr` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT COALESCE(amount,0) FROM amc.avg_daily_balance_log WHERE MONTH(date) <= mn AND YEAR(date) <= yr ORDER BY date DESC LIMIT 1
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getMonthBeginningBalance` (`mn` INT, `yr` INT, `accountid` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT COALESCE(amount,0) FROM amc.savings_balance_log WHERE savings_account_id = accountid AND MONTH(date) = mn AND YEAR(date) = yr ORDER BY date DESC LIMIT 1
);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getMonthDays` (`month` INT, `year` INT) RETURNS INT(11) BEGIN
DECLARE x int;
IF month = 4 OR month = 6 OR month = 9 OR month = 11
	THEN SET x = 30;
ELSEIF month = 2 AND year % 4 = 0
	THEN SET x = 29;
ELSEIF month = 2
 	THEN SET x = 28;
ELSE SET x = 31;
END IF;
RETURN x;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getMonthInterestRate` (`mn` INT, `yr` INT) RETURNS DECIMAL(13,2) READS SQL DATA
BEGIN
RETURN
(
    SELECT interest_rate FROM amc.interest_rate_log WHERE MONTH(date) <= mn AND YEAR(date) <= yr ORDER BY date DESC LIMIT 1
);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `avg_daily_balance_log`
--

CREATE TABLE `avg_daily_balance_log` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `amount` decimal(13,2) NOT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `avg_daily_balance_log`
--

INSERT INTO `avg_daily_balance_log` (`id`, `date`, `amount`, `updated_by`) VALUES
(1, '2017-09-14', '500.00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `capitals`
--

CREATE TABLE `capitals` (
  `capital_account_id` int(11) NOT NULL,
  `member_id` int(11) DEFAULT NULL,
  `opening_date` date DEFAULT NULL,
  `ics_no` int(11) DEFAULT NULL,
  `ics_amount` decimal(13,2) DEFAULT NULL,
  `ipuc_amount` decimal(13,2) DEFAULT NULL,
  `account_status` int(11) DEFAULT NULL,
  `withdrawal_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `capitals`
--

INSERT INTO `capitals` (`capital_account_id`, `member_id`, `opening_date`, `ics_no`, `ics_amount`, `ipuc_amount`, `account_status`, `withdrawal_date`) VALUES
(1, 1, '2017-09-12', 100, '10000.00', '1500.00', 1, '2017-10-01'),
(3, 2, '2017-10-04', 100, '10000.00', '1500.00', 1, NULL),
(4, 8, '2017-10-04', 100, '10000.00', '1500.00', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `capitals_balance_log`
--

CREATE TABLE `capitals_balance_log` (
  `id` int(11) NOT NULL,
  `capital_account_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `amount` decimal(13,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `capitals_balance_log`
--

INSERT INTO `capitals_balance_log` (`id`, `capital_account_id`, `date`, `amount`) VALUES
(1, 3, '2017-10-04', '1500.00'),
(2, 1, '2017-09-01', '10000.00'),
(3, 4, '2017-10-04', '1500.00');

-- --------------------------------------------------------

--
-- Table structure for table `capitals_transaction`
--

CREATE TABLE `capitals_transaction` (
  `capital_transaction_id` int(11) NOT NULL,
  `capital_account_id` int(11) DEFAULT NULL,
  `transaction_type` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `total_amount` decimal(13,2) DEFAULT NULL,
  `encoded_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `capitals_transaction`
--

INSERT INTO `capitals_transaction` (`capital_transaction_id`, `capital_account_id`, `transaction_type`, `date`, `total_amount`, `encoded_by`) VALUES
(1, 1, 1, '2017-09-04', '1000.00', NULL),
(2, 1, 1, '2017-09-14', '2000.00', NULL),
(3, 1, -1, '2017-09-25', '500.00', NULL),
(4, 1, 1, '2017-10-03', '110.00', NULL),
(5, 3, 1, '2017-10-04', '100.00', 1),
(6, 4, 1, '2017-10-04', '100.00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `capitals_transaction_line`
--

CREATE TABLE `capitals_transaction_line` (
  `capital_trans_line_id` int(11) NOT NULL,
  `capital_transaction_id` int(11) DEFAULT NULL,
  `account_log_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `capitals_transaction_line`
--

INSERT INTO `capitals_transaction_line` (`capital_trans_line_id`, `capital_transaction_id`, `account_log_id`) VALUES
(1, 4, 34),
(2, 4, 35),
(3, 5, 43),
(4, 5, 44),
(5, 6, 47),
(6, 6, 48);

-- --------------------------------------------------------

--
-- Table structure for table `capital_general_log`
--

CREATE TABLE `capital_general_log` (
  `id` int(11) NOT NULL,
  `fund_type` int(11) DEFAULT NULL,
  `amount` decimal(13,2) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `capital_general_log`
--

INSERT INTO `capital_general_log` (`id`, `fund_type`, `amount`, `date`, `updated_by`) VALUES
(1, 0, '4320000.00', '2017-09-24', NULL),
(2, 1, '0.30', '2017-09-24', NULL),
(3, 2, '9901606.21', '2017-09-24', NULL),
(4, 3, '2250.00', '2017-09-24', NULL),
(5, 1, '0.31', '2017-10-04', 1);

-- --------------------------------------------------------

--
-- Table structure for table `chart_of_accounts`
--

CREATE TABLE `chart_of_accounts` (
  `code` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `chart_of_accounts`
--

INSERT INTO `chart_of_accounts` (`code`, `title`, `type`, `status`) VALUES
(101, 'Cash', 0, 1),
(102, 'Notes Payable', 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `chart_of_accounts_log`
--

CREATE TABLE `chart_of_accounts_log` (
  `id` int(11) NOT NULL,
  `code` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `amount` decimal(13,2) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `encoded_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `chart_of_accounts_log`
--

INSERT INTO `chart_of_accounts_log` (`id`, `code`, `date`, `amount`, `type`, `encoded_by`) VALUES
(17, 101, '2017-10-02', '10000.00', NULL, NULL),
(18, 102, '2017-10-02', '30000.00', NULL, NULL),
(32, 101, '2017-10-03', '-100.00', 1, NULL),
(33, 102, '2017-10-03', '-100.00', 0, NULL),
(34, 101, '2017-10-03', '110.00', 0, NULL),
(35, 102, '2017-10-03', '110.00', 1, NULL),
(36, 101, '2017-10-03', '-1000.00', 1, NULL),
(37, 102, '2017-10-03', '-1000.00', 0, NULL),
(38, 101, '2017-10-03', '50.00', 0, NULL),
(39, 102, '2017-10-03', '50.00', 1, NULL),
(40, 102, '2017-10-03', '-200.00', 0, NULL),
(41, 101, '2017-10-03', '-200.00', 1, NULL),
(42, 102, '2017-10-04', '100.00', 2, NULL),
(43, 102, '2017-10-04', '-100.00', 0, NULL),
(44, 101, '2017-10-04', '-100.00', 1, NULL),
(45, 101, '2017-10-04', '100.00', 0, NULL),
(46, 102, '2017-10-04', '100.00', 1, NULL),
(47, 101, '2017-10-04', '100.00', 0, NULL),
(48, 102, '2017-10-04', '100.00', 1, NULL),
(49, 101, '2017-10-04', '-100.00', 1, NULL),
(50, 102, '2017-10-04', '-100.00', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `comakers`
--

CREATE TABLE `comakers` (
  `comaker_id` int(11) NOT NULL,
  `loan_id` int(11) DEFAULT NULL,
  `name` varchar(75) DEFAULT NULL,
  `address` varchar(75) DEFAULT NULL,
  `company_name` varchar(65) DEFAULT NULL,
  `position` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `interest_rate_log`
--

CREATE TABLE `interest_rate_log` (
  `id` int(11) NOT NULL,
  `interest_rate` double NOT NULL,
  `date` date NOT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `interest_rate_log`
--

INSERT INTO `interest_rate_log` (`id`, `interest_rate`, `date`, `updated_by`) VALUES
(1, 0.03, '2017-08-07', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `loans`
--

CREATE TABLE `loans` (
  `loan_account_id` int(11) NOT NULL,
  `member_id` int(11) DEFAULT NULL,
  `loan_type` int(11) DEFAULT NULL,
  `request_type` int(11) DEFAULT NULL,
  `date_granted` date DEFAULT NULL,
  `approval_no` int(11) DEFAULT NULL,
  `term` int(11) DEFAULT NULL,
  `orig_amount` decimal(13,2) DEFAULT NULL,
  `interest_rate` double DEFAULT NULL,
  `purpose` varchar(65) DEFAULT NULL,
  `loan_status` int(11) DEFAULT NULL,
  `outstanding_balance` decimal(13,2) DEFAULT NULL,
  `date_terminated` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loans`
--

INSERT INTO `loans` (`loan_account_id`, `member_id`, `loan_type`, `request_type`, `date_granted`, `approval_no`, `term`, `orig_amount`, `interest_rate`, `purpose`, `loan_status`, `outstanding_balance`, `date_terminated`) VALUES
(1, 1, 0, 0, '2017-09-26', NULL, 60, '50000.00', 5, 'Loan', 1, '50000.00', '2017-09-26'),
(2, 2, 0, 0, '2017-09-26', NULL, 90, '1000.00', 5, 'Loan', 1, '1000.00', NULL),
(3, 1, 0, 0, '2017-09-26', NULL, 45, '1000.00', 5, 'asd', 1, '0.00', NULL),
(4, 9, 0, 1, NULL, NULL, 123, '123412.00', 5, 'None', 0, '123412.00', NULL),
(5, 9, 0, 1, '2017-10-04', NULL, 123, '123412.00', 5, 'None', 1, '123412.00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `loan_balance_log`
--

CREATE TABLE `loan_balance_log` (
  `id` int(11) NOT NULL,
  `loan_account_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `amount` decimal(13,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `loan_transaction`
--

CREATE TABLE `loan_transaction` (
  `loan_transaction_id` int(11) NOT NULL,
  `loan_account_id` int(11) DEFAULT NULL,
  `transaction_type` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `total_amount` decimal(13,2) DEFAULT NULL,
  `principal` decimal(13,2) DEFAULT NULL,
  `interest` decimal(13,2) DEFAULT NULL,
  `penalty` decimal(13,2) DEFAULT NULL,
  `encoded_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `loan_transaction`
--

INSERT INTO `loan_transaction` (`loan_transaction_id`, `loan_account_id`, `transaction_type`, `date`, `total_amount`, `principal`, `interest`, `penalty`, `encoded_by`) VALUES
(1, 1, 1, '2017-09-26', '1050.00', '1000.00', '50.00', '0.00', NULL),
(2, 2, 1, '2017-09-26', '210.00', '200.00', '10.00', '0.00', NULL),
(3, 1, 1, '2017-09-26', '1020.00', '1000.00', '20.00', '0.00', NULL),
(4, 3, 1, '2017-10-04', '0.00', '0.00', '0.00', '0.00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `loan_transaction_line`
--

CREATE TABLE `loan_transaction_line` (
  `loan_trans_line_id` int(11) NOT NULL,
  `loan_transaction_id` int(11) NOT NULL,
  `account_log_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `member_id` int(11) NOT NULL,
  `family_name` varchar(45) DEFAULT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `middle_name` varchar(45) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `gender` varchar(6) DEFAULT NULL,
  `address` varchar(75) DEFAULT NULL,
  `contact_no` varchar(20) DEFAULT NULL,
  `occupation` varchar(45) DEFAULT NULL,
  `company_name` varchar(65) DEFAULT NULL,
  `position` varchar(45) DEFAULT NULL,
  `annual_income` decimal(13,2) DEFAULT NULL,
  `tin` varchar(12) DEFAULT NULL,
  `educ_attainment` varchar(45) DEFAULT NULL,
  `civil_status` int(11) DEFAULT NULL,
  `religion` varchar(20) DEFAULT NULL,
  `no_of_dependents` int(11) DEFAULT NULL,
  `beneficiary_name` varchar(45) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `acceptance_date` date DEFAULT NULL,
  `acceptance_no` int(11) DEFAULT NULL,
  `termination_date` date DEFAULT NULL,
  `termination_no` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`member_id`, `family_name`, `first_name`, `middle_name`, `birthdate`, `gender`, `address`, `contact_no`, `occupation`, `company_name`, `position`, `annual_income`, `tin`, `educ_attainment`, `civil_status`, `religion`, `no_of_dependents`, `beneficiary_name`, `type`, `status`, `acceptance_date`, `acceptance_no`, `termination_date`, `termination_no`) VALUES
(1, 'DELA CRUZ', 'JUAN', 'SANTOS', '1981-11-21', 'MALE', 'RIVERDALE, DAVAO CITY', '09123456789', 'PHYSICIAN', 'SOUTHERN PHILIPPINES MEDICAL CENTER', 'CHIEF OF CLINICS', '500000.00', '123456789123', 'DOCTOR OF MEDICINE', 1, 'CATHOLIC', 1, 'JUANA DELA CRUZ', 0, 1, '2015-06-07', 123456, NULL, NULL),
(2, 'RIZAL', 'JOSE', 'MERCADO', '1989-06-19', 'MALE', 'DAVAO CITY', '09123456788', 'WRITER', 'LA SOLIDARIDAD', 'EDITOR', '100000.00', '123456789123', 'HIGH SCHOOL GRADUATE', 0, 'CATHOLIC', 0, 'NONE', 0, 1, '2017-09-01', 123, NULL, NULL),
(3, 'Rich', 'Richie', 'Moneybags', '1962-03-06', 'Male', 'Moneylandia', '09991524808', 'Rich Person', 'Rich Industries', 'CEO', '999999.00', '123456789123', 'College Graduate', 0, 'None', 0, 'None', 0, 1, '2017-10-04', 123213, NULL, NULL),
(4, 'Perias', 'Raphael John', 'Something', '1998-06-03', 'Male', 'Cabantian, Davao City', '09991234567', 'Anything', 'Anywhere', 'Anything', '1234567.00', '123456789123', 'College Graduate', 0, 'Catholic', 0, 'None', 0, 1, '2017-10-04', 123123, NULL, NULL),
(5, 'Fonda', 'Jane', 'Lady', '1942-11-03', 'Female', 'Madrid, Spain', '09991421324', 'Rich Lady', 'None', 'Rich Lady', '12.00', '123456789123', 'Unknown', 1, 'Evangelist', 0, 'None', 0, 1, '2017-10-04', 1323133, NULL, NULL),
(6, 'Rose', 'Derrick', 'James', '1989-04-03', 'Male', 'New York', '09991423909', 'Professional Athelete', 'New York Knicks', 'Athlete', '6500000.00', '123456789123', 'High School Graduate', 0, 'Protestant', 0, 'None', 0, 1, '2017-10-04', 123213123, NULL, NULL),
(7, 'Wayne', 'Lil', 'Christopher', '1982-03-08', 'Male', 'The World', '09991423808', 'Rapper', 'None', 'feat.', '12356784.00', '123456789123', 'Unknown', 0, 'None', 0, 'None', 0, 1, '2017-10-04', 123123123, NULL, NULL),
(8, 'Chigga', 'Rich', 'Bryce', '1999-04-01', 'Male', 'Indonesia', '09991428404', 'Rapper', 'b8', 'Blackest Chinese dude', '0.00', '123456789123', 'High School', 0, 'Evangelist', 0, 'None', 0, 1, '2017-10-04', 1232123, NULL, NULL),
(9, 'Knowles', 'Beyonce', 'Diva', '1984-10-02', 'Female', 'Brooklyn', '09991239090', 'Singer', 'Warner Brothers Music', 'Chart Topper', '9999999.00', '123456789123', 'High School Graduate', 2, 'Jewish', 1, 'Lil Jay Z', 0, 1, '2017-10-04', 13123123, NULL, NULL),
(10, 'Rapper', 'Chance the', 'Stephen', '1992-05-27', 'Male', 'Brooklyn', '09231231231', 'Rapper', 'Warner Brothers Music', 'New Age Rapper', '1234567.00', '123456789123', 'High School Graduate', 1, 'Jewish', 0, 'None', 0, 1, '2017-10-04', 123123213, NULL, NULL),
(11, 'Kunis', 'Mila', 'Russian', '1988-12-12', 'Female', 'Toronto', '09991535808', 'Actress', 'Somewhere', 'Who cares', '23234234.00', '123456789123', 'College Graduate', 1, 'Christian', 0, 'None', 0, 1, '2017-10-04', 13213, NULL, NULL),
(12, 'Clooney', 'George', 'Mr', '1972-12-12', 'Male', 'Who Acres', '09991429492', 'Actor', 'ASDFASF', 'Wtf', '2123123.00', '123456789123', 'High School Graduate', 2, 'Muslim', 4, 'LOL some hobo', 0, 1, '2017-10-04', 123213213, NULL, NULL),
(13, 'Mason', 'Mason', 'Mason', '2017-02-02', 'Female', 'Werewolf', '09123456789', 'Mason', 'aDFAFasdflnqwer', 'Villager', '12.12', '123456789123', 'None', 1, 'Jewish', 12, 'Santa Claus', 0, 1, '2017-10-04', 21321323, NULL, NULL),
(14, 'Magno', 'Vincent', 'ui', '1995-08-29', 'Male', '64 V Mapa', '09991523333', 'adf', 'Wayn', 'aasdf', '0.00', '123123123123', 'asdf', 0, 'Catholic', 0, 'asdf', 0, 0, '2017-10-04', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `savings`
--

CREATE TABLE `savings` (
  `savings_account_id` int(11) NOT NULL,
  `member_id` int(11) DEFAULT NULL,
  `opening_date` date DEFAULT NULL,
  `initial_balance` decimal(13,2) DEFAULT NULL,
  `account_status` int(11) DEFAULT NULL,
  `termination_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `savings`
--

INSERT INTO `savings` (`savings_account_id`, `member_id`, `opening_date`, `initial_balance`, `account_status`, `termination_date`) VALUES
(1, 1, '2017-09-07', '100.00', 1, NULL),
(2, 2, '2017-09-19', NULL, 1, '2017-09-30');

-- --------------------------------------------------------

--
-- Table structure for table `savings_balance_log`
--

CREATE TABLE `savings_balance_log` (
  `id` int(11) NOT NULL,
  `savings_account_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `amount` decimal(13,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `savings_balance_log`
--

INSERT INTO `savings_balance_log` (`id`, `savings_account_id`, `date`, `amount`) VALUES
(2, 1, '2017-08-01', '200.00'),
(5, 1, '2017-09-21', '421.00'),
(6, 2, '2017-09-21', '4000.00'),
(8, 1, '2017-10-03', '377.07'),
(9, 2, '2017-10-03', '4209.66');

-- --------------------------------------------------------

--
-- Table structure for table `savings_transaction`
--

CREATE TABLE `savings_transaction` (
  `savings_transaction_id` int(11) NOT NULL,
  `savings_account_id` int(11) DEFAULT NULL,
  `transaction_type` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `total_amount` decimal(13,2) DEFAULT NULL,
  `encoded_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `savings_transaction`
--

INSERT INTO `savings_transaction` (`savings_transaction_id`, `savings_account_id`, `transaction_type`, `date`, `total_amount`, `encoded_by`) VALUES
(4, 1, -1, '2017-09-12', '10.00', NULL),
(18, 1, 1, '2017-09-12', '20.00', NULL),
(19, 1, 1, '2017-09-12', '20.00', NULL),
(20, 1, -1, '2017-09-12', '25.00', NULL),
(21, 1, 1, '2017-09-12', '30.00', NULL),
(22, 1, 1, '2017-08-08', '35.00', NULL),
(23, 1, -1, '2017-08-30', '14.00', NULL),
(24, 1, 1, '2017-09-19', '20.00', NULL),
(26, 2, -1, '2017-09-05', '500.00', NULL),
(27, 2, 1, '2017-09-04', '100.00', NULL),
(29, 2, 1, '2017-09-06', '100.00', NULL),
(30, 2, 1, '2017-09-11', '200.00', NULL),
(32, 1, 1, '2017-08-01', '200.00', NULL),
(33, 2, 1, '2017-09-26', '300.00', NULL),
(34, 1, -1, '2017-09-26', '100.00', NULL),
(35, 1, 1, '2017-10-01', '100.00', NULL),
(42, 1, -1, '2017-10-03', '100.00', NULL),
(43, 2, -1, '2017-10-03', '1000.00', 1),
(44, 1, 1, '2017-10-03', '50.00', 1),
(45, 1, 1, '2017-10-03', '200.00', 1),
(46, 1, 1, '2017-10-04', '100.00', 1),
(47, 1, -1, '2017-10-04', '100.00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `savings_transaction_line`
--

CREATE TABLE `savings_transaction_line` (
  `savings_trans_line_id` int(11) NOT NULL,
  `savings_transaction_id` int(11) DEFAULT NULL,
  `account_log_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `savings_transaction_line`
--

INSERT INTO `savings_transaction_line` (`savings_trans_line_id`, `savings_transaction_id`, `account_log_id`) VALUES
(19, 42, 32),
(20, 42, 33),
(21, 43, 36),
(22, 43, 37),
(23, 44, 38),
(24, 44, 39),
(25, 45, 40),
(26, 45, 41),
(27, 46, 45),
(28, 46, 46),
(29, 47, 49),
(30, 47, 50);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `middle_name` varchar(45) DEFAULT NULL,
  `username` varchar(45) DEFAULT NULL,
  `password` varchar(45) DEFAULT NULL,
  `user_type` int(11) DEFAULT NULL,
  `user_status` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `last_name`, `first_name`, `middle_name`, `username`, `password`, `user_type`, `user_status`) VALUES
(1, 'Admin', 'Admin', NULL, 'admin', '1234', 0, 1),
(2, 'ta', 'tatta', 'tatt', 'rat', 'tata', 0, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `avg_daily_balance_log`
--
ALTER TABLE `avg_daily_balance_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `updated_by` (`updated_by`);

--
-- Indexes for table `capitals`
--
ALTER TABLE `capitals`
  ADD PRIMARY KEY (`capital_account_id`),
  ADD KEY `capitals_members_idx` (`member_id`);

--
-- Indexes for table `capitals_balance_log`
--
ALTER TABLE `capitals_balance_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `capital_account_id` (`capital_account_id`);

--
-- Indexes for table `capitals_transaction`
--
ALTER TABLE `capitals_transaction`
  ADD PRIMARY KEY (`capital_transaction_id`),
  ADD KEY `captrans_capitals_idx` (`capital_account_id`),
  ADD KEY `capital_encodedby_idx` (`encoded_by`);

--
-- Indexes for table `capitals_transaction_line`
--
ALTER TABLE `capitals_transaction_line`
  ADD PRIMARY KEY (`capital_trans_line_id`),
  ADD KEY `capital_transaction_id` (`capital_transaction_id`),
  ADD KEY `account_code` (`account_log_id`);

--
-- Indexes for table `capital_general_log`
--
ALTER TABLE `capital_general_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `updated_by` (`updated_by`);

--
-- Indexes for table `chart_of_accounts`
--
ALTER TABLE `chart_of_accounts`
  ADD PRIMARY KEY (`code`);

--
-- Indexes for table `chart_of_accounts_log`
--
ALTER TABLE `chart_of_accounts_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `code` (`code`),
  ADD KEY `encoded_by` (`encoded_by`);

--
-- Indexes for table `comakers`
--
ALTER TABLE `comakers`
  ADD PRIMARY KEY (`comaker_id`),
  ADD KEY `comaker_loan_idx` (`loan_id`);

--
-- Indexes for table `interest_rate_log`
--
ALTER TABLE `interest_rate_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `updated_by` (`updated_by`);

--
-- Indexes for table `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`loan_account_id`),
  ADD KEY `loan_member_idx` (`member_id`);

--
-- Indexes for table `loan_balance_log`
--
ALTER TABLE `loan_balance_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loan_account_id` (`loan_account_id`);

--
-- Indexes for table `loan_transaction`
--
ALTER TABLE `loan_transaction`
  ADD PRIMARY KEY (`loan_transaction_id`),
  ADD KEY `loantrans_loan_idx` (`loan_account_id`),
  ADD KEY `loan_encoded_by_idx` (`encoded_by`);

--
-- Indexes for table `loan_transaction_line`
--
ALTER TABLE `loan_transaction_line`
  ADD PRIMARY KEY (`loan_trans_line_id`),
  ADD KEY `loan_transaction_id` (`loan_transaction_id`),
  ADD KEY `account_code` (`account_log_id`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`member_id`);

--
-- Indexes for table `savings`
--
ALTER TABLE `savings`
  ADD PRIMARY KEY (`savings_account_id`),
  ADD KEY `savings_member_idx` (`member_id`);

--
-- Indexes for table `savings_balance_log`
--
ALTER TABLE `savings_balance_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `savings_account_id` (`savings_account_id`);

--
-- Indexes for table `savings_transaction`
--
ALTER TABLE `savings_transaction`
  ADD PRIMARY KEY (`savings_transaction_id`),
  ADD KEY `savtrans_savings_idx` (`savings_account_id`),
  ADD KEY `savings_encodedby_idx` (`encoded_by`);

--
-- Indexes for table `savings_transaction_line`
--
ALTER TABLE `savings_transaction_line`
  ADD PRIMARY KEY (`savings_trans_line_id`),
  ADD KEY `savings_transaction_id` (`savings_transaction_id`),
  ADD KEY `account_code` (`account_log_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `avg_daily_balance_log`
--
ALTER TABLE `avg_daily_balance_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `capitals`
--
ALTER TABLE `capitals`
  MODIFY `capital_account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `capitals_balance_log`
--
ALTER TABLE `capitals_balance_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `capitals_transaction`
--
ALTER TABLE `capitals_transaction`
  MODIFY `capital_transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `capitals_transaction_line`
--
ALTER TABLE `capitals_transaction_line`
  MODIFY `capital_trans_line_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `capital_general_log`
--
ALTER TABLE `capital_general_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `chart_of_accounts`
--
ALTER TABLE `chart_of_accounts`
  MODIFY `code` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT for table `chart_of_accounts_log`
--
ALTER TABLE `chart_of_accounts_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `comakers`
--
ALTER TABLE `comakers`
  MODIFY `comaker_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `interest_rate_log`
--
ALTER TABLE `interest_rate_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `loans`
--
ALTER TABLE `loans`
  MODIFY `loan_account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `loan_balance_log`
--
ALTER TABLE `loan_balance_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `loan_transaction`
--
ALTER TABLE `loan_transaction`
  MODIFY `loan_transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `loan_transaction_line`
--
ALTER TABLE `loan_transaction_line`
  MODIFY `loan_trans_line_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `member_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `savings`
--
ALTER TABLE `savings`
  MODIFY `savings_account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `savings_balance_log`
--
ALTER TABLE `savings_balance_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `savings_transaction`
--
ALTER TABLE `savings_transaction`
  MODIFY `savings_transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `savings_transaction_line`
--
ALTER TABLE `savings_transaction_line`
  MODIFY `savings_trans_line_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `avg_daily_balance_log`
--
ALTER TABLE `avg_daily_balance_log`
  ADD CONSTRAINT `fk_avgdailybalance_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `capitals`
--
ALTER TABLE `capitals`
  ADD CONSTRAINT `capitals_members` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `capitals_balance_log`
--
ALTER TABLE `capitals_balance_log`
  ADD CONSTRAINT `fk_capital_account_balance` FOREIGN KEY (`capital_account_id`) REFERENCES `capitals` (`capital_account_id`);

--
-- Constraints for table `capitals_transaction`
--
ALTER TABLE `capitals_transaction`
  ADD CONSTRAINT `capital_encodedby` FOREIGN KEY (`encoded_by`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `captrans_capitals` FOREIGN KEY (`capital_account_id`) REFERENCES `capitals` (`capital_account_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `capitals_transaction_line`
--
ALTER TABLE `capitals_transaction_line`
  ADD CONSTRAINT `fk_capital_particular` FOREIGN KEY (`account_log_id`) REFERENCES `chart_of_accounts_log` (`id`),
  ADD CONSTRAINT `fk_capital_transaction` FOREIGN KEY (`capital_transaction_id`) REFERENCES `capitals_transaction` (`capital_transaction_id`);

--
-- Constraints for table `capital_general_log`
--
ALTER TABLE `capital_general_log`
  ADD CONSTRAINT `fk_capital_updated` FOREIGN KEY (`updated_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `chart_of_accounts_log`
--
ALTER TABLE `chart_of_accounts_log`
  ADD CONSTRAINT `fk_account_code_log` FOREIGN KEY (`code`) REFERENCES `chart_of_accounts` (`code`),
  ADD CONSTRAINT `fk_particular_encoded` FOREIGN KEY (`encoded_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `comakers`
--
ALTER TABLE `comakers`
  ADD CONSTRAINT `comaker_loan` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`loan_account_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `interest_rate_log`
--
ALTER TABLE `interest_rate_log`
  ADD CONSTRAINT `fk_interest_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `loans`
--
ALTER TABLE `loans`
  ADD CONSTRAINT `loan_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `loan_balance_log`
--
ALTER TABLE `loan_balance_log`
  ADD CONSTRAINT `fk_loan_balancelog_account` FOREIGN KEY (`loan_account_id`) REFERENCES `loans` (`loan_account_id`);

--
-- Constraints for table `loan_transaction`
--
ALTER TABLE `loan_transaction`
  ADD CONSTRAINT `loan_encoded_by` FOREIGN KEY (`encoded_by`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `loantrans_loan` FOREIGN KEY (`loan_account_id`) REFERENCES `loans` (`loan_account_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `loan_transaction_line`
--
ALTER TABLE `loan_transaction_line`
  ADD CONSTRAINT `fk_loan_particular` FOREIGN KEY (`account_log_id`) REFERENCES `chart_of_accounts_log` (`id`),
  ADD CONSTRAINT `fk_loan_transaction` FOREIGN KEY (`loan_transaction_id`) REFERENCES `loan_transaction` (`loan_transaction_id`);

--
-- Constraints for table `savings`
--
ALTER TABLE `savings`
  ADD CONSTRAINT `savings_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `savings_balance_log`
--
ALTER TABLE `savings_balance_log`
  ADD CONSTRAINT `fk_sav_balancelog_account` FOREIGN KEY (`savings_account_id`) REFERENCES `savings` (`savings_account_id`);

--
-- Constraints for table `savings_transaction`
--
ALTER TABLE `savings_transaction`
  ADD CONSTRAINT `savings_encodedby` FOREIGN KEY (`encoded_by`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `savtrans_savings` FOREIGN KEY (`savings_account_id`) REFERENCES `savings` (`savings_account_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `savings_transaction_line`
--
ALTER TABLE `savings_transaction_line`
  ADD CONSTRAINT `fk_savings_particular` FOREIGN KEY (`account_log_id`) REFERENCES `chart_of_accounts_log` (`id`),
  ADD CONSTRAINT `fk_savings_transaction` FOREIGN KEY (`savings_transaction_id`) REFERENCES `savings_transaction` (`savings_transaction_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
