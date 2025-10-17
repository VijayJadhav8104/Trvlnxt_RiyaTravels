CREATE TABLE [dbo].[FareRuleoldd] (
    [pid]              INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ReSchedulingFee]  INT            NULL,
    [OtherConditions]  NVARCHAR (MAX) NULL,
    [ProductClass]     VARCHAR (50)   NULL,
    [Carrier]          VARCHAR (10)   NULL,
    [Sector]           VARCHAR (10)   NULL,
    [InsertedDate]     DATETIME       CONSTRAINT [DF_FareRule_InsertedDate] DEFAULT (getdate()) NULL,
    [OtherConditionsM] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_FareRule] PRIMARY KEY CLUSTERED ([pid] ASC)
);

