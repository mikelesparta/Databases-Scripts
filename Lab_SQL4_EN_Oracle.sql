DROP TABLE BORROWER;
DROP TABLE ACCOUNTHOLDER;
DROP TABLE CUSTOMER;
DROP TABLE ACCOUNT;
DROP TABLE LOAN;
DROP TABLE BRANCH;


CREATE TABLE BRANCH(
BR_NAME VARCHAR(15) NOT NULL,
BR_CITY VARCHAR(15) NOT NULL,
ASSET DECIMAL(12,3) NOT NULL,
CONSTRAINT PK_BRANCH PRIMARY KEY(BR_NAME));

CREATE TABLE ACCOUNT(
ACC_NUMBER VARCHAR(15) NOT NULL,
BR_NAME VARCHAR(15) NOT NULL,
BALANCE DECIMAL(12,3) NOT NULL,
CONSTRAINT PK_ACCOUNT PRIMARY KEY(ACC_NUMBER),
CONSTRAINT FK_ACCOUNT_BRANCH FOREIGN KEY(BR_NAME) REFERENCES BRANCH(BR_NAME));

CREATE TABLE LOAN(
LO_NUMBER VARCHAR(15) NOT NULL,
BR_NAME VARCHAR(15) NOT NULL,
AMOUNT DECIMAL(12,3) NOT NULL,CONSTRAINT PK_LOAN PRIMARY KEY(LO_NUMBER),
CONSTRAINT FK_LOAN_BRANCH FOREIGN KEY(BR_NAME) REFERENCES BRANCH(BR_NAME));

CREATE TABLE CUSTOMER(CUS_NAME VARCHAR(15) NOT NULL,
CUS_STREET VARCHAR(12) NOT NULL,
CUS_CITY VARCHAR(15) NOT NULL,
CONSTRAINT PK_CUSTOMER PRIMARY KEY(CUS_NAME));

CREATE TABLE ACCOUNTHOLDER(CUS_NAME VARCHAR(15) NOT NULL,
ACC_NUMBER VARCHAR(15) NOT NULL,
CONSTRAINT PK_ACCOUNTHOLDER PRIMARY KEY(CUS_NAME,ACC_NUMBER),
CONSTRAINT FK_ACCOUNTHOLDER_CUSTOMER FOREIGN KEY(CUS_NAME) REFERENCES CUSTOMER(CUS_NAME),
CONSTRAINT FK_ACCOUNTHOLDER_ACCOUNT FOREIGN KEY(ACC_NUMBER) REFERENCES ACCOUNT(ACC_NUMBER));

CREATE TABLE BORROWER(CUS_NAME VARCHAR(15) NOT NULL,
LO_NUMBER VARCHAR(15) NOT NULL,
CONSTRAINT PK_BORROWER PRIMARY KEY(CUS_NAME,LO_NUMBER),
CONSTRAINT FK_BORROWER_CUSTOMER FOREIGN KEY(CUS_NAME) REFERENCES CUSTOMER(CUS_NAME),
CONSTRAINT FK_BORROWER_LOAN FOREIGN KEY(LO_NUMBER) REFERENCES LOAN(LO_NUMBER));

