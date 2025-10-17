CREATE TABLE [dbo].[mAgentAttributeMapping] (
    [ID]            INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgenId]        INT NOT NULL,
    [AttributeId]   INT NOT NULL,
    [IsMandate]     BIT CONSTRAINT [DF_mAgentAttributeMapping_IsMandate] DEFAULT ((0)) NOT NULL,
    [AttributeType] INT CONSTRAINT [DF_mAgentAttributeMapping_AtrributeType] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_mAgentAttributeMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);

