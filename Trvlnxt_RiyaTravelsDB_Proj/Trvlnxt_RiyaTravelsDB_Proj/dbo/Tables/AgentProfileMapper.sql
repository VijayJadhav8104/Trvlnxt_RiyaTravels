CREATE TABLE [dbo].[AgentProfileMapper] (
    [Id]         INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentId]    INT      NULL,
    [ProfileId]  INT      NULL,
    [CreateDate] DATETIME CONSTRAINT [DF_AgentProfileMapper_CreateDate] DEFAULT (getdate()) NULL,
    [CreatedBy]  INT      NULL,
    [ModifiedBy] INT      NULL,
    [ModifiedOn] DATETIME NULL,
    [IsActive]   BIT      CONSTRAINT [DF_AgentProfileMapper_IsActive] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_AgentProfileMapper] PRIMARY KEY CLUSTERED ([Id] ASC)
);

