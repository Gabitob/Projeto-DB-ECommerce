create database ecommerce;
use ecommerce;

-- customer login
create table LoginClients(
idLoginClient int auto_increment primary key,
userName varchar(45) not null unique,
passwords char(10) not null,
lastLogin timestamp
);

-- customersCNPJ
create table ClientsCNPJ(
idClientCNPJ int auto_increment primary key,
idLClientCNPJ int not null,
companyName varchar(45) not null,
CNPJ char(14) not null,
tradingName varchar(45) not null,
address varchar(255) not null,
contact char(11),
email varchar(50) not null,
constraint unique_client_cnpj unique(CNPJ),
constraint fk_clientcnpj_login foreign key(idLClientCNPJ) references LoginClients(idLoginClient)
);
	
-- customersCPF
create table ClientsCPF(
idClientCPF int auto_increment primary key,
idLClientCPF int not null,
Fname varchar(10) not null,
Minit varchar(5) not null,
Lname varchar(20) not null,
CPF char(11) not null,
Bdate date not null,
address varchar(255) not null,
contact char(11),
email varchar(50) not null,
constraint unique_client_cpf unique(CPF),
constraint fk_clientcpf_login foreign key(idLClientCPF) references LoginClients(idLoginClient)
);

-- request
create table Orders(
idOrder int auto_increment primary key,
idOloginclient int,
orderStatus enum('Canceled','Confirmed','Processing') default 'Processing',
orderDescription varchar(255),
shippingValue float default 10,
shippingDate date not null,
trackingCode char(15) not null,
constraint fk_order_loginclient foreign key(idOloginclient) references LoginClients(idLoginClient)
);



-- shipping
create table Shipping(
idSloginClient int,
idSorder int,
shippingStatus enum('In transport','Delivered','Lost'),
constraint fk_shipping_loginclient foreign key(idSloginClient) references LoginClients(idLoginClient),
constraint fk_shipping_order foreign key(idSorder) references Orders(idOrder)
);

-- products
create table Products(
idProduct int auto_increment primary key,
Pname varchar(45) not null,
descreption varchar(255) not null,
classification_kids boolean default false,
category enum('Electronic','Clothes','Toys','Tools','Foods') not null,
dimension varchar(10),
rating float default 0
);

-- order/product ratio
create table ProductsOrders(
idPOproduct int,
idPOorder int,
poQuantity int default 1,
poStatus enum('Available','Unavailable'),
primary key(idPOproduct, idPoOrder),
constraint fk_product_product foreign key(idPOproduct) references Products(idProduct),
constraint fk_product_order foreign key(idPOorder) references Orders(idOrder)
);


-- seller
create table Seller(
idSeller int auto_increment primary key,
companyName varchar(255),
CNPJ char(14) not null,
CPF char(11) not null,
tradingName varchar(45),
address varchar(255),
contact char(11) not null,
constraint unique_seller_cnpj unique(CNPJ),
constraint unique_seller_cpf unique(CPF)
);



-- product/seller relationship
create table ProductSeller(
idPseller int,
idPproduct int,
quantity int default 1,
primary key(idPseller, idPproduct),
constraint fk_product_seller foreign key(idPseller) references Seller(idSeller),
constraint fk_products_product foreign key(idPproduct) references Products(idProduct)
);

-- inventory
create table Inventory(
idInventory int auto_increment primary key,
inventoryLocation varchar(255),
quantity int default 0
);

-- product/inventory ratio
create table ProductsInventory(
idPinventory int,
idIproduct int,
quantity int default 1,
primary key(idPinventory, idIproduct),
constraint fk_product_inventory foreign key(idPinventory) references Products(idProduct),
constraint fk_inventory_product foreign key(idIproduct) references Inventory(idInventory)
);

-- provider
create table Supplier(
idSupplier int auto_increment primary key,
companyName varchar(60) not null,
CNPJ CHAR(14) not null,
trading varchar(20) not null,
address varchar(255) not null,
contact char(11)
);

