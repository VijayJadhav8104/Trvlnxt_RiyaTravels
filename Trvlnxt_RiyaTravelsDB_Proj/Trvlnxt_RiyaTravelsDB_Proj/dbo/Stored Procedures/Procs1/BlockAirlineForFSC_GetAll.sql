﻿CREATE PROCEDURE BlockAirlineForFSC_GetAll
	
AS
BEGIN
	SET NOCOUNT ON;

    SELECT AirlineCode FROM tblBlockAirlineForFSC
END