CREATE TABLE [dbo].[Paymentissuance] (
    [PKID]          BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Tracking_Id]   VARCHAR (30)    NULL,
    [Amount]        DECIMAL (12, 2) NULL,
    [OrderId]       VARCHAR (30)    NULL,
    [inserteddt_dt] DATETIME        CONSTRAINT [DF_Paymentissuance_inserteddt_dt] DEFAULT (getdate()) NOT NULL,
    [Status]        VARCHAR (30)    NULL,
    [Remarks]       VARCHAR (50)    NULL,
    [Type]          VARCHAR (20)    NULL,
    CONSTRAINT [PK_Paymentissuance] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

