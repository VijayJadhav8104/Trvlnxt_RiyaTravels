CREATE TABLE [dbo].[tblContractCommission] (
    [pkid]         BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserID]       INT            NULL,
    [Country]      VARCHAR (10)   NULL,
    [AgentID]      VARCHAR (MAX)  NULL,
    [FileName]     NVARCHAR (MAX) NULL,
    [InsertedDate] DATETIME       CONSTRAINT [DF_tblContractCommission_InsertedDate] DEFAULT (getdate()) NULL,
    [Status]       BIT            CONSTRAINT [DF_tblContractCommission_Status] DEFAULT ((1)) NULL,
    [UserType]     VARCHAR (50)   NULL,
    CONSTRAINT [PK_tblContractCommission] PRIMARY KEY CLUSTERED ([pkid] ASC)
);