-- product/supplier relationship
create table productsSupplier(
idPOsupplier int,
idPOproduct int,
quantity int default 0,
primary key(idPOsupplier, idPOproduct),
constraint fk_product_supplier foreign key (idPOsupplier) references Supplier(idSupplier),
constraint fk_supplier_product foreign key(idPOproduct) references Products(idProduct)
);

-- payment methods
create table Payments(
idPayment int auto_increment primary key,
idPayOrder int,
idPayproduct int,
typePayment enum('Cash','CreditCard') default 'CreditCard',
totalPrice decimal(5,2) not null,
paymentStatus enum('Authorized','Not Authorized','Processing','Chargeback') default 'Processing',
constraint fk_pay_order foreign key(idPayOrder) references Orders(idOrder),
constraint fk_pay_product foreign key(idPayproduct) references Products(idProduct)
);

-- credit card payment
create table CreditCard(
idCredicard int auto_increment primary key,
idPayCredCard int,
credCardFlag varchar(20) not null,
cardNumber char(16) not null,
expirationDate date not null,
cardHolderName varchar(45) not null,
securityCode char(3) not null,
constraint fk_pay_creditcard foreign key(idPayCredCard) references Payments(idPayment)
);

-- payment with cash/Pix
create table Cash(
idCash int auto_increment primary key,
idPayCash int,
pix enum('Pix CPF','Pix email','Pix cellphone','Pix random'),
constraint fk_pay_cash foreign key(idPayCash) references Payments(idPayment)
);

-- insert

INSERT INTO LoginClients
values 
	(1,'nivaldo','njtsb1','2022-09-10 15:50'),
    (2,'jose','njtsb2','2022-09-10 15:51'),
	(3,'tadeu','njtsb3','2022-09-10 15:52'),
	(4,'lossantos','njtsb4','2022-09-10 15:53'),
	(5,'beirao','njtsb5','2022-09-10 15:54'),
	(6,'makro','mkr01','2022-09-10 15:55'),
    (7,'martins','mrt02','2022-09-10 15:56'),
	(8,'viavarejo','via03','2022-09-10 15:57'),
	(9,'magalu','magalu04','2022-09-10 15:58'),
	(10,'Casa&Cia','C&C05','2022-09-10 15:59');

INSERT INTO ClientsCNPJ
values (1,1,'Antero F. Junior',12345678901, 'Makro Atacadista','SP-270, Jardim Novo Mundo, Sorocaba', 789456123,'makroatacadista@gmail.com'),
	   (2,2,'Rubens B. Martins',12345678902, 'Martins Distribuidor', 'Avenida José Andraus Gassani, 10, Uberlândia', 789123456,'martinsdistribuidor@gmail.com'),
       (3,3,'Raphael O. Klein',12345678903, 'Via Varejo', 'Rua Samuel Klein, 93, São Caetano do Sul', 456789123,'viavarejo@gmail.com'),
	   (4,4,'Luiza H. Trajano',12345678904, 'Magazine Luiza', 'Avenida Rio Negro, 1100, Franca', 456123789,'magalu@gmail.com'),
	   (5,5,'Antonio C. TERTULIANO',12345678905, 'Casa & Cia Utilidades', 'Avenida Dr. Armando Pannunzio, 1180, Sorocaba', 123789456,'casaecia@gmail.com');

INSERT INTO ClientsCPF
values (1,1,'Nivaldo','J','Tadeu',01234567890,'1990-09-12','Rua Joao Nagliatti, 220, Miracatu',123456789,'nivaldo@hotmail.com'),
       (2,2,'Jose','T','Nivaldo',12345678901,'1989-01-07','Rua Joao Nagliatti, 280, Miracatu',234567890,'jose@gmail.com'),
       (3,3,'Tadeu','S','Jose',23456789012,'1997-02-01','Rua Quatro, 440, Miracatu',3456789012,'tadeu@hotmail.com'),
       (4,4,'Los Santos','B','Beirao',34567890123,'2007-11-26','Rua Candido dos Santos Coelho, 440, Miracatu',4567890123,'lossantos@gmail.com'),
       (5,4,'Beirao','N','Santos',45678901234,'2011-12-01','Vila Kamaitti, 440, Miracatu',5678901234,'beirao@gmail.com');

