CREATE TABLE [Rail].[Tokens] (
    [Id]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [access_token] VARCHAR (500) NULL,
    [token_type]   VARCHAR (100) NULL,
    [expires_in]   VARCHAR (100) NULL,
    [created_on]   VARCHAR (100) NULL,
    [RiyaUserId]   BIGINT        NULL,
    [AgentId]      BIGINT        NULL,
    [CreatedDate]  DATETIME      NULL,
    [ModifiedDate] DATETIME      NULL,
    CONSTRAINT [PK_Tokens] PRIMARY KEY CLUSTERED ([Id] ASC)
);

