CREATE TABLE [dbo].[tblCrypticPassengerdata] (
    [CPPkid]       INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PAXFirstName] VARCHAR (50) NULL,
    [PAXLastName]  VARCHAR (50) NULL,
    [Title]        VARCHAR (10) NULL,
    [AirCode]      VARCHAR (10) NULL,
    [FlightNo]     VARCHAR (10) NULL,
    [CabinClass]   VARCHAR (50) NULL,
    [DeptureDate]  DATE         NULL,
    [FromSector]   VARCHAR (10) NULL,
    [ToSector]     VARCHAR (10) NULL,
    [GDSPNR]       VARCHAR (10) NULL,
    [AgentId]      VARCHAR (10) NULL,
    [OfficeID]     VARCHAR (50) NULL,
    [PAXType]      VARCHAR (10) NULL,
    CONSTRAINT [PK_tblCrypticPassengerdata] PRIMARY KEY CLUSTERED ([CPPkid] ASC)
);

