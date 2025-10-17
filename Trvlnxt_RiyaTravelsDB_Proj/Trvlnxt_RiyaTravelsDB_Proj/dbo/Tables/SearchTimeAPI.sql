CREATE TABLE [dbo].[SearchTimeAPI] (
    [Id]               INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VendorName]       NVARCHAR (100) NULL,
    [SearchId]         INT            NULL,
    [RequestDateTime]  VARCHAR (255)  NULL,
    [ResponseDateTime] VARCHAR (255)  NULL,
    [ResponseType]     VARCHAR (50)   NULL,
    [APIRequestTime]   VARCHAR (255)  NULL,
    [APIResponseTime]  VARCHAR (255)  NULL,
    [InsertedDate]     DATETIME       CONSTRAINT [DF_SearchTimeAPI_InsertedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_SearchTimeAPI] PRIMARY KEY CLUSTERED ([Id] ASC)
);

