USE [FnDB]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_CalcDC237]    Script Date: 18/02/2020 17:57:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[Fn_CalcDC237](@tCode VARCHAR(20) )
/* ==========================================================================================
   Author      : Waldemar Guerrero
   Create date : 
   Description : Calculo do digito de controle para agencia e contas corrente 
                 do banco 237 Bradesco

	Formato
	             AAAA-D

				 CCCCCC-D
				 
				 AAAA     - Quatro digitos para numero da agência
				 CCCCCCCC - Numero da conta corrente em 6 posições
                 D        - Digito de controle;
             
			 PRINT dbo.Fn_CalcDC237('2573') + ' = ' + '9'
			 PRINT dbo.Fn_CalcDC237('40189') + ' = ' + '7'

			 PRINT dbo.Fn_CalcDC237('1425') + ' = ' + '7'
			 PRINT dbo.Fn_CalcDC237('0238069') + ' = ' + '2'
             
			 PRINT dbo.Fn_CalcDC237('0301357') + ' = ' + '0 - P'

   ========================================================================================== */

   RETURNS CHAR(01)

AS
BEGIN
	-- Declare the return variable here
	DECLARE @tDC CHAR(01);

    DECLARE @nMlt SMALLINT  = 2;
    DECLARE @nSoma SMALLINT = 0;
    DECLARE @nI SMALLINT    = 0;
    DECLARE @nDCalc SMALLINT = 0;

	SET @nI = LEN(@tCode);

	WHILE @nI > 0
	BEGIN

        SET @nSoma += SUBSTRING(@tCode, @nI, 1) * @nMlt;

        SET @nMlt = @nMlt + 1;
        IF @nMlt > 7
		BEGIN
            SET @nMlt = 2;
        END
    
	    SET @nI -= 1;
	END

    SET @nDCalc = 11 - (@nSoma % 11);
    IF @nDCalc = 11
	BEGIN
        SET @tDC = '0';               -- 'tDCt = 'X'
    END
    ELSE IF @nDCalc = 10
	BEGIN
        SET @tDC = '0';               -- 'tDCt = 'P'
    END
	ELSE
	BEGIN
        SET @tDC = CAST(@nDCalc AS CHAR(01));
    END

	RETURN @tDC;
    
END
