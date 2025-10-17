CREATE TABLE [dbo].[bkp_22072020_City_Popular_Route] (
    [Id]                  INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Source_City]         NVARCHAR (100) NULL,
    [Fastest_Flight_Time] NVARCHAR (50)  NULL,
    [Route_Price]         FLOAT (53)     NULL,
    [Route_Image]         NVARCHAR (200) NULL,
    [City_Id]             INT            NULL,
    [Time_Required]       NVARCHAR (50)  NULL,
    [CurrentTimeStamp]    DATETIME       NULL,
    [U_id]                INT            NULL
);

