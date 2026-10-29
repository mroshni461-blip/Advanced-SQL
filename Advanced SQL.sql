create database advance;
use advance;


CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
(1, 'Keyboard', 'Electronics', 1200),
(2, 'Mouse', 'Electronics', 800),
(3, 'Chair', 'Furniture', 2500),
(4, 'Desk', 'Furniture', 5500);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate) VALUES
(1, 1, 4, '2024-01-05'),
(2, 2, 10, '2024-01-06'),
(3, 3, 2, '2024-01-10'),
(4, 4, 1, '2024-01-11');


Q6. Write a CTE to calculate the total revenue for each product 
(Revenues = Price × Quantity), and return only products where  revenue > 3000. 


with revenue_product as ( 
select p.ProductID, p.ProductName , sum(p.price*s.quantity) as revenue_count
from products  p
join sales s on p.productid = s.productid
group by p.ProductID, p.ProductName 
)
select *
from revenue_product
where revenue_count > 3000;


Q7. Create a view named vw_CategorySummary that shows:
Category, TotalProducts, AveragePrice.

create view CategorySummary as 
select category , count(*) as totalproducts, avg(price) as AveragePrice
from products p
group by category ;

select * from CategorySummary ;


Q8. Create an updatable view containing ProductID, ProductName, and Price
Then update the price of ProductID = 1 using the view.

create view product_info as
select ProductID, ProductName,Price
from products;

update product_info
set price = 1300
where productid = 1;


select * from products;

Q9. Create a stored procedure that accepts a category name and returns all products belonging to that 
category.

DELIMITER $$
create procedure getproductbycategory (in categoryname varchar(50))  begin 
select * 
from products
where category =CATEGORYNAME ;
end$$ 
DELIMITER ;


Q10. Create an AFTER DELETE trigger on the  Products table that archives deleted product rows into a new table ProductArchive.
. The archive should store ProductID, ProductName, Category, Price, and DeletedAt timestamp.


CREATE TABLE ProductArchive (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER AfterProductDelete
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive (ProductID, ProductName, Category, Price, DeletedAt)
    VALUES (OLD.ProductID, OLD.ProductName, OLD.Category, OLD.Price, NOW());
END$$
DELIMITER ;


