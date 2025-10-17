CREATE TABLE [dbo].[mAgentAttributeMappingOU] (
    [ID]         INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentId]    BIGINT         NOT NULL,
    [OUName]     VARCHAR (100)  NULL,
    [Address]    NVARCHAR (MAX) NULL,
    [IsActive]   BIT            CONSTRAINT [DF_mAgentAttributeMappingOU_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedOn]  DATETIME2 (7)  CONSTRAINT [DF_mAgentAttributeMappingOU_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]  INT            NOT NULL,
    [ModifiedOn] DATETIME2 (7)  NULL,
    [ModifiedBy] INT            NULL,
    CONSTRAINT [PK_mAgentAttributeMappingOU] PRIMARY KEY CLUSTERED ([ID] ASC)
);

