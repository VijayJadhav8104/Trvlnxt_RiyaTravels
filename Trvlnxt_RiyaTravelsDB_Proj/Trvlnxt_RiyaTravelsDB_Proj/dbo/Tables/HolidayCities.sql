CREATE TABLE [dbo].[HolidayCities] (
    [HolidayCitiesIDP] BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [City]             VARCHAR (50) NULL,
    [State]            VARCHAR (50) NULL,
    [Country]          VARCHAR (50) NULL,
    CONSTRAINT [PK_HolidayCities] PRIMARY KEY CLUSTERED ([HolidayCitiesIDP] ASC)
);

