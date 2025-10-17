CREATE TABLE [dbo].[tblERPAgentBalance] (
    [ID]              INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CustID]          VARCHAR (100)   NULL,
    [PreviousBalance] DECIMAL (18, 3) NULL,
    [NewBalance]      DECIMAL (18, 3) NULL,
    [InsertDate]      DATETIME        NULL,
    [UserID]          INT             NULL,
    CONSTRAINT [PK_tblERPAgentBalance] PRIMARY KEY CLUSTERED ([ID] ASC)
);

