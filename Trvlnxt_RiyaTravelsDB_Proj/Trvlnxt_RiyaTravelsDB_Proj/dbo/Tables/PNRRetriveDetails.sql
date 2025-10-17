CREATE TABLE [dbo].[PNRRetriveDetails] (
    [Id]               INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [GDSPNR]           VARCHAR (10)    NULL,
    [AgentName]        NVARCHAR (MAX)  NULL,
    [OfficeId]         NVARCHAR (50)   NULL,
    [LoginId]          VARCHAR (50)    NULL,
    [TicketIssue]      BIT             NULL,
    [RiyaPNR]          VARCHAR (12)    NULL,
    [OrderID]          NVARCHAR (100)  NULL,
    [InsertedDate]     DATETIME        NULL,
    [EmpCode]          NVARCHAR (50)   NULL,
    [CostCenterSwonNo] NVARCHAR (50)   NULL,
    [TRPONoREQNO]      NVARCHAR (50)   NULL,
    [CorpEmpCode]      VARCHAR (50)    NULL,
    [Endorsementline]  VARCHAR (100)   NULL,
    [GSTAMount]        DECIMAL (18, 2) NULL,
    [ServiceFee]       DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_PNRRetriveDetails] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [PNRRetriveDetails_OrderID]
    ON [dbo].[PNRRetriveDetails]([OrderID] ASC);

