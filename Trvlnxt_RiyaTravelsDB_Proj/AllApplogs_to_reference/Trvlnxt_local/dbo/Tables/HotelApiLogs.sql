CREATE TABLE [dbo].[HotelApiLogs] (
    [ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [URL]                 VARCHAR (200) NULL,
    [Request]             VARCHAR (MAX) NULL,
    [Response]            VARCHAR (MAX) NULL,
    [Header]              VARCHAR (MAX) NULL,
    [MethodName]          VARCHAR (200) NULL,
    [InsertedDate]        DATETIME      NULL,
    [Token]               VARCHAR (100) NULL,
    [CorrelationId]       VARCHAR (150) NULL,
    [AgentId]             VARCHAR (50)  NULL,
    [Timmer]              VARCHAR (200) NULL,
    [IP]                  VARCHAR (100) NULL,
    [ServerIp]            VARCHAR (200) NULL,
    [rateCodes]           VARCHAR (200) NULL,
    [officeId]            VARCHAR (200) NULL,
    [CustomerId]          VARCHAR (200) NULL,
    [HGToken]             VARCHAR (200) NULL,
    [HGRateCodes]         VARCHAR (200) NULL,
    [BookingPortal]       VARCHAR (50)  NULL,
    [cityName]            VARCHAR (100) NULL,
    [HotelID]             VARCHAR (100) NULL,
    [ProviderHotelID]     VARCHAR (200) NULL,
    [ProviderID]          VARCHAR (200) NULL,
    [ClientCorrelationId] VARCHAR (150) NULL,
    [SearchType]          VARCHAR (200) NULL,
    [ResumeKey]           VARCHAR (200) NULL,
    CONSTRAINT [PK_HotelApiLogs] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_agentid_ip_InsertedDate_methodname]
    ON [dbo].[HotelApiLogs]([AgentId] ASC, [IP] ASC, [InsertedDate] ASC, [MethodName] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_CorrelationId]
    ON [dbo].[HotelApiLogs]([CorrelationId] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_MethodName]
    ON [dbo].[HotelApiLogs]([MethodName] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_Token]
    ON [dbo].[HotelApiLogs]([Token] ASC);


GO
CREATE NONCLUSTERED INDEX [Noncluster_Index_inserteddate]
    ON [dbo].[HotelApiLogs]([InsertedDate] ASC)
    INCLUDE([CorrelationId], [ID]);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Composite Index]
    ON [dbo].[HotelApiLogs]([MethodName] ASC, [Token] ASC, [HotelID] ASC)
    INCLUDE([ID], [ProviderHotelID], [ProviderID]);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-CorrelationID_InsertedDate]
    ON [dbo].[HotelApiLogs]([CorrelationId] ASC, [InsertedDate] ASC)
    INCLUDE([ID]) WITH (FILLFACTOR = 95);

