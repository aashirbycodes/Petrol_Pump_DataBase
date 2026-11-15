DROP DATABASE IF EXISTS petrol_pump_db;
CREATE DATABASE petrol_pump_db;
USE petrol_pump_db;


CREATE TABLE Customer (
 Customer_ID INT PRIMARY KEY, 
 First_Name VARCHAR(40) NOT NULL, 
 Last_Name VARCHAR(40) NOT NULL,
 CNIC CHAR(15) NOT NULL UNIQUE, 
 Phone VARCHAR(20) NOT NULL, 
 Email VARCHAR(100) UNIQUE,
 Address VARCHAR(150), 
 City VARCHAR(50), 
 Registration_Date DATE NOT NULL,
 Loyalty_Points INT NOT NULL DEFAULT 0 CHECK (Loyalty_Points >= 0)
);
CREATE TABLE Employee (
 Employee_ID INT PRIMARY KEY, 
 First_Name VARCHAR(40) NOT NULL, 
 Last_Name VARCHAR(40) NOT NULL,
 CNIC CHAR(15) NOT NULL UNIQUE, 
 Phone VARCHAR(20) NOT NULL, Email VARCHAR(100) NOT NULL UNIQUE,
 Address VARCHAR(150), 
 Gender VARCHAR(10) CHECK (Gender IN ('Male','Female','Other')),
 Salary DECIMAL(10,2) NOT NULL CHECK (Salary > 0), 
 Joining_Date DATE NOT NULL
);
CREATE TABLE Manager (
 Employee_ID INT PRIMARY KEY, 
 Management_Level VARCHAR(30) NOT NULL,
 FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);
CREATE TABLE Cashier (
 Employee_ID INT PRIMARY KEY, 
 Cash_Register_No VARCHAR(20) NOT NULL UNIQUE,
 FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);
CREATE TABLE Cleaner (
 Employee_ID INT PRIMARY KEY, 
 Assigned_Shift VARCHAR(20) NOT NULL,
 FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);
CREATE TABLE Fuel (
 Fuel_ID INT PRIMARY KEY, 
 Fuel_Name VARCHAR(40) NOT NULL, 
 Fuel_Type VARCHAR(30) NOT NULL,
 Price_Per_Litre DECIMAL(8,2) NOT NULL CHECK (Price_Per_Litre > 0),
 Octane_Rating DECIMAL(5,2), Density DECIMAL(6,3),
 Current_Stock DECIMAL(12,2) NOT NULL CHECK (Current_Stock >= 0),
 Minimum_Stock DECIMAL(12,2) NOT NULL DEFAULT 0,
 Maximum_Stock DECIMAL(12,2) NOT NULL,
 Last_Price_Update DATE NOT NULL,
 CHECK (Minimum_Stock >= 0 AND Maximum_Stock >= Minimum_Stock AND Current_Stock <= Maximum_Stock)
);
CREATE TABLE Fuel_Tank (
 Tank_ID INT PRIMARY KEY, 
 Tank_Name VARCHAR(50) NOT NULL, 
 Fuel_ID INT NOT NULL,
 Capacity DECIMAL(12,2) NOT NULL CHECK (Capacity > 0),
 Current_Level DECIMAL(12,2) NOT NULL CHECK (Current_Level >= 0),
 Installation_Date DATE NOT NULL, 
 Tank_Location VARCHAR(100), 
 Tank_Material VARCHAR(40),
 Last_Inspection DATE, 
 Tank_Status VARCHAR(20) NOT NULL DEFAULT 'Active',
 CHECK (Current_Level <= Capacity),
 FOREIGN KEY (Fuel_ID) REFERENCES Fuel(Fuel_ID)
);
CREATE TABLE Fuel_Dispenser (
 Dispenser_ID INT PRIMARY KEY, 
 Dispenser_Name VARCHAR(50) NOT NULL, 
 Tank_ID INT NOT NULL,
 Fuel_ID INT NOT NULL, 
 Model VARCHAR(50), 
 Manufacturer VARCHAR(50), 
 Installation_Date DATE,
 Meter_Reading DECIMAL(14,2) NOT NULL DEFAULT 0, 
 Dispenser_Status VARCHAR(20) DEFAULT 'Active',
 Last_Maintenance DATE,
 FOREIGN KEY (Tank_ID) REFERENCES Fuel_Tank(Tank_ID),
 FOREIGN KEY (Fuel_ID) REFERENCES Fuel(Fuel_ID)
);
CREATE TABLE Supplier (
 Supplier_ID INT PRIMARY KEY, 
 Supplier_Name VARCHAR(80) NOT NULL, 
 Company_Name VARCHAR(100),
 NTN VARCHAR(30) NOT NULL UNIQUE, 
 Contact_Number VARCHAR(20), 
 Email VARCHAR(100) UNIQUE,
 Address VARCHAR(150), 
 City VARCHAR(50), Registration_Date DATE NOT NULL,
 Supplier_Status VARCHAR(20) NOT NULL DEFAULT 'Active'
);
CREATE TABLE Fuel_Purchase (
 Purchase_ID INT PRIMARY KEY, 
 Supplier_ID INT NOT NULL, 
 Fuel_ID INT NOT NULL, 
 Tank_ID INT NOT NULL,
 Purchase_Date DATE NOT NULL, 
 Purchase_Time TIME NOT NULL, 
 Quantity DECIMAL(12,2) NOT NULL CHECK (Quantity > 0),
 Unit_Price DECIMAL(8,2) NOT NULL CHECK (Unit_Price > 0),
 Total_Cost DECIMAL(14,2) GENERATED ALWAYS AS (Quantity * Unit_Price) STORED,
 Invoice_Number VARCHAR(40) NOT NULL UNIQUE,
 FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID),
 FOREIGN KEY (Fuel_ID) REFERENCES Fuel(Fuel_ID),
 FOREIGN KEY (Tank_ID) REFERENCES Fuel_Tank(Tank_ID)
);
CREATE TABLE Sale_Transaction (
 Sale_ID INT PRIMARY KEY, 
 Customer_ID INT NOT NULL, 
 Employee_ID INT NOT NULL, 
 Fuel_ID INT NOT NULL,
 Dispenser_ID INT NOT NULL, 
 Sale_Date DATE NOT NULL, 
 Sale_Time TIME NOT NULL,
 Quantity DECIMAL(10,2) NOT NULL CHECK (Quantity > 0),
 Price_Per_Litre DECIMAL(8,2) NOT NULL CHECK (Price_Per_Litre > 0),
 Total_Amount DECIMAL(14,2) GENERATED ALWAYS AS (Quantity * Price_Per_Litre) STORED,
 FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
 FOREIGN KEY (Employee_ID) REFERENCES Cashier(Employee_ID),
 FOREIGN KEY (Fuel_ID) REFERENCES Fuel(Fuel_ID),
 FOREIGN KEY (Dispenser_ID) REFERENCES Fuel_Dispenser(Dispenser_ID)
);
CREATE TABLE Payment (
 Payment_ID INT PRIMARY KEY, 
 Sale_ID INT NOT NULL, 
 Payment_Method VARCHAR(20) NOT NULL,
 Payment_Amount DECIMAL(14,2) NOT NULL CHECK (Payment_Amount > 0),
 Payment_Date DATE NOT NULL, 
 Payment_Time TIME NOT NULL,
 Transaction_Reference VARCHAR(50) UNIQUE, 
 Payment_Status VARCHAR(20) NOT NULL DEFAULT 'Completed',
 Card_Last_Four CHAR(4), 
 Remarks VARCHAR(150),
 FOREIGN KEY (Sale_ID) REFERENCES Sale_Transaction(Sale_ID)
);
CREATE TABLE Vehicle (
 Vehicle_ID INT PRIMARY KEY, 
 Customer_ID INT NOT NULL, 
 Registration_Number VARCHAR(30) NOT NULL UNIQUE,
 Vehicle_Type VARCHAR(30), 
 Manufacturer VARCHAR(40), 
 Model VARCHAR(40),
 Manufacturing_Year YEAR, 
 Color VARCHAR(30), 
 Engine_Capacity INT,
 Registration_Date DATE,
 FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);
CREATE TABLE Cleaning_Activity (
 Cleaning_ID INT PRIMARY KEY, 
 Employee_ID INT NOT NULL, 
 Area_Name VARCHAR(60) NOT NULL,
 Cleaning_Type VARCHAR(40), 
 Cleaning_Date DATE NOT NULL, 
 Cleaning_Time TIME NOT NULL,
 Completion_Status VARCHAR(20) DEFAULT 'Pending', 
 Inspection_Status VARCHAR(20) DEFAULT 'Pending',
 Remarks VARCHAR(150), 
 Scheduled_Duration_Minutes INT NOT NULL DEFAULT 30 CHECK (Scheduled_Duration_Minutes > 0),
 FOREIGN KEY (Employee_ID) REFERENCES Cleaner(Employee_ID)
);

SHOW TABLES;



