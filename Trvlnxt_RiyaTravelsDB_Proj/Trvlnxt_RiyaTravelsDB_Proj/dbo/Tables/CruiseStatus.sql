﻿CREATE TABLE [dbo].[CruiseStatus] (
    [ID]     INT          IDENTITY (0, 1) NOT FOR REPLICATION NOT NULL,
    [Status] VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

