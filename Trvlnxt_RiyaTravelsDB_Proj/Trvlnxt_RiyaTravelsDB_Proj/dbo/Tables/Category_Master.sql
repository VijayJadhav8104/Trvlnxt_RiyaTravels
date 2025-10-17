CREATE TABLE [dbo].[Category_Master] (
    [Id]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [C_Id]          INT           NOT NULL,
    [Category_Name] VARCHAR (255) NULL,
    [Category_Code] VARCHAR (10)  NULL,
    CONSTRAINT [PK__Category__3214EC07239AE34C] PRIMARY KEY CLUSTERED ([Id] ASC)
);

