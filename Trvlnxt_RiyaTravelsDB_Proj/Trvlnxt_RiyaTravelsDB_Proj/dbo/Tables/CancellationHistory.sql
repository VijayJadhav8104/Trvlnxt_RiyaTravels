CREATE TABLE [dbo].[CancellationHistory] (
    [PKId]               INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OrderId]            VARCHAR (30)    NULL,
    [RiyaPNR]            VARCHAR (10)    NULL,
    [FlagType]           VARCHAR (50)    NULL,
    [Panelty]            DECIMAL (18)    NULL,
    [Markup]             DECIMAL (18)    NULL,
    [Remark]             VARCHAR (500)   NULL,
    [UpdatedBy]          INT             NULL,
    [UpdateDate]         DATETIME        CONSTRAINT [DF_CancellationHistory_UpdateDate] DEFAULT (getdate()) NULL,
    [IsActive]           BIT             CONSTRAINT [DF_CancellationHistory_Status] DEFAULT ((1)) NULL,
    [RefundId]           VARCHAR (30)    NULL,
    [RefundAmount]       DECIMAL (18, 2) NULL,
    [GDSPNR]             VARCHAR (10)    NULL,
    [CancellationCharge] INT             CONSTRAINT [DF_CancellationHistory_CancellationCharge] DEFAULT ((0)) NULL,
    [ServiceCharge]      INT             CONSTRAINT [DF_CancellationHistory_ServiceCharge] DEFAULT ((0)) NULL,
    [Discount]           INT             NULL,
    [paxfname]           VARCHAR (50)    NULL,
    [paxtype]            VARCHAR (10)    NULL,
    [totalfare]          INT             NULL,
    [sector]             VARCHAR (50)    NULL,
    [returnflag]         BIT             CONSTRAINT [DF_CancellationHistory_returnflag] DEFAULT ((0)) NULL,
    [HistoryID]          VARCHAR (50)    NULL,
    [TotalRefund]        INT             NULL,
    CONSTRAINT [PK_CancellationHistory] PRIMARY KEY CLUSTERED ([PKId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [CancellationHistory_OrderId]
    ON [dbo].[CancellationHistory]([OrderId] ASC);

