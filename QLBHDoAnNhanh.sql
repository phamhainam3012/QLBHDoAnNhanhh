CREATE DATABASE QLBHDoAnNhanh;
GO

USE QLBHDoAnNhanh;
GO

--DROP TABLE dbo.BillInfo
--DROP TABLE dbo.Bill
--DROP TABLE dbo.Food
--DROP TABLE dbo.FoodCategory
--DROP TABLE dbo.TableFood

-------------------------------------------------------------------------------------

----------------ACCOUNT-----------------------

CREATE TABLE Account
    (
      UserName NVARCHAR(100) PRIMARY KEY ,
      Password NVARCHAR(1000) NOT NULL
                              DEFAULT 0 ,
      DisplayName NVARCHAR(100) NOT NULL
                                DEFAULT N'K19 2' ,
      Type INT NOT NULL
               DEFAULT 0 -- 1: admin && 0:staff
    );
GO

INSERT  dbo.Account
        ( UserName, Password, DisplayName, Type )
VALUES  ( N'admin', N'1', N'Quan Tri Vien', 1 ),
        ( N'NguyenVanA', N'1', N'Nguyen Van A', 0 );
GO

CREATE PROC USP_UpdateAccount
    @userName NVARCHAR(100) ,
    @displayName NVARCHAR(100) ,
    @password NVARCHAR(100) ,
    @newPassword NVARCHAR(100)
AS
    BEGIN
        DECLARE @isRightPass INT = 0;
	
        SELECT  @isRightPass = COUNT(*)
        FROM    dbo.Account
        WHERE   UserName = @userName
                AND Password = @password;
	
        IF ( @isRightPass = 1 )
            BEGIN
                IF ( @newPassword = NULL
                     OR @newPassword = ''
                   )
                    BEGIN
                        UPDATE  dbo.Account
                        SET     DisplayName = @displayName
                        WHERE   UserName = @userName;
                    END;		
                ELSE
                    UPDATE  dbo.Account
                    SET     DisplayName = @displayName ,
                            Password = @newPassword
                    WHERE   UserName = @userName;
            END;
    END;
GO

----------------TABLEFOOD-----------------------

CREATE TABLE TableFood
    (
      ID INT IDENTITY
             PRIMARY KEY ,
      Name NVARCHAR(100) DEFAULT N'Chưa đặt tên' ,
      Status NVARCHAR(100) NOT NULL
                           DEFAULT N'Trống' -- Trống || Có người
    );
GO

DECLARE @i INT = 1;
WHILE @i <= 10
    BEGIN
        INSERT  dbo.TableFood
                ( Name )
        VALUES  ( N'Bàn ' + CAST(@i AS NVARCHAR(100)) );
        SET @i = @i + 1;
    END;
GO

----------------BILL-----------------------

CREATE TABLE Bill
    (
      ID INT IDENTITY
             PRIMARY KEY ,
      DateCheckIn DATE NOT NULL
                       DEFAULT GETDATE() ,
      DateCheckOut DATE ,
      IDTable INT NOT NULL ,
      Status INT NOT NULL
                 DEFAULT 0 , --1: đã thanh toán && 0: chưa thanh toán
      FOREIGN KEY ( IDTable ) REFERENCES dbo.TableFood ( ID )
    );
GO


INSERT  dbo.Bill
        ( DateCheckIn, DateCheckOut, IDTable, Status )
VALUES  ( GETDATE(), NULL, 3, 0 ),
        ( GETDATE(), NULL, 4, 0 ),
        ( GETDATE(), GETDATE(), 5, 1 );
GO

ALTER TABLE dbo.Bill ADD Discount INT DEFAULT 0;
GO

UPDATE  dbo.Bill
SET     Discount = 0;
GO

ALTER TABLE dbo.Bill ADD TotalPrice FLOAT DEFAULT 0;
GO

CREATE PROC usp_GetListBillByDate
    @checkin DATE ,
    @checkout DATE
AS
    BEGIN
        SELECT  T.Name N'Tên bàn' ,
                B.TotalPrice N'Tổng tiền' ,
                B.DateCheckIn N'Ngày vào' ,
                B.DateCheckOut N'Ngày ra' ,
                B.Discount N'Giảm giá'
        FROM    dbo.Bill B ,
                dbo.TableFood T
        WHERE   B.DateCheckIn >= @checkin
                AND B.DateCheckOut <= @checkout
                AND B.Status = 1
                AND B.IDTable = T.ID;
    END;