INSERT INTO "BRANCH" VALUES('Brighton','Brooklyn',7000000.000);
INSERT INTO "BRANCH" VALUES('Central','Rye',400280.000);
INSERT INTO "BRANCH" VALUES('Downtown','Brooklyn',900000.000);
INSERT INTO "BRANCH" VALUES('Mianus','Horseneck',400200.000);
INSERT INTO "BRANCH" VALUES('North Town','Rye',3700000.000);
INSERT INTO "BRANCH" VALUES('Perryridge','Horseneck',1700000.000);
INSERT INTO "BRANCH" VALUES('Pownal','Bennington',400000.000);
INSERT INTO "BRANCH" VALUES('Redwood','Palo Alto',2100000.000);
INSERT INTO "BRANCH" VALUES('Round Hill','Horseneck',8000000.000);
INSERT INTO "ACCOUNT" VALUES('A-101','Downtown',500.000);
INSERT INTO "ACCOUNT" VALUES('A-102','Perryridge',400.000);
INSERT INTO "ACCOUNT" VALUES('A-201','Perryridge',900.000);
INSERT INTO "ACCOUNT" VALUES('A-215','Mianus',700.000);
INSERT INTO "ACCOUNT" VALUES('A-217','Brighton',750.000);
INSERT INTO "ACCOUNT" VALUES('A-222','Redwood',700.000);
INSERT INTO "ACCOUNT" VALUES('A-305','Round Hill',350.000);
INSERT INTO "ACCOUNT" VALUES('A-333','Central',850.000);
INSERT INTO "ACCOUNT" VALUES('A-444','North Town',625.000);
INSERT INTO "LOAN" VALUES('L-11','Round Hill',900.000);
INSERT INTO "LOAN" VALUES('L-14','Downtown',1500.000);
INSERT INTO "LOAN" VALUES('L-15','Perryridge',1500.000);
INSERT INTO "LOAN" VALUES('L-16','Perryridge',1300.000);
INSERT INTO "LOAN" VALUES('L-17','Downtown',1000.000);
INSERT INTO "LOAN" VALUES('L-20','North Town',7500.000);
INSERT INTO "LOAN" VALUES('L-21','Central',570.000);
INSERT INTO "LOAN" VALUES('L-23','Redwood',2000.000);
INSERT INTO "LOAN" VALUES('L-93','Mianus',500.000);
INSERT INTO "CUSTOMER" VALUES('Adams','Spring','Pittsfield');
INSERT INTO "CUSTOMER" VALUES('Brooks','Senator','Brooklyn');
INSERT INTO "CUSTOMER" VALUES('Curry','North','Rye');
INSERT INTO "CUSTOMER" VALUES('Glenn','Sand Hill','Woodside');
INSERT INTO "CUSTOMER" VALUES('Green','Walnut','Stamford');
INSERT INTO "CUSTOMER" VALUES('Hayes','Main','Harrison');
INSERT INTO "CUSTOMER" VALUES('Jackson','University','Salt Lake');
INSERT INTO "CUSTOMER" VALUES('Johnson','Alma','Palo Alto');
INSERT INTO "CUSTOMER" VALUES('Jones','Main','Harrison');
INSERT INTO "CUSTOMER" VALUES('Lindsay','Park','Pittsfield');
INSERT INTO "CUSTOMER" VALUES('Majeris','First','Rye');
INSERT INTO "CUSTOMER" VALUES('McBride','Safety','Rye');
INSERT INTO "CUSTOMER" VALUES('Smith','Main','Rye');
INSERT INTO "CUSTOMER" VALUES('Turner','Putnam','Stamford');
INSERT INTO "CUSTOMER" VALUES('Williams','Nassau','Princeton');
INSERT INTO "ACCOUNTHOLDER" VALUES('Hayes','A-101');
INSERT INTO "ACCOUNTHOLDER" VALUES('Hayes','A-102');
INSERT INTO "ACCOUNTHOLDER" VALUES('Johnson','A-101');
INSERT INTO "ACCOUNTHOLDER" VALUES('Johnson','A-201');
INSERT INTO "ACCOUNTHOLDER" VALUES('Jones','A-217');
INSERT INTO "ACCOUNTHOLDER" VALUES('Lindsay','A-222');
INSERT INTO "ACCOUNTHOLDER" VALUES('Majeris','A-333');
INSERT INTO "ACCOUNTHOLDER" VALUES('Smith','A-215');
INSERT INTO "ACCOUNTHOLDER" VALUES('Smith','A-444');
INSERT INTO "ACCOUNTHOLDER" VALUES('Turner','A-305');
INSERT INTO "BORROWER" VALUES('Adams','L-16');
INSERT INTO "BORROWER" VALUES('Curry','L-93');
INSERT INTO "BORROWER" VALUES('Hayes','L-15');
INSERT INTO "BORROWER" VALUES('Jackson','L-14');
INSERT INTO "BORROWER" VALUES('Jones','L-17');
INSERT INTO "BORROWER" VALUES('McBride','L-20');
INSERT INTO "BORROWER" VALUES('Smith','L-11');
INSERT INTO "BORROWER" VALUES('Smith','L-21');
INSERT INTO "BORROWER" VALUES('Smith','L-23');
INSERT INTO "BORROWER" VALUES('Williams','L-17');
COMMIT;
