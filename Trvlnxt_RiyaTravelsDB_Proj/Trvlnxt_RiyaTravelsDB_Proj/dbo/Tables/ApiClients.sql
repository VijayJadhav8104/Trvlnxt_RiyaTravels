CREATE TABLE [dbo].[ApiClients] (
    [Id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]        VARCHAR (200) NULL,
    [CreatedDate] DATETIME      CONSTRAINT [DF_ApiClients_CreatedDate] DEFAULT (getdate()) NULL,
    [Status]      BIT           CONSTRAINT [DF_ApiClients_Status] DEFAULT ((1)) NULL,
    [Mobile]      VARCHAR (200) NULL,
    [CreatedBy]   INT           NULL,
    [AgentId]     INT           NOT NULL,
    [FKUserID]    INT           NOT NULL,
    [IsDeleted]   BIT           NULL,
    [Product]     INT           NOT NULL,
    [UserName]    VARCHAR (50)  NOT NULL,
    [Password]    VARCHAR (100) NOT NULL,
    [SecretKey]   VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_ApiClients] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ApiClients_B2BRegistration] FOREIGN KEY ([AgentId]) REFERENCES [dbo].[B2BRegistration] ([PKID]),
    UNIQUE NONCLUSTERED ([SecretKey] ASC),
    CONSTRAINT [UQ__ApiClien__A86B7C2E6B0C932D] UNIQUE NONCLUSTERED ([SecretKey] ASC)
);

