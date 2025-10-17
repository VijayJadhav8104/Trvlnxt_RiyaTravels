CREATE TABLE [dbo].[tblContactUs] (
    [ID]                BIGINT        IDENTITY (1, 1) NOT NULL,
    [Name]              VARCHAR (100) NULL,
    [MobileNo]          VARCHAR (50)  NULL,
    [email]             VARCHAR (50)  NULL,
    [city]              VARCHAR (50)  NULL,
    [services]          VARCHAR (50)  NULL,
    [additionalDetails] VARCHAR (500) NULL,
    [createDate]        DATETIME      NULL,
    [PageName]          VARCHAR (200) NULL,
    [PaxCount]          VARCHAR (50)  NULL,
    [TravelDate]        VARCHAR (50)  NULL,
    CONSTRAINT [PK_dbo.tblContactUs] PRIMARY KEY CLUSTERED ([ID] ASC)
);

