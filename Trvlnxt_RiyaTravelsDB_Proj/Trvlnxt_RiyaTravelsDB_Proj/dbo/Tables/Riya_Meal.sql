CREATE TABLE [dbo].[Riya_Meal] (
    [RiyaMeal_Id] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Meal]        VARCHAR (100) NULL,
    [CreatedBy]   NVARCHAR (50) NULL,
    [IsActive]    BIT           NULL,
    [CreatedDate] DATETIME      NULL,
    [ModifiyDate] DATETIME      NULL,
    [ModifiedBy]  NVARCHAR (50) NULL,
    CONSTRAINT [PK_Riya_Meal] PRIMARY KEY CLUSTERED ([RiyaMeal_Id] ASC)
);