INSERT INTO Orders
Values
	(default,1,'Confirmed','1x Tênis Adidas',10,'2022-09-12','BR2345678901234'),
	(default,2,Default,'2x Camiseta Nike',20,'2022-09-12','BR1234567890123'),
	(default,3,'Confirmed','1x Geladeira Brastemp',10,'2022-09-12','BR0123456789012'),
	(default,4,'Canceled','1x Carrinho Hot Wheels',10,'2022-09-12','BR3456789012345'),
	(default,5,'Confirmed','1x TV Samsung 50',10,'2022-09-12','BR4567890123456'),
    (default,6,'Confirmed','5x Tênis Nike',50,'2022-09-12','BR5678901234567'),
	(default,7,Default,'10x Camiseta Nike',100,'2022-09-12','BR6789012345678'),
	(default,8,'Confirmed','5x TV LG 55',500,'2022-09-12','BR7890123456789'),
	(default,9,'Canceled','15x Jogo de Chaves Tramontina ',150,'2022-09-12','BR8901234567890'),
	(default,10,'Confirmed','6x Geladeira Eletrolux 345l',60,'2022-09-12','BR9012345678901');

INSERT INTO Shipping
values
		(1, default,'In transport'),
		(2,default,'Delivered'),
		(3,default,'Lost'),
		(4,default,'Delivered'),
		(5,default,'In Transport'),
        (6, default,'In transport'),
		(7,default,'Delivered'),
		(8,default,'Lost'),
		(9,default,'Delivered'),
		(10,default,'In Transport');


INSERT INTO Supplier
VALUES
	(1,'O Feirão do Sapato',78901234567890,'FEIRAO DO SAPATO','Avenida Prefeito Jonas Banks Leite, 907, Registro',10987654321),
    (2,'Kedar Empreendimentos e Participacoes S.A.',78990123456789,'KEDAR','Avenida Queiroz Filho, 1700, SAO PAULO',21098765432),
    (3,'SAMSUNG ELETRÔNICA LTDA',78989012345678,'SAMSUNG','Avenida Antônio Cândido Machado, 3100, Cajamar',32109876543),
    (4,'Caedu Moda',78978901234567,'CAEDU','Avenida Prefeito Jonas Banks Leite, 861, Registro',43210987654),
    (5,'Mattel Inc.',78967890123456,'Hot Wheels', 'Rua Verbo Divino, 1488, São Paulo',54321098765);

INSERT INTO Seller
Values
	(1,'Neoenergia Elektro Eletricidade E Servicos S A',78901234567890,98765432109,'ELEKTRO','Rua Ary Antenor de SILVA, 321, Campinas',01234567890),
	(2,'O Feirão do Sapato',78912345678901,87654321098,'FEIRAO DO SAPATO','Rua Doutor Emílio Martins Ribeiro, 161, Miracatu',12345678901),
	(3,'BANRISUL S.A.',78923456789012,76543210987,'BANRISUL','Rua Capitão Montanha, 177, Porto Alegre',23456789012),
	(4,'Silibonde Indústria Comércio Produtos Químicos',78934567890123,65432109876,'SILIBONDE','Avenida Guinle, 1059, Guarulhos',34567890123),
	(5,'Subway',78945678901234,54321098765,'SUBWAY','Avenida Clara Gianotti de SILVA, 258, Registro',45678901234);

