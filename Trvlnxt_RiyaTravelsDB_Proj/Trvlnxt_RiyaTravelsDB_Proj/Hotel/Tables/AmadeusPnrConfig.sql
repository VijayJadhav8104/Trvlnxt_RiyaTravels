CREATE TABLE [Hotel].[AmadeusPnrConfig] (
    [Pkid]        INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentId]     VARCHAR (500) NOT NULL,
    [QueueNo]     INT           NOT NULL,
    [OfficeId]    VARCHAR (100) NOT NULL,
    [IsActive]    BIT           CONSTRAINT [DF_AmadeusPnrConfig_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedDate] DATETIME      CONSTRAINT [DF_AmadeusPnrConfig_CreatedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_AmadeusPnrConfig] PRIMARY KEY CLUSTERED ([Pkid] ASC)
);

