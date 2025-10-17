CREATE TABLE [dbo].[tblCrypticCommandAgentWise] (
    [CmdID]       INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Command]     VARCHAR (50) NULL,
    [OfficeId]    VARCHAR (20) NULL,
    [AgentID]     INT          NULL,
    [CompanyName] VARCHAR (10) NULL,
    [IsActive]    BIT          NULL,
    CONSTRAINT [PK_tblCrypticCommandAgentWise] PRIMARY KEY CLUSTERED ([CmdID] ASC)
);

