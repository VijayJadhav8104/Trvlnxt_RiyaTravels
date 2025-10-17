CREATE TABLE [dbo].[IPHistory] (
    [PKId]         BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [IP]           NVARCHAR (20)   NULL,
    [UserId]       INT             NULL,
    [OrderId]      NVARCHAR (30)   NULL,
    [RiyaPNR]      NVARCHAR (10)   NULL,
    [GDSPNR]       NVARCHAR (10)   NULL,
    [ActionRemark] NVARCHAR (1000) NULL,
    [InsertTime]   DATETIME        CONSTRAINT [DF_IPHistory_InsertTime] DEFAULT (getdate()) NULL,
    [Device]       NVARCHAR (20)   NULL,
    [ActionStatus] BIT             NULL,
    CONSTRAINT [PK_IPHistory] PRIMARY KEY CLUSTERED ([PKId] ASC)
);

