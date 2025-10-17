CREATE TABLE [dbo].[SearchTime] (
    [id]               INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BackendUserID]    VARCHAR (50)  NULL,
    [AgencyID]         VARCHAR (50)  NULL,
    [RequestDateTime]  VARCHAR (255) NULL,
    [ResponseDateTime] VARCHAR (255) NULL,
    [fromSector]       VARCHAR (255) NULL,
    [ToSector]         VARCHAR (255) NULL,
    [DepartureDate]    VARCHAR (255) NULL,
    [ReturnDate]       VARCHAR (255) NULL,
    [InsertedDate]     DATETIME      CONSTRAINT [DF_SearchTime_InsertedDate] DEFAULT (getdate()) NULL,
    [Product]          VARCHAR (255) NULL,
    CONSTRAINT [PK_SearchTime] PRIMARY KEY CLUSTERED ([id] ASC)
);

