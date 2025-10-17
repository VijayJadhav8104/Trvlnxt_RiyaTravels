CREATE TABLE [dbo].[HotelApiClientsCompany] (
    [Id]              INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ClientId]        INT            NULL,
    [CompanyName]     VARCHAR (200)  NULL,
    [CompanyUsername] VARCHAR (200)  NULL,
    [CompanyPassword] NVARCHAR (200) NULL,
    [CreatedBy]       INT            NULL,
    [CreatedDate]     DATETIME       CONSTRAINT [DF_HotelApiClientsCompany_CreatedDate] DEFAULT (getdate()) NULL,
    [Status]          BIT            CONSTRAINT [DF_HotelApiClientsCompany_Status] DEFAULT ((1)) NULL,
    [ClientNumber]    NVARCHAR (200) NULL,
    CONSTRAINT [PK_HotelApiClientsCompany] PRIMARY KEY CLUSTERED ([Id] ASC)
);

