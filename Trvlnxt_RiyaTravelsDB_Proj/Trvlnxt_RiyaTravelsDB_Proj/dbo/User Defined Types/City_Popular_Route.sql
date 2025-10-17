CREATE TYPE [dbo].[City_Popular_Route] AS TABLE (
    [Source_City]         NVARCHAR (100) NULL,
    [Fastest_Flight_Time] NVARCHAR (50)  NULL,
    [Route_Price]         FLOAT (53)     NULL,
    [Route_Img]           NVARCHAR (200) NULL,
    [City_Id]             INT            NULL,
    [Time_Required]       NVARCHAR (50)  NULL);

