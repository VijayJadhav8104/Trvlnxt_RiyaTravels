CREATE TABLE [dbo].[Vendor_Meal] (
    [VendorMeal_Id] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Meal]          VARCHAR (100) NULL,
    [CreatedBy]     NVARCHAR (50) NULL,
    [Isactive]      BIT           NULL,
    [CreatedDate]   DATETIME      NULL,
    [ModifiyDate]   DATETIME      NULL,
    [ModifiedBy]    NVARCHAR (50) NULL,
    CONSTRAINT [PK_Vendor_Meal] PRIMARY KEY CLUSTERED ([VendorMeal_Id] ASC)
);

