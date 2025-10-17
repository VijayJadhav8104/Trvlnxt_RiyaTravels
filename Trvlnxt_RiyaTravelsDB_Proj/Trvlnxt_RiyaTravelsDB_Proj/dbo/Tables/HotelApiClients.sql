CREATE TABLE [dbo].[HotelApiClients] (
    [Id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]        VARCHAR (200) NULL,
    [CreatedDate] DATETIME      CONSTRAINT [DF_HotelApiClients_CreatedDate] DEFAULT (getdate()) NULL,
    [Status]      BIT           CONSTRAINT [DF_HotelApiClients_Status] DEFAULT ((1)) NULL,
    [Mobile]      VARCHAR (200) NULL,
    [CreatedBy]   INT           NULL,
    [AgentId]     INT           NULL,
    [IsDeleted]   BIT           NULL,
    [Product]     VARCHAR (50)  NULL,
    [FKUserID]    INT           NULL,
    CONSTRAINT [PK_HotelApiClients] PRIMARY KEY CLUSTERED ([Id] ASC)
);