GO

----------------FOODCATEGORY-----------------------

CREATE TABLE FoodCategory
    (
      ID INT IDENTITY
             PRIMARY KEY ,
      Name NVARCHAR(100) NOT NULL
                         DEFAULT N'Chưa đặt tên',
    );
GO

INSERT  dbo.FoodCategory
        ( Name )
VALUES  ( N'Hải sản' ),
        ( N'Nông sản' ),
        ( N'Lâm sản' ),
        ( N'Sản sản' ),
        ( N'Nước' );
 GO

----------------FOOD-----------------------

CREATE TABLE Food
    (
      ID INT IDENTITY
             PRIMARY KEY ,
      Name NVARCHAR(100) NOT NULL
                         DEFAULT N'Chưa đặt tên' ,
      IDCategory INT NOT NULL ,
      Price FLOAT NOT NULL
                  DEFAULT 0 ,
      FOREIGN KEY ( IDCategory ) REFERENCES dbo.FoodCategory ( ID )
    );
GO

INSERT  dbo.Food
        ( Name, IDCategory, Price )
VALUES  ( N'Mực một nắng nước sa tế', 1, 120000 ),
        ( N'Nghêu hấp xả', 1, 50000 ),
        ( N'Dú dê nướng sữa', 2, 60000 ),
        ( N'Heo rừng nướng muối ớt', 3, 75000 ),
        ( N'Cơm chiên mushi', 4, 999999 ),
        ( N'7Up', 5, 15000 ),
        ( N'Cafe', 5, 12000 );
 GO
----------------BILLINFO-----------------------

CREATE TABLE BillInfo
    (
      ID INT IDENTITY
             PRIMARY KEY ,
      IDBill INT NOT NULL ,
      IDFood INT NOT NULL ,
      Count INT NOT NULL
                DEFAULT 0 ,
      FOREIGN KEY ( IDBill ) REFERENCES dbo.Bill ( ID ) ,
      FOREIGN KEY ( IDFood ) REFERENCES dbo.Food ( ID )
    );
GO

INSERT  dbo.BillInfo
        ( IDBill, IDFood, Count )
VALUES  ( 1, 1, 2 ),
        ( 1, 3, 4 ),
        ( 1, 5, 1 ),
        ( 2, 1, 2 ),
        ( 2, 6, 2 ),
        ( 3, 5, 2 );         
GO

-------------------------------STORED PROCEDURES------------------------------------------------------

----------------LOGIN-----------------------

CREATE PROC usp_Login
    @username NVARCHAR(100) ,
    @password NVARCHAR(100)
AS
    BEGIN
        SELECT  *
        FROM    dbo.Account
        WHERE   UserName = @username
                AND Password = @password;
    END;
GO

EXEC dbo.usp_Login @username = N'admin', @password = N'1';
GO

----------------GetAccountByUserName-----------------------

CREATE PROC usp_GetAccountByUserName
    @username NVARCHAR(100)
AS
    BEGIN
        SELECT  *
        FROM    dbo.Account
        WHERE   UserName = @username;
    END;
GO

EXEC dbo.usp_GetAccountByUserName @username = N'admin';
GO

----------------GetTableList-----------------------

CREATE PROC usp_GetTableList
AS
    SELECT  *
    FROM    dbo.TableFood;
GO

EXEC dbo.usp_GetTableList;
GO


----------------InsertBill-----------------------

CREATE PROC usp_InsertBill @idTable INT
AS
    BEGIN
        INSERT  dbo.Bill
                ( DateCheckIn ,
                  DateCheckOut ,
                  IDTable ,
                  Status ,
                  Discount
                )
        VALUES  ( GETDATE() ,
                  NULL ,
                  @idTable ,
                  0 ,
                  0
                );
    END;
GO

----------------InsertBillInfo-----------------------

CREATE PROC usp_InsertBillInfo
    @idBill INT ,
    @idFood INT ,
    @count INT
