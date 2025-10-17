CREATE TABLE [dbo].[PGAgentMappingHotel] (
    [Id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PGID]        INT           NULL,
    [AgentId]     NVARCHAR (50) NULL,
    [IsActive]    BIT           NULL,
    [CreatedDate] DATE          NULL,
    CONSTRAINT [PK_PGAgentMappingHotel] PRIMARY KEY CLUSTERED ([Id] ASC)
);

