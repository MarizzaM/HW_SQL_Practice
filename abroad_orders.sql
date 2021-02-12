Create Database OrderDB
GO

Use OrderDB
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](50) NOT NULL,
	[COUNTRY_ID] [bigint] NOT NULL,
	[Address] [varchar](50) NULL,
	[ID_NUMBER] [varchar](9) NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CUSTOMER_ID] [bigint] NOT NULL,
	[PRODUCT_ID] [bigint] NOT NULL,
	[QUANTITY] [int] NOT NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](50) NOT NULL,
	[PRICE] [real] NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [dbo].[Country] ON 

INSERT [dbo].[Country] ([ID], [NAME]) VALUES (4, N'FRANCE')
INSERT [dbo].[Country] ([ID], [NAME]) VALUES (1, N'ISRAEL')
INSERT [dbo].[Country] ([ID], [NAME]) VALUES (3, N'JAPAN')
INSERT [dbo].[Country] ([ID], [NAME]) VALUES (2, N'USA')
SET IDENTITY_INSERT [dbo].[Country] OFF
GO

SET IDENTITY_INSERT [dbo].[Customer] ON 

INSERT [dbo].[Customer] ([ID], [NAME], [COUNTRY_ID], [Address], [ID_NUMBER]) VALUES (2, N'BILL GATES', 2, N'New York', N'033759232')
INSERT [dbo].[Customer] ([ID], [NAME], [COUNTRY_ID], [Address], [ID_NUMBER]) VALUES (5, N'JOHN DOE', 4, N'PARIS', N'123456789')
SET IDENTITY_INSERT [dbo].[Customer] OFF
GO

SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([ID], [CUSTOMER_ID], [PRODUCT_ID], [QUANTITY]) VALUES (2, 2, 1, 1)
INSERT [dbo].[Orders] ([ID], [CUSTOMER_ID], [PRODUCT_ID], [QUANTITY]) VALUES (3, 5, 3, 10)
INSERT [dbo].[Orders] ([ID], [CUSTOMER_ID], [PRODUCT_ID], [QUANTITY]) VALUES (4, 5, 2, 243)
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO

SET IDENTITY_INSERT [dbo].[Product] ON 

INSERT [dbo].[Product] ([ID], [NAME], [PRICE]) VALUES (1, N'lAMBURGINI', 500000)
INSERT [dbo].[Product] ([ID], [NAME], [PRICE]) VALUES (2, N'PENCIL', 0.5)
INSERT [dbo].[Product] ([ID], [NAME], [PRICE]) VALUES (3, N'COMPUTER CHAIR', 1500)
SET IDENTITY_INSERT [dbo].[Product] OFF
GO

ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_PRICE]  DEFAULT ((0)) FOR [PRICE]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Country] FOREIGN KEY([COUNTRY_ID])
REFERENCES [dbo].[Country] ([ID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Country]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_ORDERS_CUSTOMER] FOREIGN KEY([CUSTOMER_ID])
REFERENCES [dbo].[Customer] ([ID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_ORDERS_CUSTOMER]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_ORDERS_PRODUCT] FOREIGN KEY([PRODUCT_ID])
REFERENCES [dbo].[Product] ([ID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_ORDERS_PRODUCT]
GO

/*--1. find the most expensive product*/

SELECT TOP 1*
FROM Product
ORDER BY PRICE DESC

/*-- 2. find how many quantity have been purchased for the most price product *etgar*/


/*-- 3. find customers which bought products (join)*/

SELECT Customer.NAME
FROM Orders
INNER JOIN Customer ON Orders.CUSTOMER_ID=Customer.ID;

/*-- 4. find how many customers leave in each country (name)*/

SELECT Country.NAME, COUNT(Customer.ID)  AS CountOfCustInCountry
from Customer
INNER JOIN Country ON Customer.COUNTRY_ID = Country.ID
GROUP BY Country.NAME

/*-- 5. find how many orders per country*/

SELECT Country.NAME, COUNT(Orders.ID)  AS CountOfOrdersInCountry
from Customer
INNER JOIN Country ON Customer.COUNTRY_ID = Country.ID
INNER JOIN Orders ON Orders.CUSTOMER_ID=Customer.ID
GROUP BY Country.NAME

/*-- 6. find how many quantity per country*/

SELECT Country.NAME, sum(Orders.QUANTITY)  AS QUANTITYInCountry
from Customer
INNER JOIN Country ON Customer.COUNTRY_ID = Country.ID
INNER JOIN Orders ON Orders.CUSTOMER_ID=Customer.ID
GROUP BY Country.NAME

/*-- 7. sum of total amount of all orders (price X quantity) *etgar*/

SELECT sum(Orders.QUANTITY * Product.PRICE)
from Customer
INNER JOIN Country ON Customer.COUNTRY_ID = Country.ID
INNER JOIN Orders ON Orders.CUSTOMER_ID=Customer.ID
INNER JOIN Product ON Orders.PRODUCT_ID=Product.ID
