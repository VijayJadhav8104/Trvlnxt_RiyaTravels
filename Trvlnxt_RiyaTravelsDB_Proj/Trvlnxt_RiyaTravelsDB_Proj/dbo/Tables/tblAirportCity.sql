CREATE TABLE [dbo].[tblAirportCity] (
    [ID]         BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CODE]       VARCHAR (5)    NOT NULL,
    [NAME]       VARCHAR (300)  NULL,
    [SEARCHNAME] VARCHAR (50)   NOT NULL,
    [COUNTRY]    VARCHAR (5)    NULL,
    [UTC]        NVARCHAR (255) NULL,
    [IsCityCode] BIT            NULL,
    [newUTCTime] NVARCHAR (255) NULL,
    [State_code] VARCHAR (10)   NULL,
    [MainCode]   VARCHAR (10)   NULL,
    CONSTRAINT [PK_tblAirportCity] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_tblAirportCity_Code]
    ON [dbo].[tblAirportCity]([CODE] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblAirportCity_SearchName]
    ON [dbo].[tblAirportCity]([SEARCHNAME] ASC);

