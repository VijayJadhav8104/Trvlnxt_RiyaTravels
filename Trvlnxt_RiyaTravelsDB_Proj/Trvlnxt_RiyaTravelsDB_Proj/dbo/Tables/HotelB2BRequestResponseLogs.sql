CREATE TABLE [dbo].[HotelB2BRequestResponseLogs] (
    [Id]              INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [API_Name]        VARCHAR (50)   NULL,
    [Controller_Name] VARCHAR (50)   NULL,
    [Method_Name]     NCHAR (10)     NULL,
    [Supplier_Name]   VARCHAR (50)   NULL,
    [Api_RequestUrl]  NVARCHAR (MAX) NULL,
    [Api_Response]    NVARCHAR (MAX) NULL,
    [Search_Request]  NVARCHAR (MAX) NULL,
    [CreateDate]      DATETIME       CONSTRAINT [DF_HotelB2BRequestResponseLogs_CreateDate] DEFAULT (getdate()) NULL,
    [StatusID]        VARCHAR (50)   NULL,
    [LoginSessionID]  VARCHAR (100)  NULL,
    [UniqueSearchID]  VARCHAR (100)  NULL,
    [MainAgentID]     VARCHAR (100)  NULL,
    [BookingRef]      VARCHAR (50)   NULL,
    CONSTRAINT [PK_HotelB2BRequestResponseLogs] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [api_name_indx]
    ON [dbo].[HotelB2BRequestResponseLogs]([API_Name] ASC);


GO
CREATE NONCLUSTERED INDEX [CreateDate_indx]
    ON [dbo].[HotelB2BRequestResponseLogs]([CreateDate] ASC);

