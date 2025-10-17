CREATE TABLE [dbo].[Agent_Promocode] (
    [ID]          INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PromoID]     INT          NULL,
    [AgentID]     INT          NULL,
    [InsertdDate] DATETIME     NULL,
    [InsertedBy]  VARCHAR (50) NULL,
    [Flag]        BIT          NULL,
    CONSTRAINT [PK_Agent_Promocode] PRIMARY KEY CLUSTERED ([ID] ASC)
);