INSERT INTO Products
values
	(1,'Tênis Adidas','Nº43, Preto com Vermelho',False,'Clothes','Nº41','5'),
	(2,'Camiseta Nike','Branca',False,'Clothes','M','5'),
	(3,'Geladeira Brastemp FROSTFREE','Cinza, 345L',False,'Electronic','60x60x1,90','5'),
	(4,'Carrinho Hot Wheels','Coleção Hot',True,'Toys','4cm','5'),
	(5,'TV Samsung 50','4K, 2x usb, 3x HDMI, Tela infinita',False,'Electronic','55x110x05','5'),
    (6,'Tênis Nike','Nº39, Preto com Vermelho',False,'Clothes','Nª39','5'),
	(7,'Camiseta Nike','Cinza',False,'Clothes','M','5'),
	(8,'TV LG 55','4K, LED',False,'Electronic','55x150x05','5'),
	(9,'Jogo de Chaves Tarmontina','Bold, Inox',False,'Tools','60x50x50','5'),
	(10,'Geladeira Eletrolux FROSTFREE','Inox, 380l',False,'Electronic','60x60x200','5');  
    
INSERT INTO Inventory
values
	(1,'Porto Alegre',32),
	(2,'Belo Horizonte',44),
	(3,'Salvador',100),
	(4,'Manaus',40),
	(5,'Cuiabá',60);

INSERT INTO ProductsInventory
Values
	(1,1,25),
    (2,2,10),
    (3,3,60),
    (4,4,80),
    (5,5,default);

INSERT INTO productsSupplier
VALUES
	(1,1,2000),
    (2,2,1700),
    (3,3,500),
    (4,4,2500),
    (5,5,1000);

INSERT INTO ProductsOrders
Values
	(1,1,10,'Available'),
	(2,2,20,'Available'),
	(3,3,10,'Available'),
	(4,4,0,'Unavailable'),
	(5,5,16,'Available'),
	(6,6,10,'Available'),
	(7,7,20,'Available'),
	(8,8,10,'Available'),
	(9,9,15,'Available'),
	(10,10,16,'Available');


INSERT INTO Payments
VALUES
	(1,1,1,'CreditCard',179.00,'Authorized'),
    (2,2,2,'Cash',360.00,'Authorized'),
    (3,3,3,'CreditCard',559.00,'Not Authorized'),
    (4,4,4,default,769.00,'Chargeback'),
    (5,5,5,'CreditCard',780.90,'Authorized'),
    (6,6,6,'CreditCard',379.00,'Authorized'),
    (7,7,7,'Cash',360.00,'Authorized'),
    (8,8,8,'CreditCard',555.00,'Not Authorized'),
    (9,9,9,default,469.00,'Processing'),
    (10,10,10,'CreditCard',790.90,'Authorized');

INSERT INTO CreditCard
VALUES
	(1,1,'MasterCard',1234567890123456,'2022-09-15','SEVERINO S SILVA',656),
    (2,2,'Visa',0123456789012345,'2022-09-15','EDUARDO V RIBEIRO',989),
    (3,3,'America Express',2345678901234567,'2022-09-15','AMANDA G QUEIROZ',102),
    (4,4,'ELO',9012345678901234,'2022-09-15','RITA C TERTULIANO',234),
    (5,5,'MasterCard',3456789012345678,'2022-09-15','ANTONIO T SOUZA',432);

INSERT INTO Cash
VALUES
	(1,1,'PIX CPF'),
    (2,2,'PIX email'),
    (3,3,'PIX CPF'),
    (4,4,'PIX cellphone'),
    (5,5,'PIX random');
    
-- QUERIES

select * from Orders o, ProductsOrders p where o.idOrder = idPOorder;

SELECT Fname AS nome, Lname AS sobrenome, email AS email, address as endereço, idClientcpf as n_cliente FROM clientscpf order by lname;

select * from LoginClients l, Orders o where l.idLoginClient = idOloginClient;

select concat(Fname,' ',Lname) as Client, idOrder, orderStatus from ClientsCPF c, Orders o where idClientCPF = idOLoginClient;

select * from Orders o, Payments p where o.idOrder = idPayOrder;
    
Select * from LoginClients inner join Orders on IdLoginClient = idOloginClient;
							
select * from LoginClients l inner join Orders o on l.idLoginClient = o.idOloginClient
							 inner join productsOrders p on p.idPOorder = o.idOrder;
					                    
select CNPJ, companyName from Seller;

select * from seller s, products p where s.idseller = idproduct;

select * from payments p, Creditcard c where p.idPayment= idpayCredcard;