INSERT INTO Customer VALUES (1,'Customer1','Family1','3520213000001','03000000001','customer1@mail.com','House 1, Street 1','Lahore','2025-01-01',5);
INSERT INTO Customer VALUES (2,'Customer2','Family2','3520213000002','03000000002','customer2@mail.com','House 2, Street 2','Lahore','2025-01-02',10);
INSERT INTO Customer VALUES (3,'Customer3','Family3','3520213000003','03000000003','customer3@mail.com','House 3, Street 3','Lahore','2025-01-03',15);
INSERT INTO Customer VALUES (4,'Customer4','Family4','3520213000004','03000000004','customer4@mail.com','House 4, Street 4','Lahore','2025-01-04',20);
INSERT INTO Customer VALUES (5,'Customer5','Family5','3520213000005','03000000005','customer5@mail.com','House 5, Street 5','Lahore','2025-01-05',25);
INSERT INTO Customer VALUES (6,'Customer6','Family6','3520213000006','03000000006','customer6@mail.com','House 6, Street 6','Lahore','2025-01-06',30);
INSERT INTO Customer VALUES (7,'Customer7','Family7','3520213000007','03000000007','customer7@mail.com','House 7, Street 7','Lahore','2025-01-07',35);
INSERT INTO Customer VALUES (8,'Customer8','Family8','3520213000008','03000000008','customer8@mail.com','House 8, Street 8','Lahore','2025-01-08',40);
INSERT INTO Customer VALUES (9,'Customer9','Family9','3520213000009','03000000009','customer9@mail.com','House 9, Street 9','Lahore','2025-01-09',45);
INSERT INTO Customer VALUES (10,'Customer10','Family10','3520213000010','03000000010','customer10@mail.com','House 10, Street 10','Lahore','2025-01-10',50);
INSERT INTO Customer VALUES (11,'Customer11','Family11','3520213000011','03000000011','customer11@mail.com','House 11, Street 11','Lahore','2025-01-11',55);
INSERT INTO Customer VALUES (12,'Customer12','Family12','3520213000012','03000000012','customer12@mail.com','House 12, Street 12','Lahore','2025-01-12',60);
INSERT INTO Customer VALUES (13,'Customer13','Family13','3520213000013','03000000013','customer13@mail.com','House 13, Street 13','Lahore','2025-01-13',65);
INSERT INTO Customer VALUES (14,'Customer14','Family14','3520213000014','03000000014','customer14@mail.com','House 14, Street 14','Lahore','2025-01-14',70);
INSERT INTO Customer VALUES (15,'Customer15','Family15','3520213000015','03000000015','customer15@mail.com','House 15, Street 15','Lahore','2025-01-15',75);
INSERT INTO Customer VALUES (16,'Customer16','Family16','3520213000016','03000000016','customer16@mail.com','House 16, Street 16','Lahore','2025-01-16',80);
INSERT INTO Customer VALUES (17,'Customer17','Family17','3520213000017','03000000017','customer17@mail.com','House 17, Street 17','Lahore','2025-01-17',85);
INSERT INTO Customer VALUES (18,'Customer18','Family18','3520213000018','03000000018','customer18@mail.com','House 18, Street 18','Lahore','2025-01-18',90);
INSERT INTO Customer VALUES (19,'Customer19','Family19','3520213000019','03000000019','customer19@mail.com','House 19, Street 19','Lahore','2025-01-19',95);
INSERT INTO Customer VALUES (20,'Customer20','Family20','3520213000020','03000000020','customer20@mail.com','House 20, Street 20','Lahore','2025-01-20',100);
INSERT INTO Customer VALUES (21,'Customer21','Family21','3520213000021','03000000021','customer21@mail.com','House 21, Street 21','Lahore','2025-01-21',105);
INSERT INTO Customer VALUES (22,'Customer22','Family22','3520213000022','03000000022','customer22@mail.com','House 22, Street 22','Lahore','2025-01-22',110);
INSERT INTO Customer VALUES (23,'Customer23','Family23','3520213000023','03000000023','customer23@mail.com','House 23, Street 23','Lahore','2025-01-23',115);
INSERT INTO Customer VALUES (24,'Customer24','Family24','3520213000024','03000000024','customer24@mail.com','House 24, Street 24','Lahore','2025-01-24',120);
INSERT INTO Customer VALUES (25,'Customer25','Family25','3520213000025','03000000025','customer25@mail.com','House 25, Street 25','Lahore','2025-01-25',125);
INSERT INTO Customer VALUES (26,'Customer26','Family26','3520213000026','03000000026','customer26@mail.com','House 26, Street 26','Lahore','2025-01-26',130);
INSERT INTO Customer VALUES (27,'Customer27','Family27','3520213000027','03000000027','customer27@mail.com','House 27, Street 27','Lahore','2025-01-27',135);
INSERT INTO Customer VALUES (28,'Customer28','Family28','3520213000028','03000000028','customer28@mail.com','House 28, Street 28','Lahore','2025-01-28',140);
INSERT INTO Customer VALUES (29,'Customer29','Family29','3520213000029','03000000029','customer29@mail.com','House 29, Street 29','Lahore','2025-02-01',145);
INSERT INTO Customer VALUES (30,'Customer30','Family30','3520213000030','03000000030','customer30@mail.com','House 30, Street 30','Lahore','2025-02-02',150);
INSERT INTO Employee VALUES (1,'Employee1','Staff1','3520214000001','03110000001','employee1@petrol.com','Street 1, Lahore','Male',31500,'2024-01-01');
INSERT INTO Employee VALUES (2,'Employee2','Staff2','3520214000002','03110000002','employee2@petrol.com','Street 2, Lahore','Female',33000,'2024-01-02');
INSERT INTO Employee VALUES (3,'Employee3','Staff3','3520214000003','03110000003','employee3@petrol.com','Street 3, Lahore','Male',34500,'2024-01-03');
INSERT INTO Employee VALUES (4,'Employee4','Staff4','3520214000004','03110000004','employee4@petrol.com','Street 4, Lahore','Female',36000,'2024-01-04');
INSERT INTO Employee VALUES (5,'Employee5','Staff5','3520214000005','03110000005','employee5@petrol.com','Street 5, Lahore','Male',37500,'2024-01-05');
INSERT INTO Employee VALUES (6,'Employee6','Staff6','3520214000006','03110000006','employee6@petrol.com','Street 6, Lahore','Female',39000,'2024-01-06');
INSERT INTO Employee VALUES (7,'Employee7','Staff7','3520214000007','03110000007','employee7@petrol.com','Street 7, Lahore','Male',40500,'2024-01-07');
INSERT INTO Employee VALUES (8,'Employee8','Staff8','3520214000008','03110000008','employee8@petrol.com','Street 8, Lahore','Female',42000,'2024-01-08');
INSERT INTO Employee VALUES (9,'Employee9','Staff9','3520214000009','03110000009','employee9@petrol.com','Street 9, Lahore','Male',43500,'2024-01-09');
INSERT INTO Employee VALUES (10,'Employee10','Staff10','3520214000010','03110000010','employee10@petrol.com','Street 10, Lahore','Female',45000,'2024-01-10');
INSERT INTO Employee VALUES (11,'Employee11','Staff11','3520214000011','03110000011','employee11@petrol.com','Street 11, Lahore','Male',46500,'2024-01-11');
INSERT INTO Employee VALUES (12,'Employee12','Staff12','3520214000012','03110000012','employee12@petrol.com','Street 12, Lahore','Female',48000,'2024-01-12');
INSERT INTO Employee VALUES (13,'Employee13','Staff13','3520214000013','03110000013','employee13@petrol.com','Street 13, Lahore','Male',49500,'2024-01-13');
INSERT INTO Employee VALUES (14,'Employee14','Staff14','3520214000014','03110000014','employee14@petrol.com','Street 14, Lahore','Female',51000,'2024-01-14');
INSERT INTO Employee VALUES (15,'Employee15','Staff15','3520214000015','03110000015','employee15@petrol.com','Street 15, Lahore','Male',52500,'2024-01-15');
INSERT INTO Employee VALUES (16,'Employee16','Staff16','3520214000016','03110000016','employee16@petrol.com','Street 16, Lahore','Female',54000,'2024-01-16');
INSERT INTO Employee VALUES (17,'Employee17','Staff17','3520214000017','03110000017','employee17@petrol.com','Street 17, Lahore','Male',55500,'2024-01-17');
INSERT INTO Employee VALUES (18,'Employee18','Staff18','3520214000018','03110000018','employee18@petrol.com','Street 18, Lahore','Female',57000,'2024-01-18');
INSERT INTO Employee VALUES (19,'Employee19','Staff19','3520214000019','03110000019','employee19@petrol.com','Street 19, Lahore','Male',58500,'2024-01-19');
INSERT INTO Employee VALUES (20,'Employee20','Staff20','3520214000020','03110000020','employee20@petrol.com','Street 20, Lahore','Female',60000,'2024-01-20');
INSERT INTO Employee VALUES (21,'Employee21','Staff21','3520214000021','03110000021','employee21@petrol.com','Street 21, Lahore','Male',61500,'2024-01-21');
INSERT INTO Employee VALUES (22,'Employee22','Staff22','3520214000022','03110000022','employee22@petrol.com','Street 22, Lahore','Female',63000,'2024-01-22');
INSERT INTO Employee VALUES (23,'Employee23','Staff23','3520214000023','03110000023','employee23@petrol.com','Street 23, Lahore','Male',64500,'2024-01-23');
INSERT INTO Employee VALUES (24,'Employee24','Staff24','3520214000024','03110000024','employee24@petrol.com','Street 24, Lahore','Female',66000,'2024-01-24');
INSERT INTO Employee VALUES (25,'Employee25','Staff25','3520214000025','03110000025','employee25@petrol.com','Street 25, Lahore','Male',67500,'2024-01-25');
INSERT INTO Employee VALUES (26,'Employee26','Staff26','3520214000026','03110000026','employee26@petrol.com','Street 26, Lahore','Female',69000,'2024-01-26');
INSERT INTO Employee VALUES (27,'Employee27','Staff27','3520214000027','03110000027','employee27@petrol.com','Street 27, Lahore','Male',70500,'2024-01-27');
INSERT INTO Employee VALUES (28,'Employee28','Staff28','3520214000028','03110000028','employee28@petrol.com','Street 28, Lahore','Female',72000,'2024-01-28');
INSERT INTO Employee VALUES (29,'Employee29','Staff29','3520214000029','03110000029','employee29@petrol.com','Street 29, Lahore','Male',73500,'2024-02-01');
INSERT INTO Employee VALUES (30,'Employee30','Staff30','3520214000030','03110000030','employee30@petrol.com','Street 30, Lahore','Female',75000,'2024-02-02');
INSERT INTO Manager VALUES (1,'Level 2');
INSERT INTO Manager VALUES (2,'Level 3');
INSERT INTO Manager VALUES (3,'Level 1');
INSERT INTO Manager VALUES (4,'Level 2');
INSERT INTO Manager VALUES (5,'Level 3');
INSERT INTO Manager VALUES (6,'Level 1');
INSERT INTO Manager VALUES (7,'Level 2');
INSERT INTO Manager VALUES (8,'Level 3');
INSERT INTO Manager VALUES (9,'Level 1');
INSERT INTO Manager VALUES (10,'Level 2');
INSERT INTO Cashier VALUES (11,'REG-11');
INSERT INTO Cashier VALUES (12,'REG-12');
INSERT INTO Cashier VALUES (13,'REG-13');
INSERT INTO Cashier VALUES (14,'REG-14');
INSERT INTO Cashier VALUES (15,'REG-15');
INSERT INTO Cashier VALUES (16,'REG-16');
INSERT INTO Cashier VALUES (17,'REG-17');
INSERT INTO Cashier VALUES (18,'REG-18');
INSERT INTO Cashier VALUES (19,'REG-19');
INSERT INTO Cashier VALUES (20,'REG-20');
INSERT INTO Cleaner VALUES (21,'Morning');
INSERT INTO Cleaner VALUES (22,'Evening');
INSERT INTO Cleaner VALUES (23,'Morning');
INSERT INTO Cleaner VALUES (24,'Evening');
INSERT INTO Cleaner VALUES (25,'Morning');
INSERT INTO Cleaner VALUES (26,'Evening');
INSERT INTO Cleaner VALUES (27,'Morning');
INSERT INTO Cleaner VALUES (28,'Evening');
INSERT INTO Cleaner VALUES (29,'Morning');
INSERT INTO Cleaner VALUES (30,'Evening');
INSERT INTO Fuel VALUES (1,'Petrol 1', 'Petroleum', 273.0, 92, 0.745, 18000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (2,'Diesel 2', 'Petroleum', 281.0, 0, 0.83, 16000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (3,'High Octane 3', 'Petroleum', 321.5, 97, 0.75, 12000, 1000, 20000, '2026-10-01');
INSERT INTO Fuel VALUES (4,'Petrol 4', 'Petroleum', 272.5, 92, 0.745, 18000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (5,'Diesel 5', 'Petroleum', 280.5, 0, 0.83, 16000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (6,'High Octane 6', 'Petroleum', 321.0, 97, 0.75, 12000, 1000, 20000, '2026-10-01');
INSERT INTO Fuel VALUES (7,'Petrol 7', 'Petroleum', 274.0, 92, 0.745, 18000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (8,'Diesel 8', 'Petroleum', 280.0, 0, 0.83, 16000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (9,'High Octane 9', 'Petroleum', 320.5, 97, 0.75, 12000, 1000, 20000, '2026-10-01');
INSERT INTO Fuel VALUES (10,'Petrol 10', 'Petroleum', 273.5, 92, 0.745, 18000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (11,'Diesel 11', 'Petroleum', 281.5, 0, 0.83, 16000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (12,'High Octane 12', 'Petroleum', 320.0, 97, 0.75, 12000, 1000, 20000, '2026-10-01');
INSERT INTO Fuel VALUES (13,'Petrol 13', 'Petroleum', 273.0, 92, 0.745, 18000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (14,'Diesel 14', 'Petroleum', 281.0, 0, 0.83, 16000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (15,'High Octane 15', 'Petroleum', 321.5, 97, 0.75, 12000, 1000, 20000, '2026-10-01');
INSERT INTO Fuel VALUES (16,'Petrol 16', 'Petroleum', 272.5, 92, 0.745, 18000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (17,'Diesel 17', 'Petroleum', 280.5, 0, 0.83, 16000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (18,'High Octane 18', 'Petroleum', 321.0, 97, 0.75, 12000, 1000, 20000, '2026-10-01');
INSERT INTO Fuel VALUES (19,'Petrol 19', 'Petroleum', 274.0, 92, 0.745, 18000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (20,'Diesel 20', 'Petroleum', 280.0, 0, 0.83, 16000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (21,'High Octane 21', 'Petroleum', 320.5, 97, 0.75, 12000, 1000, 20000, '2026-10-01');
INSERT INTO Fuel VALUES (22,'Petrol 22', 'Petroleum', 273.5, 92, 0.745, 18000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (23,'Diesel 23', 'Petroleum', 281.5, 0, 0.83, 16000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (24,'High Octane 24', 'Petroleum', 320.0, 97, 0.75, 12000, 1000, 20000, '2026-10-01');
INSERT INTO Fuel VALUES (25,'Petrol 25', 'Petroleum', 273.0, 92, 0.745, 18000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (26,'Diesel 26', 'Petroleum', 281.0, 0, 0.83, 16000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (27,'High Octane 27', 'Petroleum', 321.5, 97, 0.75, 12000, 1000, 20000, '2026-10-01');
INSERT INTO Fuel VALUES (28,'Petrol 28', 'Petroleum', 272.5, 92, 0.745, 18000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (29,'Diesel 29', 'Petroleum', 280.5, 0, 0.83, 16000, 2000, 30000, '2026-10-01');
INSERT INTO Fuel VALUES (30,'High Octane 30', 'Petroleum', 321.0, 97, 0.75, 12000, 1000, 20000, '2026-10-01');
INSERT INTO Fuel_Tank VALUES (1,'Tank-1',1,50100,20100,'2020-01-01','Underground Area 1','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (2,'Tank-2',2,50200,20200,'2020-01-01','Underground Area 2','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (3,'Tank-3',3,50300,20300,'2020-01-01','Underground Area 3','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (4,'Tank-4',4,50400,20400,'2020-01-01','Underground Area 4','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (5,'Tank-5',5,50500,20500,'2020-01-01','Underground Area 5','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (6,'Tank-6',6,50600,20600,'2020-01-01','Underground Area 6','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (7,'Tank-7',7,50700,20700,'2020-01-01','Underground Area 7','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (8,'Tank-8',8,50800,20800,'2020-01-01','Underground Area 8','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (9,'Tank-9',9,50900,20900,'2020-01-01','Underground Area 9','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (10,'Tank-10',10,51000,21000,'2020-01-01','Underground Area 10','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (11,'Tank-11',11,51100,21100,'2020-01-01','Underground Area 11','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (12,'Tank-12',12,51200,21200,'2020-01-01','Underground Area 12','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (13,'Tank-13',13,51300,21300,'2020-01-01','Underground Area 13','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (14,'Tank-14',14,51400,21400,'2020-01-01','Underground Area 14','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (15,'Tank-15',15,51500,21500,'2020-01-01','Underground Area 15','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (16,'Tank-16',16,51600,21600,'2020-01-01','Underground Area 16','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (17,'Tank-17',17,51700,21700,'2020-01-01','Underground Area 17','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (18,'Tank-18',18,51800,21800,'2020-01-01','Underground Area 18','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (19,'Tank-19',19,51900,21900,'2020-01-01','Underground Area 19','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (20,'Tank-20',20,52000,22000,'2020-01-01','Underground Area 20','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (21,'Tank-21',21,52100,22100,'2020-01-01','Underground Area 21','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (22,'Tank-22',22,52200,22200,'2020-01-01','Underground Area 22','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (23,'Tank-23',23,52300,22300,'2020-01-01','Underground Area 23','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (24,'Tank-24',24,52400,22400,'2020-01-01','Underground Area 24','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (25,'Tank-25',25,52500,22500,'2020-01-01','Underground Area 25','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (26,'Tank-26',26,52600,22600,'2020-01-01','Underground Area 26','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (27,'Tank-27',27,52700,22700,'2020-01-01','Underground Area 27','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (28,'Tank-28',28,52800,22800,'2020-01-01','Underground Area 28','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (29,'Tank-29',29,52900,22900,'2020-01-01','Underground Area 29','Steel','2026-01-15','Active');
INSERT INTO Fuel_Tank VALUES (30,'Tank-30',30,53000,23000,'2020-01-01','Underground Area 30','Steel','2026-01-15','Active');
INSERT INTO Fuel_Dispenser VALUES (1,'Dispenser-1',1,1,'Model-1','FuelTech','2021-02-01',100500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (2,'Dispenser-2',2,2,'Model-2','FuelTech','2021-02-01',101000,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (3,'Dispenser-3',3,3,'Model-3','FuelTech','2021-02-01',101500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (4,'Dispenser-4',4,4,'Model-4','FuelTech','2021-02-01',102000,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (5,'Dispenser-5',5,5,'Model-5','FuelTech','2021-02-01',102500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (6,'Dispenser-6',6,6,'Model-6','FuelTech','2021-02-01',103000,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (7,'Dispenser-7',7,7,'Model-7','FuelTech','2021-02-01',103500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (8,'Dispenser-8',8,8,'Model-8','FuelTech','2021-02-01',104000,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (9,'Dispenser-9',9,9,'Model-9','FuelTech','2021-02-01',104500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (10,'Dispenser-10',10,10,'Model-10','FuelTech','2021-02-01',105000,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (11,'Dispenser-11',11,11,'Model-11','FuelTech','2021-02-01',105500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (12,'Dispenser-12',12,12,'Model-12','FuelTech','2021-02-01',106000,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (13,'Dispenser-13',13,13,'Model-13','FuelTech','2021-02-01',106500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (14,'Dispenser-14',14,14,'Model-14','FuelTech','2021-02-01',107000,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (15,'Dispenser-15',15,15,'Model-15','FuelTech','2021-02-01',107500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (16,'Dispenser-16',16,16,'Model-16','FuelTech','2021-02-01',108000,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (17,'Dispenser-17',17,17,'Model-17','FuelTech','2021-02-01',108500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (18,'Dispenser-18',18,18,'Model-18','FuelTech','2021-02-01',109000,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (19,'Dispenser-19',19,19,'Model-19','FuelTech','2021-02-01',109500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (20,'Dispenser-20',20,20,'Model-20','FuelTech','2021-02-01',110000,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (21,'Dispenser-21',21,21,'Model-21','FuelTech','2021-02-01',110500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (22,'Dispenser-22',22,22,'Model-22','FuelTech','2021-02-01',111000,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (23,'Dispenser-23',23,23,'Model-23','FuelTech','2021-02-01',111500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (24,'Dispenser-24',24,24,'Model-24','FuelTech','2021-02-01',112000,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (25,'Dispenser-25',25,25,'Model-25','FuelTech','2021-02-01',112500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (26,'Dispenser-26',26,26,'Model-26','FuelTech','2021-02-01',113000,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (27,'Dispenser-27',27,27,'Model-27','FuelTech','2021-02-01',113500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (28,'Dispenser-28',28,28,'Model-28','FuelTech','2021-02-01',114000,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (29,'Dispenser-29',29,29,'Model-29','FuelTech','2021-02-01',114500,'Active','2026-02-01');
INSERT INTO Fuel_Dispenser VALUES (30,'Dispenser-30',30,30,'Model-30','FuelTech','2021-02-01',115000,'Active','2026-02-01');
INSERT INTO Supplier VALUES (1,'Supplier 1','Fuel Supply Co 1','NTN-1001','03210000001','supplier1@company.com','Industrial Area 1','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (2,'Supplier 2','Fuel Supply Co 2','NTN-1002','03210000002','supplier2@company.com','Industrial Area 2','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (3,'Supplier 3','Fuel Supply Co 3','NTN-1003','03210000003','supplier3@company.com','Industrial Area 3','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (4,'Supplier 4','Fuel Supply Co 4','NTN-1004','03210000004','supplier4@company.com','Industrial Area 4','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (5,'Supplier 5','Fuel Supply Co 5','NTN-1005','03210000005','supplier5@company.com','Industrial Area 5','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (6,'Supplier 6','Fuel Supply Co 6','NTN-1006','03210000006','supplier6@company.com','Industrial Area 6','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (7,'Supplier 7','Fuel Supply Co 7','NTN-1007','03210000007','supplier7@company.com','Industrial Area 7','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (8,'Supplier 8','Fuel Supply Co 8','NTN-1008','03210000008','supplier8@company.com','Industrial Area 8','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (9,'Supplier 9','Fuel Supply Co 9','NTN-1009','03210000009','supplier9@company.com','Industrial Area 9','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (10,'Supplier 10','Fuel Supply Co 10','NTN-1010','03210000010','supplier10@company.com','Industrial Area 10','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (11,'Supplier 11','Fuel Supply Co 11','NTN-1011','03210000011','supplier11@company.com','Industrial Area 11','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (12,'Supplier 12','Fuel Supply Co 12','NTN-1012','03210000012','supplier12@company.com','Industrial Area 12','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (13,'Supplier 13','Fuel Supply Co 13','NTN-1013','03210000013','supplier13@company.com','Industrial Area 13','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (14,'Supplier 14','Fuel Supply Co 14','NTN-1014','03210000014','supplier14@company.com','Industrial Area 14','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (15,'Supplier 15','Fuel Supply Co 15','NTN-1015','03210000015','supplier15@company.com','Industrial Area 15','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (16,'Supplier 16','Fuel Supply Co 16','NTN-1016','03210000016','supplier16@company.com','Industrial Area 16','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (17,'Supplier 17','Fuel Supply Co 17','NTN-1017','03210000017','supplier17@company.com','Industrial Area 17','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (18,'Supplier 18','Fuel Supply Co 18','NTN-1018','03210000018','supplier18@company.com','Industrial Area 18','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (19,'Supplier 19','Fuel Supply Co 19','NTN-1019','03210000019','supplier19@company.com','Industrial Area 19','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (20,'Supplier 20','Fuel Supply Co 20','NTN-1020','03210000020','supplier20@company.com','Industrial Area 20','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (21,'Supplier 21','Fuel Supply Co 21','NTN-1021','03210000021','supplier21@company.com','Industrial Area 21','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (22,'Supplier 22','Fuel Supply Co 22','NTN-1022','03210000022','supplier22@company.com','Industrial Area 22','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (23,'Supplier 23','Fuel Supply Co 23','NTN-1023','03210000023','supplier23@company.com','Industrial Area 23','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (24,'Supplier 24','Fuel Supply Co 24','NTN-1024','03210000024','supplier24@company.com','Industrial Area 24','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (25,'Supplier 25','Fuel Supply Co 25','NTN-1025','03210000025','supplier25@company.com','Industrial Area 25','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (26,'Supplier 26','Fuel Supply Co 26','NTN-1026','03210000026','supplier26@company.com','Industrial Area 26','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (27,'Supplier 27','Fuel Supply Co 27','NTN-1027','03210000027','supplier27@company.com','Industrial Area 27','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (28,'Supplier 28','Fuel Supply Co 28','NTN-1028','03210000028','supplier28@company.com','Industrial Area 28','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (29,'Supplier 29','Fuel Supply Co 29','NTN-1029','03210000029','supplier29@company.com','Industrial Area 29','Lahore','2023-01-01','Active');
INSERT INTO Supplier VALUES (30,'Supplier 30','Fuel Supply Co 30','NTN-1030','03210000030','supplier30@company.com','Industrial Area 30','Lahore','2023-01-01','Active');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (1,1,1,1,'2026-10-01','09:30:00',1010,251,'INV-0001');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (2,2,2,2,'2026-10-02','09:30:00',1020,252,'INV-0002');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (3,3,3,3,'2026-10-03','09:30:00',1030,253,'INV-0003');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (4,4,4,4,'2026-10-04','09:30:00',1040,254,'INV-0004');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (5,5,5,5,'2026-10-05','09:30:00',1050,255,'INV-0005');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (6,6,6,6,'2026-10-06','09:30:00',1060,256,'INV-0006');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (7,7,7,7,'2026-10-07','09:30:00',1070,257,'INV-0007');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (8,8,8,8,'2026-10-08','09:30:00',1080,258,'INV-0008');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (9,9,9,9,'2026-10-09','09:30:00',1090,259,'INV-0009');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (10,10,10,10,'2026-10-10','09:30:00',1100,250,'INV-0010');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (11,11,11,11,'2026-10-11','09:30:00',1110,251,'INV-0011');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (12,12,12,12,'2026-10-12','09:30:00',1120,252,'INV-0012');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (13,13,13,13,'2026-10-13','09:30:00',1130,253,'INV-0013');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (14,14,14,14,'2026-10-14','09:30:00',1140,254,'INV-0014');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (15,15,15,15,'2026-10-15','09:30:00',1150,255,'INV-0015');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (16,16,16,16,'2026-10-16','09:30:00',1160,256,'INV-0016');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (17,17,17,17,'2026-10-17','09:30:00',1170,257,'INV-0017');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (18,18,18,18,'2026-10-18','09:30:00',1180,258,'INV-0018');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (19,19,19,19,'2026-10-19','09:30:00',1190,259,'INV-0019');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (20,20,20,20,'2026-10-20','09:30:00',1200,250,'INV-0020');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (21,21,21,21,'2026-10-21','09:30:00',1210,251,'INV-0021');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (22,22,22,22,'2026-10-22','09:30:00',1220,252,'INV-0022');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (23,23,23,23,'2026-10-23','09:30:00',1230,253,'INV-0023');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (24,24,24,24,'2026-10-24','09:30:00',1240,254,'INV-0024');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (25,25,25,25,'2026-10-25','09:30:00',1250,255,'INV-0025');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (26,26,26,26,'2026-10-26','09:30:00',1260,256,'INV-0026');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (27,27,27,27,'2026-10-27','09:30:00',1270,257,'INV-0027');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (28,28,28,28,'2026-10-28','09:30:00',1280,258,'INV-0028');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (29,29,29,29,'2026-10-01','09:30:00',1290,259,'INV-0029');
INSERT INTO Fuel_Purchase (Purchase_ID,Supplier_ID,Fuel_ID,Tank_ID,Purchase_Date,Purchase_Time,Quantity,Unit_Price,Invoice_Number) VALUES (30,30,30,30,'2026-10-02','09:30:00',1300,250,'INV-0030');
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (1,1,11,1,1,'2026-10-01','09:15:00',12,271);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (2,2,12,2,2,'2026-10-02','10:15:00',14,272);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (3,3,13,3,3,'2026-10-03','11:15:00',16,273);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (4,4,14,4,4,'2026-10-04','12:15:00',18,274);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (5,5,15,5,5,'2026-10-05','13:15:00',20,275);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (6,6,16,6,6,'2026-10-06','14:15:00',22,276);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (7,7,17,7,7,'2026-10-07','15:15:00',24,277);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (8,8,18,8,8,'2026-10-08','16:15:00',26,278);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (9,9,19,9,9,'2026-10-09','17:15:00',28,279);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (10,10,20,10,10,'2026-10-10','18:15:00',30,270);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (11,11,11,11,11,'2026-10-11','19:15:00',32,271);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (12,12,12,12,12,'2026-10-12','08:15:00',34,272);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (13,13,13,13,13,'2026-10-13','09:15:00',36,273);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (14,14,14,14,14,'2026-10-14','10:15:00',38,274);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (15,15,15,15,15,'2026-10-15','11:15:00',40,275);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (16,16,16,16,16,'2026-10-16','12:15:00',42,276);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (17,17,17,17,17,'2026-10-17','13:15:00',44,277);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (18,18,18,18,18,'2026-10-18','14:15:00',46,278);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (19,19,19,19,19,'2026-10-19','15:15:00',48,279);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (20,20,20,20,20,'2026-10-20','16:15:00',50,270);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (21,21,11,21,21,'2026-10-21','17:15:00',52,271);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (22,22,12,22,22,'2026-10-22','18:15:00',54,272);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (23,23,13,23,23,'2026-10-23','19:15:00',56,273);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (24,24,14,24,24,'2026-10-24','08:15:00',58,274);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (25,25,15,25,25,'2026-10-25','09:15:00',60,275);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (26,26,16,26,26,'2026-10-26','10:15:00',62,276);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (27,27,17,27,27,'2026-10-27','11:15:00',64,277);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (28,28,18,28,28,'2026-10-28','12:15:00',66,278);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (29,29,19,29,29,'2026-10-01','13:15:00',68,279);
INSERT INTO Sale_Transaction (Sale_ID,Customer_ID,Employee_ID,Fuel_ID,Dispenser_ID,Sale_Date,Sale_Time,Quantity,Price_Per_Litre) VALUES (30,30,20,30,30,'2026-10-02','14:15:00',70,270);
INSERT INTO Payment VALUES (1,1,'Card',3252,'2026-10-01','10:00:00','TRX-0001','Completed','1001','Payment for sale 1');
INSERT INTO Payment VALUES (2,2,'Online',3808,'2026-10-02','10:00:00','TRX-0002','Completed',NULL,'Payment for sale 2');
INSERT INTO Payment VALUES (3,3,'Cash',4368,'2026-10-03','10:00:00','TRX-0003','Completed',NULL,'Payment for sale 3');
INSERT INTO Payment VALUES (4,4,'Card',4932,'2026-10-04','10:00:00','TRX-0004','Completed','1004','Payment for sale 4');
INSERT INTO Payment VALUES (5,5,'Online',5500,'2026-10-05','10:00:00','TRX-0005','Completed',NULL,'Payment for sale 5');
INSERT INTO Payment VALUES (6,6,'Cash',6072,'2026-10-06','10:00:00','TRX-0006','Completed',NULL,'Payment for sale 6');
INSERT INTO Payment VALUES (7,7,'Card',6648,'2026-10-07','10:00:00','TRX-0007','Completed','1007','Payment for sale 7');
INSERT INTO Payment VALUES (8,8,'Online',7228,'2026-10-08','10:00:00','TRX-0008','Completed',NULL,'Payment for sale 8');
INSERT INTO Payment VALUES (9,9,'Cash',7812,'2026-10-09','10:00:00','TRX-0009','Completed',NULL,'Payment for sale 9');
INSERT INTO Payment VALUES (10,10,'Card',8100,'2026-10-10','10:00:00','TRX-0010','Completed','1010','Payment for sale 10');
INSERT INTO Payment VALUES (11,11,'Online',8672,'2026-10-11','10:00:00','TRX-0011','Completed',NULL,'Payment for sale 11');
INSERT INTO Payment VALUES (12,12,'Cash',9248,'2026-10-12','10:00:00','TRX-0012','Completed',NULL,'Payment for sale 12');
INSERT INTO Payment VALUES (13,13,'Card',9828,'2026-10-13','10:00:00','TRX-0013','Completed','1013','Payment for sale 13');
INSERT INTO Payment VALUES (14,14,'Online',10412,'2026-10-14','10:00:00','TRX-0014','Completed',NULL,'Payment for sale 14');
INSERT INTO Payment VALUES (15,15,'Cash',11000,'2026-10-15','10:00:00','TRX-0015','Completed',NULL,'Payment for sale 15');
INSERT INTO Payment VALUES (16,16,'Card',11592,'2026-10-16','10:00:00','TRX-0016','Completed','1016','Payment for sale 16');
INSERT INTO Payment VALUES (17,17,'Online',12188,'2026-10-17','10:00:00','TRX-0017','Completed',NULL,'Payment for sale 17');
INSERT INTO Payment VALUES (18,18,'Cash',12788,'2026-10-18','10:00:00','TRX-0018','Completed',NULL,'Payment for sale 18');
INSERT INTO Payment VALUES (19,19,'Card',13392,'2026-10-19','10:00:00','TRX-0019','Completed','1019','Payment for sale 19');
INSERT INTO Payment VALUES (20,20,'Online',13500,'2026-10-20','10:00:00','TRX-0020','Completed',NULL,'Payment for sale 20');
INSERT INTO Payment VALUES (21,21,'Cash',14092,'2026-10-21','10:00:00','TRX-0021','Completed',NULL,'Payment for sale 21');
INSERT INTO Payment VALUES (22,22,'Card',14688,'2026-10-22','10:00:00','TRX-0022','Completed','1022','Payment for sale 22');
INSERT INTO Payment VALUES (23,23,'Online',15288,'2026-10-23','10:00:00','TRX-0023','Completed',NULL,'Payment for sale 23');
INSERT INTO Payment VALUES (24,24,'Cash',15892,'2026-10-24','10:00:00','TRX-0024','Completed',NULL,'Payment for sale 24');
INSERT INTO Payment VALUES (25,25,'Card',16500,'2026-10-25','10:00:00','TRX-0025','Completed','1025','Payment for sale 25');
INSERT INTO Payment VALUES (26,26,'Online',17112,'2026-10-26','10:00:00','TRX-0026','Completed',NULL,'Payment for sale 26');
INSERT INTO Payment VALUES (27,27,'Cash',17728,'2026-10-27','10:00:00','TRX-0027','Completed',NULL,'Payment for sale 27');
INSERT INTO Payment VALUES (28,28,'Card',18348,'2026-10-28','10:00:00','TRX-0028','Completed','1028','Payment for sale 28');
INSERT INTO Payment VALUES (29,29,'Online',18972,'2026-10-01','10:00:00','TRX-0029','Completed',NULL,'Payment for sale 29');
INSERT INTO Payment VALUES (30,30,'Cash',18900,'2026-10-02','10:00:00','TRX-0030','Completed',NULL,'Payment for sale 30');
INSERT INTO Vehicle VALUES (1,1,'LEA-1001','Car','Toyota','Model-1',2011,'White',1050,'2024-01-01');
INSERT INTO Vehicle VALUES (2,2,'LEA-1002','Motorcycle','Honda','Model-2',2012,'Black',1100,'2024-01-01');
INSERT INTO Vehicle VALUES (3,3,'LEA-1003','Car','Toyota','Model-3',2013,'White',1150,'2024-01-01');
INSERT INTO Vehicle VALUES (4,4,'LEA-1004','Motorcycle','Honda','Model-4',2014,'Black',1200,'2024-01-01');
INSERT INTO Vehicle VALUES (5,5,'LEA-1005','Car','Toyota','Model-5',2015,'White',1250,'2024-01-01');
INSERT INTO Vehicle VALUES (6,6,'LEA-1006','Motorcycle','Honda','Model-6',2016,'Black',1300,'2024-01-01');
INSERT INTO Vehicle VALUES (7,7,'LEA-1007','Car','Toyota','Model-7',2017,'White',1350,'2024-01-01');
INSERT INTO Vehicle VALUES (8,8,'LEA-1008','Motorcycle','Honda','Model-8',2018,'Black',1400,'2024-01-01');
INSERT INTO Vehicle VALUES (9,9,'LEA-1009','Car','Toyota','Model-9',2019,'White',1450,'2024-01-01');
INSERT INTO Vehicle VALUES (10,10,'LEA-1010','Motorcycle','Honda','Model-10',2020,'Black',1500,'2024-01-01');
INSERT INTO Vehicle VALUES (11,11,'LEA-1011','Car','Toyota','Model-11',2021,'White',1550,'2024-01-01');
INSERT INTO Vehicle VALUES (12,12,'LEA-1012','Motorcycle','Honda','Model-12',2022,'Black',1600,'2024-01-01');
INSERT INTO Vehicle VALUES (13,13,'LEA-1013','Car','Toyota','Model-13',2023,'White',1650,'2024-01-01');
INSERT INTO Vehicle VALUES (14,14,'LEA-1014','Motorcycle','Honda','Model-14',2024,'Black',1700,'2024-01-01');
INSERT INTO Vehicle VALUES (15,15,'LEA-1015','Car','Toyota','Model-15',2010,'White',1750,'2024-01-01');
INSERT INTO Vehicle VALUES (16,16,'LEA-1016','Motorcycle','Honda','Model-16',2011,'Black',1800,'2024-01-01');
INSERT INTO Vehicle VALUES (17,17,'LEA-1017','Car','Toyota','Model-17',2012,'White',1850,'2024-01-01');
INSERT INTO Vehicle VALUES (18,18,'LEA-1018','Motorcycle','Honda','Model-18',2013,'Black',1900,'2024-01-01');
INSERT INTO Vehicle VALUES (19,19,'LEA-1019','Car','Toyota','Model-19',2014,'White',1950,'2024-01-01');
INSERT INTO Vehicle VALUES (20,20,'LEA-1020','Motorcycle','Honda','Model-20',2015,'Black',2000,'2024-01-01');
INSERT INTO Vehicle VALUES (21,21,'LEA-1021','Car','Toyota','Model-21',2016,'White',2050,'2024-01-01');
INSERT INTO Vehicle VALUES (22,22,'LEA-1022','Motorcycle','Honda','Model-22',2017,'Black',2100,'2024-01-01');
INSERT INTO Vehicle VALUES (23,23,'LEA-1023','Car','Toyota','Model-23',2018,'White',2150,'2024-01-01');
INSERT INTO Vehicle VALUES (24,24,'LEA-1024','Motorcycle','Honda','Model-24',2019,'Black',2200,'2024-01-01');
INSERT INTO Vehicle VALUES (25,25,'LEA-1025','Car','Toyota','Model-25',2020,'White',2250,'2024-01-01');
INSERT INTO Vehicle VALUES (26,26,'LEA-1026','Motorcycle','Honda','Model-26',2021,'Black',2300,'2024-01-01');
INSERT INTO Vehicle VALUES (27,27,'LEA-1027','Car','Toyota','Model-27',2022,'White',2350,'2024-01-01');
INSERT INTO Vehicle VALUES (28,28,'LEA-1028','Motorcycle','Honda','Model-28',2023,'Black',2400,'2024-01-01');
INSERT INTO Vehicle VALUES (29,29,'LEA-1029','Car','Toyota','Model-29',2024,'White',2450,'2024-01-01');
INSERT INTO Vehicle VALUES (30,30,'LEA-1030','Motorcycle','Honda','Model-30',2010,'Black',2500,'2024-01-01');
INSERT INTO Cleaning_Activity VALUES (1,21,'Dispensing Area','Routine','2026-10-01','08:00:00','Completed','Passed','Cleaning task 1',21);
INSERT INTO Cleaning_Activity VALUES (2,22,'Customer Waiting Area','Routine','2026-10-02','09:00:00','Completed','Passed','Cleaning task 2',22);
INSERT INTO Cleaning_Activity VALUES (3,23,'Washroom','Routine','2026-10-03','10:00:00','Completed','Pending','Cleaning task 3',23);
INSERT INTO Cleaning_Activity VALUES (4,24,'Dispensing Area','Routine','2026-10-04','11:00:00','Pending','Passed','Cleaning task 4',24);
INSERT INTO Cleaning_Activity VALUES (5,25,'Customer Waiting Area','Routine','2026-10-05','12:00:00','Completed','Passed','Cleaning task 5',25);
INSERT INTO Cleaning_Activity VALUES (6,26,'Washroom','Routine','2026-10-06','13:00:00','Completed','Pending','Cleaning task 6',26);
INSERT INTO Cleaning_Activity VALUES (7,27,'Dispensing Area','Routine','2026-10-07','14:00:00','Completed','Passed','Cleaning task 7',27);
INSERT INTO Cleaning_Activity VALUES (8,28,'Customer Waiting Area','Routine','2026-10-08','15:00:00','Pending','Passed','Cleaning task 8',28);
INSERT INTO Cleaning_Activity VALUES (9,29,'Washroom','Routine','2026-10-09','16:00:00','Completed','Pending','Cleaning task 9',29);
INSERT INTO Cleaning_Activity VALUES (10,30,'Dispensing Area','Routine','2026-10-10','07:00:00','Completed','Passed','Cleaning task 10',30);
INSERT INTO Cleaning_Activity VALUES (11,21,'Customer Waiting Area','Routine','2026-10-11','08:00:00','Completed','Passed','Cleaning task 11',31);
INSERT INTO Cleaning_Activity VALUES (12,22,'Washroom','Routine','2026-10-12','09:00:00','Pending','Pending','Cleaning task 12',32);
INSERT INTO Cleaning_Activity VALUES (13,23,'Dispensing Area','Routine','2026-10-13','10:00:00','Completed','Passed','Cleaning task 13',33);
INSERT INTO Cleaning_Activity VALUES (14,24,'Customer Waiting Area','Routine','2026-10-14','11:00:00','Completed','Passed','Cleaning task 14',34);
INSERT INTO Cleaning_Activity VALUES (15,25,'Washroom','Routine','2026-10-15','12:00:00','Completed','Pending','Cleaning task 15',35);
INSERT INTO Cleaning_Activity VALUES (16,26,'Dispensing Area','Routine','2026-10-16','13:00:00','Pending','Passed','Cleaning task 16',36);
INSERT INTO Cleaning_Activity VALUES (17,27,'Customer Waiting Area','Routine','2026-10-17','14:00:00','Completed','Passed','Cleaning task 17',37);
INSERT INTO Cleaning_Activity VALUES (18,28,'Washroom','Routine','2026-10-18','15:00:00','Completed','Pending','Cleaning task 18',38);
INSERT INTO Cleaning_Activity VALUES (19,29,'Dispensing Area','Routine','2026-10-19','16:00:00','Completed','Passed','Cleaning task 19',39);
INSERT INTO Cleaning_Activity VALUES (20,30,'Customer Waiting Area','Routine','2026-10-20','07:00:00','Pending','Passed','Cleaning task 20',40);
INSERT INTO Cleaning_Activity VALUES (21,21,'Washroom','Routine','2026-10-21','08:00:00','Completed','Pending','Cleaning task 21',41);
INSERT INTO Cleaning_Activity VALUES (22,22,'Dispensing Area','Routine','2026-10-22','09:00:00','Completed','Passed','Cleaning task 22',42);
INSERT INTO Cleaning_Activity VALUES (23,23,'Customer Waiting Area','Routine','2026-10-23','10:00:00','Completed','Passed','Cleaning task 23',43);
INSERT INTO Cleaning_Activity VALUES (24,24,'Washroom','Routine','2026-10-24','11:00:00','Pending','Pending','Cleaning task 24',44);
INSERT INTO Cleaning_Activity VALUES (25,25,'Dispensing Area','Routine','2026-10-25','12:00:00','Completed','Passed','Cleaning task 25',45);
INSERT INTO Cleaning_Activity VALUES (26,26,'Customer Waiting Area','Routine','2026-10-26','13:00:00','Completed','Passed','Cleaning task 26',46);
INSERT INTO Cleaning_Activity VALUES (27,27,'Washroom','Routine','2026-10-27','14:00:00','Completed','Pending','Cleaning task 27',47);
INSERT INTO Cleaning_Activity VALUES (28,28,'Dispensing Area','Routine','2026-10-28','15:00:00','Pending','Passed','Cleaning task 28',48);
INSERT INTO Cleaning_Activity VALUES (29,29,'Customer Waiting Area','Routine','2026-10-01','16:00:00','Completed','Passed','Cleaning task 29',49);
INSERT INTO Cleaning_Activity VALUES (30,30,'Washroom','Routine','2026-10-02','07:00:00','Completed','Pending','Cleaning task 30',50);


SELECT * FROM Customer;
SELECT First_Name, Last_Name, Phone, Email 
FROM Customer; 

SELECT * FROM Fuel;
SELECT Fuel_Name, Fuel_Type, Price_Per_Litre
FROM Fuel
ORDER BY Fuel_ID;

SELECT * FROM Employee;
SELECT First_Name, Last_Name, Salary, Joining_Date
FROM Employee
ORDER BY Employee_ID;
SELECT * FROM cashier;
SELECT * FROM cleaner;
SELECT * FROM cleaning_activity;
SELECT * FROM fuel_dispenser;
SELECT * FROM fuel_purchase;
SELECT Invoice_Number, Quantity, Unit_Price, Total_Cost
FROM Fuel_Purchase
ORDER BY Purchase_ID;
SELECT * FROM fuel_tank;
SELECT * FROM manager;
SELECT * FROM payment;
SELECT * FROM sale_transaction;
SELECT * FROM supplier;
SELECT * FROM vehicle;
SELECT Registration_Number, Vehicle_Type, Manufacturer, Model
FROM Vehicle
ORDER BY Vehicle_ID;



ALTER TABLE Customer ADD COLUMN Customer_Type VARCHAR(20) DEFAULT 'Regular';
select *from Employee;
ALTER TABLE Employee ADD COLUMN Emergency_Contact VARCHAR(20);
select *from Employee;
ALTER TABLE Fuel ADD COLUMN Fuel_Grade VARCHAR(20) DEFAULT 'Standard';
select *from Fuel;
ALTER TABLE Fuel_Tank ADD COLUMN Tank_Remarks VARCHAR(100);
select *from Fuel_Tank;
ALTER TABLE Supplier ADD COLUMN Website VARCHAR(100);
select *from Supplier;
ALTER TABLE Vehicle ADD COLUMN Insurance_Status VARCHAR(20) DEFAULT 'Unknown';
select *from Vehicle;
ALTER TABLE Vehicle DROP COLUMN Insurance_Status;
select *from Vehicle;
ALTER TABLE Customer RENAME COLUMN Customer_Type TO Customer_Category;
select *from Customer;
ALTER TABLE Employee MODIFY COLUMN Phone VARCHAR(25);
select *from Employee;
ALTER TABLE Fuel MODIFY COLUMN Density DECIMAL(7,3);
select *from Fuel;



CREATE TABLE Drop_Demo (Demo_ID INT PRIMARY KEY, Demo_Name VARCHAR(30));
INSERT INTO Drop_Demo VALUES (1,'Temporary record');
SELECT * FROM Drop_Demo;
DROP TABLE Drop_Demo;



SELECT * FROM Customer;
SELECT * FROM Employee;
SELECT Customer_ID, First_Name, Last_Name, City FROM Customer;
SELECT Fuel_ID, Fuel_Name, Price_Per_Litre FROM Fuel;



UPDATE Customer SET Loyalty_Points = Loyalty_Points + 10 WHERE Customer_ID = 1;
select *from Customer;
UPDATE Employee SET Salary = Salary + 2000 WHERE Employee_ID = 11;
select *from Employee;
UPDATE Fuel SET Price_Per_Litre = Price_Per_Litre + 1 WHERE Fuel_ID = 1;
select *from Fuel;
UPDATE Supplier SET Supplier_Status = 'Active' WHERE Supplier_ID = 9;
select *from Supplier;
UPDATE Cleaning_Activity SET Completion_Status = 'Completed' WHERE Cleaning_ID = 4;
select *from Cleaning_Activity;



-- Find customer with ID 5
SELECT * FROM Customer WHERE Customer_ID = 5;
-- Find customers whose city is not Lahore
SELECT * FROM Customer WHERE City <> 'Lahore';
-- Find employees whose salary is not 50000
SELECT * FROM Employee WHERE Salary != 50000;
-- Find fuel priced below 280
SELECT * FROM Fuel WHERE Price_Per_Litre < 280;
-- Find employees earning above 50000
SELECT * FROM Employee WHERE Salary > 50000;
-- Find tanks with level at most 25000
SELECT * FROM Fuel_Tank WHERE Current_Level <= 25000;
-- Find tanks with capacity at least 50020
SELECT * FROM Fuel_Tank WHERE Capacity >= 50020;
-- Find active suppliers in Lahore
SELECT * FROM Supplier WHERE Supplier_Status='Active' AND City='Lahore';
-- Find customers from Lahore or Karachi
SELECT * FROM Customer WHERE City='Lahore' OR City='Karachi';
-- Find non-pending cleaning activities
SELECT * FROM Cleaning_Activity WHERE NOT Completion_Status='Pending';
-- Show fuel price after adding tax amount 5
SELECT Fuel_ID, Fuel_Name, Price_Per_Litre, Price_Per_Litre + 5 AS Price_With_Addition FROM Fuel WHERE Fuel_ID <= 10;
-- Show fuel stock after subtracting 500 litres
SELECT Fuel_ID, Current_Stock, Current_Stock - 500 AS Remaining_Stock FROM Fuel WHERE Fuel_ID <= 10;
-- Calculate value of first ten fuel stock records
SELECT Fuel_ID, Current_Stock * Price_Per_Litre AS Stock_Value FROM Fuel WHERE Fuel_ID <= 10;
-- Show average price per half-litre unit calculation
SELECT Fuel_ID, Price_Per_Litre / 2 AS Half_Litre_Price FROM Fuel WHERE Fuel_ID <= 10;
-- List distinct customer cities
SELECT DISTINCT City FROM Customer;
-- Count customers by city
SELECT City, COUNT(*) AS Total_Customers FROM Customer GROUP BY City;
-- Show cities with at least 5 customers
SELECT City, COUNT(*) AS Total_Customers FROM Customer GROUP BY City HAVING COUNT(*) >= 5;
-- Find sales between 50 and 100 litres
SELECT * FROM Sale_Transaction WHERE Quantity BETWEEN 50 AND 100;
-- Find customers whose first name starts with Customer1
SELECT * FROM Customer WHERE First_Name LIKE 'Customer1%';
-- Find suppliers with selected IDs
SELECT * FROM Supplier WHERE Supplier_ID IN (1,5,10,15);
-- Show top 10 highest salaries
SELECT * FROM Employee ORDER BY Salary DESC LIMIT 10;
-- Find completed cleaning tasks
SELECT * FROM Cleaning_Activity WHERE Completion_Status='Completed';
-- Find card payments
SELECT * FROM Payment WHERE Payment_Method='Card';
-- Find customers with loyalty points over 50
SELECT * FROM Customer WHERE Loyalty_Points > 50;
-- Find fuel with stock below minimum
SELECT * FROM Fuel WHERE Current_Stock < Minimum_Stock;
-- Find tanks marked active
SELECT * FROM Fuel_Tank WHERE Tank_Status='Active';
-- Find purchases with quantity over 1100
SELECT * FROM Fuel_Purchase WHERE Quantity > 1100;
-- Find vehicles manufactured after 2018
SELECT * FROM Vehicle WHERE Manufacturing_Year > 2018;
-- Find dispensers needing maintenance before 2026-03-01
SELECT * FROM Fuel_Dispenser WHERE Last_Maintenance < '2026-03-01';
-- Sort payments from highest amount to lowest
SELECT * FROM Payment WHERE Payment_Status='Completed' ORDER BY Payment_Amount DESC;




-- INNER JOIN 1: Sales with customer names
SELECT s.Sale_ID, c.First_Name, c.Last_Name, s.Total_Amount
FROM Sale_Transaction s INNER JOIN Customer c ON s.Customer_ID=c.Customer_ID;
-- INNER JOIN 2: Sales with cashier names
SELECT s.Sale_ID, e.First_Name, e.Last_Name, s.Quantity
FROM Sale_Transaction s INNER JOIN Employee e ON s.Employee_ID=e.Employee_ID;
-- LEFT JOIN 1: All customers and any sales
SELECT c.Customer_ID, c.First_Name, s.Sale_ID
FROM Customer c LEFT JOIN Sale_Transaction s ON c.Customer_ID=s.Customer_ID;
-- LEFT JOIN 2: All fuels and associated tanks
SELECT f.Fuel_ID, f.Fuel_Name, t.Tank_ID, t.Tank_Name
FROM Fuel f LEFT JOIN Fuel_Tank t ON f.Fuel_ID=t.Fuel_ID;
-- RIGHT JOIN 1: All suppliers and matching purchases
SELECT su.Supplier_ID, su.Supplier_Name, p.Purchase_ID
FROM Fuel_Purchase p RIGHT JOIN Supplier su ON p.Supplier_ID=su.Supplier_ID;
-- RIGHT JOIN 2: All cashiers and their sales
SELECT e.Employee_ID, e.First_Name, s.Sale_ID
FROM Sale_Transaction s RIGHT JOIN Cashier ca ON s.Employee_ID=ca.Employee_ID
RIGHT JOIN Employee e ON ca.Employee_ID=e.Employee_ID;
-- FULL OUTER JOIN equivalent 1 (MySQL uses LEFT + RIGHT with UNION)
SELECT c.Customer_ID, c.First_Name, s.Sale_ID
FROM Customer c LEFT JOIN Sale_Transaction s ON c.Customer_ID=s.Customer_ID
UNION
SELECT c.Customer_ID, c.First_Name, s.Sale_ID
FROM Customer c RIGHT JOIN Sale_Transaction s ON c.Customer_ID=s.Customer_ID;
-- FULL OUTER JOIN equivalent 2
SELECT f.Fuel_ID, f.Fuel_Name, t.Tank_ID
FROM Fuel f LEFT JOIN Fuel_Tank t ON f.Fuel_ID=t.Fuel_ID
UNION
SELECT f.Fuel_ID, f.Fuel_Name, t.Tank_ID
FROM Fuel f RIGHT JOIN Fuel_Tank t ON f.Fuel_ID=t.Fuel_ID;
-- CROSS JOIN 1: fuel types paired with first three suppliers
SELECT f.Fuel_Name, su.Supplier_Name FROM Fuel f CROSS JOIN Supplier su
WHERE f.Fuel_ID <= 3 AND su.Supplier_ID <= 3;
-- CROSS JOIN 2: first two fuels paired with first two tanks
SELECT f.Fuel_Name, t.Tank_Name FROM Fuel f CROSS JOIN Fuel_Tank t
WHERE f.Fuel_ID <= 2 AND t.Tank_ID <= 2;
-- SELF JOIN 1: Employees with another employee having same gender
SELECT e1.Employee_ID, e1.First_Name, e2.Employee_ID AS Other_Employee
FROM Employee e1 JOIN Employee e2 ON e1.Gender=e2.Gender AND e1.Employee_ID<e2.Employee_ID;
-- SELF JOIN 2: Employees whose salary is lower than another employee's salary
SELECT e1.First_Name AS Employee, e1.Salary, e2.First_Name AS Higher_Paid_Employee, e2.Salary AS Higher_Salary
FROM Employee e1 JOIN Employee e2 ON e1.Salary<e2.Salary
WHERE e1.Employee_ID<=3 AND e2.Employee_ID<=5;


-- Find employees earning more than average salary
SELECT * FROM Employee WHERE Salary > (SELECT AVG(Salary) FROM Employee);
-- Find fuel with price above average fuel price
SELECT * FROM Fuel WHERE Price_Per_Litre > (SELECT AVG(Price_Per_Litre) FROM Fuel);
-- Find customers who have made a sale using IN
SELECT * FROM Customer WHERE Customer_ID IN (SELECT Customer_ID FROM Sale_Transaction);
-- Find customers who have never made a sale using NOT IN
SELECT * FROM Customer WHERE Customer_ID NOT IN (SELECT Customer_ID FROM Sale_Transaction);
-- Find suppliers who have purchases using EXISTS
SELECT * FROM Supplier su WHERE EXISTS (SELECT 1 FROM Fuel_Purchase p WHERE p.Supplier_ID=su.Supplier_ID);
-- Find suppliers without purchases using NOT EXISTS
SELECT * FROM Supplier su WHERE NOT EXISTS (SELECT 1 FROM Fuel_Purchase p WHERE p.Supplier_ID=su.Supplier_ID);
-- Find sales above the maximum sale amount
SELECT * FROM Sale_Transaction WHERE Total_Amount > (SELECT MAX(Total_Amount) FROM Sale_Transaction WHERE Sale_ID<30);
-- Find employee(s) with minimum salary
SELECT * FROM Employee WHERE Salary=(SELECT MIN(Salary) FROM Employee);
-- Find fuel whose price equals the highest price
SELECT * FROM Fuel WHERE Price_Per_Litre=(SELECT MAX(Price_Per_Litre) FROM Fuel);
-- Find customers whose loyalty points exceed any customer's points in first five IDs
SELECT * FROM Customer WHERE Loyalty_Points > ANY (SELECT Loyalty_Points FROM Customer WHERE Customer_ID<=5);
-- Find employees whose salary is greater than all managers' salaries
SELECT * FROM Employee WHERE Salary > ALL (SELECT e.Salary FROM Employee e JOIN Manager m ON e.Employee_ID=m.Employee_ID);
-- Find purchases whose quantity is greater than average purchase quantity
SELECT * FROM Fuel_Purchase WHERE Quantity > (SELECT AVG(Quantity) FROM Fuel_Purchase);
-- Find sales whose customer is from Lahore
SELECT * FROM Sale_Transaction WHERE Customer_ID IN (SELECT Customer_ID FROM Customer WHERE City='Lahore');
-- Find vehicles belonging to customers with more than 100 loyalty points
SELECT * FROM Vehicle WHERE Customer_ID IN (SELECT Customer_ID FROM Customer WHERE Loyalty_Points>100);
-- Find fuels used in sales with quantity over 50
SELECT * FROM Fuel WHERE Fuel_ID IN (SELECT Fuel_ID FROM Sale_Transaction WHERE Quantity>50);
-- Correlated: customers with at least one sale
SELECT c.* FROM Customer c WHERE EXISTS (SELECT 1 FROM Sale_Transaction s WHERE s.Customer_ID=c.Customer_ID);
-- Correlated: employees whose salary exceeds their gender average
SELECT e.* FROM Employee e WHERE e.Salary > (SELECT AVG(e2.Salary) FROM Employee e2 WHERE e2.Gender=e.Gender);
-- Nested: customer(s) with the highest loyalty points
SELECT * FROM Customer WHERE Loyalty_Points=(SELECT MAX(Loyalty_Points) FROM Customer);
-- Find dispensers connected to tanks storing fuel with above-average price
SELECT * FROM Fuel_Dispenser WHERE Fuel_ID IN (SELECT Fuel_ID FROM Fuel WHERE Price_Per_Litre>(SELECT AVG(Price_Per_Litre) FROM Fuel));
-- Find payments greater than average payment
SELECT * FROM Payment WHERE Payment_Amount>(SELECT AVG(Payment_Amount) FROM Payment);



SELECT 'Customer' AS Table_Name, COUNT(*) AS Total_Rows FROM Customer
UNION ALL SELECT 'Employee', COUNT(*) FROM Employee
UNION ALL SELECT 'Manager', COUNT(*) FROM Manager
UNION ALL SELECT 'Cashier', COUNT(*) FROM Cashier
UNION ALL SELECT 'Cleaner', COUNT(*) FROM Cleaner
UNION ALL SELECT 'Fuel', COUNT(*) FROM Fuel
UNION ALL SELECT 'Fuel_Tank', COUNT(*) FROM Fuel_Tank
UNION ALL SELECT 'Fuel_Dispenser', COUNT(*) FROM Fuel_Dispenser
UNION ALL SELECT 'Supplier', COUNT(*) FROM Supplier
UNION ALL SELECT 'Fuel_Purchase', COUNT(*) FROM Fuel_Purchase
UNION ALL SELECT 'Sale_Transaction', COUNT(*) FROM Sale_Transaction
UNION ALL SELECT 'Payment', COUNT(*) FROM Payment
UNION ALL SELECT 'Vehicle', COUNT(*) FROM Vehicle
UNION ALL SELECT 'Cleaning_Activity', COUNT(*) FROM Cleaning_Activity;

