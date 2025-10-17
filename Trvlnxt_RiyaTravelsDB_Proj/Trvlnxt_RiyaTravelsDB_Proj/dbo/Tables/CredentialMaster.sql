CREATE TABLE [dbo].[CredentialMaster] (
    [PK_Id]            INT             IDENTITY (1, 1) NOT NULL,
    [Provider]         VARCHAR (100)   NOT NULL,
    [CredType]         VARCHAR (50)    NOT NULL,
    [host]             VARCHAR (500)   NULL,
    [PortNumber]       INT             NULL,
    [Username]         VARCHAR (100)   NOT NULL,
    [Password]         VARBINARY (MAX) NOT NULL,
    [UserGroup]        VARCHAR (100)   NULL,
    [ApplicationGroup] VARCHAR (100)   NULL,
    [IsActive]         BIT             DEFAULT ((1)) NOT NULL,
    [CreatedDate]      DATETIME        DEFAULT (getdate()) NOT NULL,
    [ActiveFrom]       DATETIME        NOT NULL,
    [ActiveTo]         DATETIME        NULL,
    PRIMARY KEY CLUSTERED ([PK_Id] ASC)
);

