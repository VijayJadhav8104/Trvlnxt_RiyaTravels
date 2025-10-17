CREATE TABLE [dbo].[Agent_Deal] (
    [ID]          INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DealID]      INT          NULL,
    [AgentID]     INT          NULL,
    [InsertdDate] DATETIME     NULL,
    [InsertedBy]  VARCHAR (50) NULL,
    [Flag]        BIT          NULL,
    CONSTRAINT [PK_Agent_Deal] PRIMARY KEY CLUSTERED ([ID] ASC)
);

