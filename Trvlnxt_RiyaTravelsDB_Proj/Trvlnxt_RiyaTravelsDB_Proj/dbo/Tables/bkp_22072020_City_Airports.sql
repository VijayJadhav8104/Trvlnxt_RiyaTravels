CREATE TABLE [dbo].[bkp_22072020_City_Airports] (
    [Id]               INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirportName]      NVARCHAR (100) NULL,
    [Description]      NVARCHAR (MAX) NULL,
    [Route_Image]      NVARCHAR (MAX) NULL,
    [City_Id]          INT            NULL,
    [CurrentTimeStamp] DATETIME       NULL,
    [U_id]             INT            NULL
);

