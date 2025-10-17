CREATE TABLE [dbo].[MappingHistory] (
    [Id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OrderId]     NVARCHAR (50) NULL,
    [RiyaPNR]     NVARCHAR (10) NULL,
    [Remark]      VARCHAR (500) NULL,
    [ReportBug]   BIT           NULL,
    [UpdatedBy]   VARCHAR (10)  NULL,
    [UpdatedDate] DATETIME      NULL,
    CONSTRAINT [PK_MappingHistory] PRIMARY KEY CLUSTERED ([Id] ASC)
);

