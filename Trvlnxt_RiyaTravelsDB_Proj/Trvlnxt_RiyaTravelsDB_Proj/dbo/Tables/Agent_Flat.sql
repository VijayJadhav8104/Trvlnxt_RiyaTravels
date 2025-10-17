CREATE TABLE [dbo].[Agent_Flat] (
    [ID]          INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FlatD]       INT          NULL,
    [AgentID]     INT          NULL,
    [InsertdDate] DATETIME     NULL,
    [InsertedBy]  VARCHAR (50) NULL,
    [Flag]        BIT          NULL,
    CONSTRAINT [PK_Agent_Flat] PRIMARY KEY CLUSTERED ([ID] ASC)
);

