CREATE TABLE [dbo].[TblSTSAirLineMaster] (
    [PKID]         INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirlineName]  VARCHAR (50) NULL,
    [AirlineCode]  VARCHAR (50) NULL,
    [InsertedDate] DATETIME     CONSTRAINT [DF_TblSTSAirLineMaster_InsertedDate] DEFAULT (getdate()) NULL,
    [Status]       INT          CONSTRAINT [DF_TblSTSAirLineMaster_Status] DEFAULT ((1)) NULL,
    [AirlineCode1] VARCHAR (50) NULL,
    [CompanyName]  VARCHAR (10) NULL,
    CONSTRAINT [PK_TblSTSAirLineMaster] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

