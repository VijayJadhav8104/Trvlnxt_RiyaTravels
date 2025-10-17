CREATE TABLE [dbo].[UpdatePNRHistory] (
    [intPKID]         INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [vcrIP]           VARCHAR (100) NULL,
    [intUserID]       INT           NULL,
    [vcrOrderID]      VARCHAR (100) NULL,
    [vcrRiyaPNR]      VARCHAR (50)  NULL,
    [vcrGDSPNR]       VARCHAR (50)  NULL,
    [vcrActionRemark] VARCHAR (MAX) NULL,
    [dtInsertedDate]  DATETIME      NULL,
    [vcrDevice]       VARCHAR (50)  NULL,
    CONSTRAINT [PK_UpdatePNRHistory] PRIMARY KEY CLUSTERED ([intPKID] ASC)
);

