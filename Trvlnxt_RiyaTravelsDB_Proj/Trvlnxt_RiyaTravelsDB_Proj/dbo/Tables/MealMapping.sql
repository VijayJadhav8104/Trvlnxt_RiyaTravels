CREATE TABLE [dbo].[MealMapping] (
    [Id]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RiyaMeal_Id]   INT           NULL,
    [VendorMeal_Id] INT           NULL,
    [IsActive]      BIT           NULL,
    [CreatedDate]   DATETIME      NULL,
    [CreatedBy]     NVARCHAR (50) NULL,
    [ModifiedDate]  DATETIME      NULL,
    [ModifiedBy]    NVARCHAR (50) NULL,
    CONSTRAINT [PK_MealMapping] PRIMARY KEY CLUSTERED ([Id] ASC)
);