AS
    BEGIN
		
        DECLARE @isExitsBillInfo INT;
        DECLARE @foodCount INT = 1;

        SELECT  @isExitsBillInfo = ID ,
                @foodCount = Count
        FROM    dbo.BillInfo
        WHERE   IDBill = @idBill
                AND IDFood = @idFood;

        IF ( @isExitsBillInfo > 0 )
            BEGIN
                DECLARE @newCount INT = @foodCount + @count;
                IF ( @newCount > 0 )
                    UPDATE  dbo.BillInfo
                    SET     Count = @foodCount + @count
                    WHERE   IDFood = @idFood;
                ELSE
                    DELETE  dbo.BillInfo
                    WHERE   IDBill = @idBill
                            AND IDFood = @idFood;
            END;
        ELSE
            BEGIN
                INSERT  dbo.BillInfo
                        ( IDBill, IDFood, Count )
                VALUES  ( @idBill, -- IDBill - int
                          @idFood, -- IDFood - int
                          @count  -- Count - int
                          );
            END;	
    END;
GO

--
CREATE PROC usp_SwitchTable
    @idTable1 INT ,
    @idTable2 INT
AS
    BEGIN

        DECLARE @idFirstBill INT;
        DECLARE @idSeconrdBill INT;
	
        DECLARE @isFirstTablEmty INT = 1;
        DECLARE @isSecondTablEmty INT = 1;
	
	
        SELECT  @idSeconrdBill = ID
        FROM    dbo.Bill
        WHERE   IDTable = @idTable2
                AND Status = 0;
        SELECT  @idFirstBill = ID
        FROM    dbo.Bill
        WHERE   IDTable = @idTable1
                AND Status = 0;
	
        PRINT @idFirstBill;
        PRINT @idSeconrdBill;
        PRINT '-----------';
	
        IF ( @idFirstBill IS NULL )
            BEGIN
                PRINT '0000001';
                INSERT  dbo.Bill
                        ( DateCheckIn ,
                          DateCheckOut ,
                          IDTable ,
                          Status
		                )
                VALUES  ( GETDATE() , -- DateCheckIn - date
                          NULL , -- DateCheckOut - date
                          @idTable1 , -- idTable - int
                          0  -- status - int
		                );
		        
                SELECT  @idFirstBill = MAX(ID)
                FROM    dbo.Bill
                WHERE   IDTable = @idTable1
                        AND Status = 0;
		
            END;
	
        SELECT  @isFirstTablEmty = COUNT(*)
        FROM    dbo.BillInfo
        WHERE   IDBill = @idFirstBill;
	
        PRINT @idFirstBill;
        PRINT @idSeconrdBill;
        PRINT '-----------';
	
        IF ( @idSeconrdBill IS NULL )
            BEGIN
                PRINT '0000002';
                INSERT  dbo.Bill
                        ( DateCheckIn ,
                          DateCheckOut ,
                          IDTable ,
                          Status
		                )
                VALUES  ( GETDATE() , -- DateCheckIn - date
                          NULL , -- DateCheckOut - date
                          @idTable2 , -- idTable - int
                          0  -- status - int
		                );
                SELECT  @idSeconrdBill = MAX(ID)
                FROM    dbo.Bill
                WHERE   IDTable = @idTable2
                        AND Status = 0;
		
            END;
	
        SELECT  @isSecondTablEmty = COUNT(*)
        FROM    dbo.BillInfo
        WHERE   IDBill = @idSeconrdBill;
	
        PRINT @idFirstBill;
        PRINT @idSeconrdBill;
        PRINT '-----------';

        SELECT  ID
        INTO    IDBillInfoTable
        FROM    dbo.BillInfo
        WHERE   IDBill = @idSeconrdBill;
	
        UPDATE  dbo.BillInfo
        SET     IDBill = @idSeconrdBill
        WHERE   IDBill = @idFirstBill;
	
        UPDATE  dbo.BillInfo
        SET     IDBill = @idFirstBill
        WHERE   ID IN ( SELECT  *
                        FROM    IDBillInfoTable );
	
        DROP TABLE IDBillInfoTable;
	
        IF ( @isFirstTablEmty = 0 )
            UPDATE  dbo.TableFood
            SET     Status = N'Trống'
            WHERE   ID = @idTable2;
		
        IF ( @isSecondTablEmty = 0 )
            UPDATE  dbo.TableFood
            SET     Status = N'Trống'
            WHERE   ID = @idTable1;
    END;
GO

CREATE FUNCTION [dbo].[fuConvertToUnsign1]
    (
      @strInput NVARCHAR(4000)
    )
