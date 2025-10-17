CREATE TABLE [dbo].[ApiClientsCompany] (
    [Id]              INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientId]        INT            NULL,
    [CompanyName]     VARCHAR (200)  NULL,
    [CompanyUsername] VARCHAR (200)  NULL,
    [CompanyPassword] NVARCHAR (200) NULL,
    [CreatedBy]       INT            NULL,
    [CreatedDate]     DATETIME       CONSTRAINT [DF_ApiClientsCompany_CreatedDate] DEFAULT (getdate()) NULL,
    [Status]          BIT            CONSTRAINT [DF_ApiClientsCompany_Status] DEFAULT ((1)) NULL,
    [ClientNumber]    NVARCHAR (200) NULL,
    CONSTRAINT [PK_ApiClientsCompany] PRIMARY KEY CLUSTERED ([Id] ASC)
);

