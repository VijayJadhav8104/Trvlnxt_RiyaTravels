CREATE TABLE [dbo].[Agent_Markup] (
    [ID]          INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MarkupID]    INT          NULL,
    [AgentID]     INT          NULL,
    [InsertdDate] DATETIME     NULL,
    [InsertedBy]  VARCHAR (50) NULL,
    [Flag]        BIT          NULL,
    CONSTRAINT [PK_Agent_Markup] PRIMARY KEY CLUSTERED ([ID] ASC)
);

