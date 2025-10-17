CREATE TABLE [dbo].[AgentLoginAllHistory] (
    [ID]         BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AL_PKID]    BIGINT        NULL,
    [ModifiedOn] DATETIME      CONSTRAINT [DF_AgentLoginAllHistory_ModifiedOn] DEFAULT (getdate()) NULL,
    [ModifiedBy] BIGINT        NULL,
    [Action]     INT           NULL,
    [PageName]   VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1-Add, 2-Update, 3-Delete', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AgentLoginAllHistory', @level2type = N'COLUMN', @level2name = N'Action';

