CREATE TABLE [dbo].[SedularWorkingUpdate] (
    [Id]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [InsertedDate]  DATETIME      NULL,
    [SchedulerName] VARCHAR (100) NULL,
    [SupplierName]  VARCHAR (100) NULL,
    CONSTRAINT [PK_SedularWorkingUpdate] PRIMARY KEY CLUSTERED ([Id] ASC)
);

