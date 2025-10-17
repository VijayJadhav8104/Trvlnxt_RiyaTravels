CREATE TABLE [dbo].[mFlightSegments_Temp] (
    [Sno]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Origin]          VARCHAR (250) NOT NULL,
    [Destination]     VARCHAR (250) NOT NULL,
    [OriginCode]      VARCHAR (3)   NOT NULL,
    [DestinationCode] VARCHAR (3)   NOT NULL,
    [AirlineCode]     VARCHAR (3)   NOT NULL,
    CONSTRAINT [PK_mFlightSegments_Temp] PRIMARY KEY CLUSTERED ([Sno] ASC)
);

