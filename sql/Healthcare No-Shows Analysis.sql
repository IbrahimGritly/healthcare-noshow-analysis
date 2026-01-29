CREATE DATABASE healthcare_analytics;
USE healthcare_analytics;

CREATE TABLE appointments (
    patient_id           VARCHAR(50),
    appointment_id        BIGINT PRIMARY KEY,
    gender                CHAR(1),
    scheduled_day         DATETIME,
    appointment_day       DATETIME,
    age                   INT,
    neighbourhood         VARCHAR(100),
    scholarship           TINYINT,
    hipertension          TINYINT,
    diabetes              TINYINT,
    alcoholism            TINYINT,
    handcap               TINYINT,
    sms_received          TINYINT,
    no_show               VARCHAR(3),
    scheduled_date        DATE,
    appointment_date      DATE,
    waiting_days          INT,
    appointment_weekday   VARCHAR(15),
    appointment_month     INT,
    has_disability        TINYINT,
    no_show_flag          TINYINT,
    age_group             VARCHAR(30),
    wait_time_group       VARCHAR(30),
    high_risk_no_show     TINYINT
);


SELECT * FROM appointments LIMIT 5;
SELECT COUNT(*) AS total_appointments FROM appointments;



-- Why gender / diabetes / alcoholism looked “flat”
-- “Demographic and clinical variables such as gender, diabetes, and alcoholism showed minimal variation in no-show rates.
-- However, neighbourhood-level analysis revealed meaningful differences, suggesting that geographic and socioeconomic factors may play a stronger role in appointment adherence than individual medical conditions.”
-- 📌 This is a great insight to explicitly mention in your report.

-- how many patients showed vs didnt out of total appointments
SELECT no_show, COUNT(*) AS count 
FROM appointments 
GROUP BY no_show;

-- Overall no show rate
SELECT ROUND(AVG(no_show_flag), 2) AS no_show_rate
FROM appointments;


-- Does receiving an sms help decrease no show rate?
SELECT sms_received, COUNT(*) AS total_appointments, ROUND(AVG(no_show_flag) * 100, 2) AS no_show_rate_percentage
FROM appointments
GROUP BY sms_received;


-- no show rate by number of disabilities
SELECT handcap, COUNT(*) AS total_appointments, ROUND(AVG(no_show_flag) * 100, 2)  AS no_show_rate
FROM appointments
GROUP BY handcap;


-- no show rate by wait time groups
SELECT wait_time_group, COUNT(*) AS total_appointments, ROUND(AVG(no_show_flag) * 100, 2) AS no_show_rate_percent
FROM appointments
GROUP BY wait_time_group
ORDER BY no_show_rate_percent DESC;


-- no show rate by age group
SELECT age_group, COUNT(*) AS total_appointments, ROUND(AVG(no_show_flag) * 100, 2) AS no_show_rate_percent
FROM appointments
GROUP BY age_group
ORDER BY no_show_rate_percent DESC;


-- compare high risk vs non high risk (high risk now show has higher no show rate)
SELECT high_risk_no_show, COUNT(*) AS total_appointments, ROUND(AVG(no_show_flag) * 100, 2) AS now_show_rate_percent
FROM appointments
GROUP BY high_risk_no_show;


-- neighbourhood
SELECT neighbourhood, COUNT(*) AS total_appointments, ROUND(AVG(no_show_flag) * 100, 2) AS no_show_rate_percent
FROM appointments
GROUP BY neighbourhood
HAVING COUNT(*) >= 500
ORDER BY no_show_rate_percent DESC;


-- neighbourhood x disability no show rates
SELECT
    neighbourhood,
    has_disability,
    COUNT(*) AS total_appointments,
    ROUND(AVG(no_show_flag) * 100, 2) AS no_show_rate_percent
FROM appointments
GROUP BY neighbourhood, has_disability
HAVING COUNT(*) >= 200
ORDER BY no_show_rate_percent DESC;


#####          SQL KPI VIEWS          #####

-- 1)Overall kpis
CREATE VIEW vw_overall_kpis AS
SELECT COUNT(*) AS total_appointments, SUM(no_show_flag) AS total_no_shows, 
	ROUND(AVG(no_show_flag) * 100, 2) AS no_show_rate_percent
FROM appointments;

SELECT * FROM vw_overall_kpis;


-- 2)No show rate by neighbourhood
CREATE OR REPLACE VIEW vw_neighbourhood_no_show AS
SELECT neighbourhood, COUNT(*) AS total_appointments, ROUND(AVG(no_show_flag) * 100, 2) AS no_show_rate_percent
FROM appointments
GROUP BY neighbourhood
HAVING COUNT(*) >= 500
ORDER BY no_show_rate_percent DESC;

SELECT * FROM vw_neighbourhood_no_show;


-- 3)SMS effectiveness
CREATE VIEW vw_sms_no_show AS
SELECT sms_received, COUNT(*) AS total_appointments, ROUND(AVG(no_show_flag) * 100, 2) AS no_show_rate_percent
FROM appointments
GROUP BY sms_received;

SELECT * FROM vw_sms_no_show;


-- 4)Wait Time Impact
CREATE VIEW vw_wait_time_no_show AS
SELECT wait_time_group, COUNT(*) AS total_appointments, ROUND(AVG(no_show_flag) * 100, 2) AS no_show_rate_percent
FROM appointments
GROUP BY wait_time_group;

SELECT * FROM vw_wait_time_no_show;


-- 5) Age Group No Show Rates
CREATE VIEW vw_age_group_no_show AS 
SELECT age_group, COUNT(*) AS total_appointments, ROUND(AVG(no_show_flag) * 100, 2) AS no_show_rate_percent
FROM appointments
GROUP BY age_group
ORDER BY no_show_rate_percent DESC;

SELECT * FROM vw_age_group_no_show;


-- 6) High Risk Validation
CREATE OR REPLACE VIEW v_high_risk_no_show AS
SELECT high_risk_no_show, COUNT(*) AS total_appointments, ROUND(AVG(no_show_flag) * 100, 2) AS no_show_rate_percent
FROM appointments
GROUP BY high_risk_no_show;

SELECT * FROM v_high_risk_no_show;


## KPI List ##

SELECT * FROM vw_overall_kpis;
SELECT * FROM vw_neighbourhood_no_show;
SELECT * FROM vw_sms_no_show;
SELECT * FROM vw_wait_time_no_show;
SELECT * FROM vw_age_group_no_show;
SELECT * FROM v_high_risk_no_show;





