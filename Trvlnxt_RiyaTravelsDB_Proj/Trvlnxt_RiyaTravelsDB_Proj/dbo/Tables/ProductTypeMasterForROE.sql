CREATE TABLE [dbo].[ProductTypeMasterForROE] (
    [ID]          INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProductName] VARCHAR (50) NULL,
    CONSTRAINT [PK_ProductTypeMasterForROE] PRIMARY KEY CLUSTERED ([ID] ASC)
);