RETURNS NVARCHAR(4000)
AS
    BEGIN
        IF @strInput IS NULL
            RETURN @strInput;
        IF @strInput = ''
            RETURN @strInput;
        DECLARE @RT NVARCHAR(4000);
        DECLARE @SIGN_CHARS NCHAR(136);
        DECLARE @UNSIGN_CHARS NCHAR(136);
        SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ'
            + NCHAR(272) + NCHAR(208);
        SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD';
        DECLARE @COUNTER INT;
        DECLARE @COUNTER1 INT;
        SET @COUNTER = 1;
        WHILE ( @COUNTER <= LEN(@strInput) )
            BEGIN
                SET @COUNTER1 = 1;
                WHILE ( @COUNTER1 <= LEN(@SIGN_CHARS) + 1 )
                    BEGIN
                        IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1, 1)) = UNICODE(SUBSTRING(@strInput,
                                                              @COUNTER, 1))
                            BEGIN
                                IF @COUNTER = 1
                                    SET @strInput = SUBSTRING(@UNSIGN_CHARS,
                                                              @COUNTER1, 1)
                                        + SUBSTRING(@strInput, @COUNTER + 1,
                                                    LEN(@strInput) - 1);
                                ELSE
                                    SET @strInput = SUBSTRING(@strInput, 1,
                                                              @COUNTER - 1)
                                        + SUBSTRING(@UNSIGN_CHARS, @COUNTER1,
                                                    1) + SUBSTRING(@strInput,
                                                              @COUNTER + 1,
                                                              LEN(@strInput)
                                                              - @COUNTER);
                                BREAK;
                            END;
                        SET @COUNTER1 = @COUNTER1 + 1;
                    END;
                SET @COUNTER = @COUNTER + 1;
            END;
        SET @strInput = REPLACE(@strInput, ' ', '-');
        RETURN @strInput;
    END;
GO


----------------------------------

CREATE TRIGGER UTG_UpdateBillInfo ON dbo.BillInfo
    FOR INSERT, UPDATE
AS
    BEGIN
        DECLARE @idBill INT;
	
        SELECT  @idBill = IDBill
        FROM    Inserted;
	
        DECLARE @idTable INT;
	
        SELECT  @idTable = IDTable
        FROM    dbo.Bill
        WHERE   ID = @idBill
                AND Status = 0;

        DECLARE @count INT;
        SELECT  @count = COUNT(*)
        FROM    dbo.BillInfo
        WHERE   IDBill = @idBill;

        IF ( @count > 0 )
            BEGIN
                UPDATE  dbo.TableFood
                SET     Status = N'Có người'
                WHERE   ID = @idTable;
            END;
        ELSE
            BEGIN
                UPDATE  dbo.TableFood
                SET     Status = N'Trống'
                WHERE   ID = @idTable;
            END;
    END;
GO

--
CREATE TRIGGER UTG_UpdateBill ON dbo.Bill
    FOR UPDATE
AS
    BEGIN
        DECLARE @idBill INT;
	
        SELECT  @idBill = ID
        FROM    Inserted;	
	
        DECLARE @idTable INT;
	
        SELECT  @idTable = IDTable
        FROM    dbo.Bill
        WHERE   ID = @idBill;
	
        DECLARE @count INT = 0;
	
        SELECT  @count = COUNT(*)
        FROM    dbo.Bill
        WHERE   IDTable = @idTable
                AND Status = 0;
	
        IF ( @count = 0 )
            UPDATE  dbo.TableFood
            SET     Status = N'Trống'
            WHERE   ID = @idTable;
    END;
GO



CREATE TRIGGER UTG_DeleteBillInfo ON dbo.BillInfo
    FOR DELETE
AS
    BEGIN
        DECLARE @idBillInfo INT;
        DECLARE @idBill INT;
        SELECT  @idBillInfo = ID ,
                @idBill = Deleted.IDBill
        FROM    Deleted;
	
        DECLARE @idTable INT;
        SELECT  @idTable = IDTable
        FROM    dbo.Bill
        WHERE   ID = @idBill;
	
        DECLARE @count INT = 0;
	
        SELECT  @count = COUNT(*)
        FROM    dbo.BillInfo AS bi ,
                dbo.Bill AS b
        WHERE   b.ID = bi.IDBill
                AND b.ID = @idBill
                AND b.Status = 0;
	
        IF ( @count = 0 )
            UPDATE  dbo.TableFood
            SET     Status = N'Trống'
            WHERE   ID = @idTable;
    END;
GO


-------------------------------------------------------------------------------------

-- Test SQL Injection
--SELECT  *
--FROM    dbo.Account
--WHERE   UserName = N'admin'
--        AND Password = N'1 '
--        OR 1 = 1;
--GO

--SELECT  *
--FROM    dbo.Bill;