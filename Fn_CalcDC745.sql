USE [FnDB]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_CalcDC745]    Script Date: 18/02/2020 17:57:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[Fn_CalcDC745] ( @tCode VARCHAR(20) )
RETURNS CHAR(1)
AS
/* ===============================================================================
   Author        : Waldemar Guerrero
   Convertido em : 16/12/2019
   Description   : Calcula o DC de conta corrente banco 745 CITIBANK
                
   Formato       : CCCCCCC
				   
				   ATENÇÂO:

				   Aplicar somente para a conta corrente com até 7 digitos.
				   Não adicionar numero da agência.

                   PRINT dbo.Fn_CalcDC745('5580100') + ' = ' + '5'  -- Conta Real
                   PRINT dbo.Fn_CalcDC745('5234806') + ' = ' + '7'     -- Conta Real
                   PRINT dbo.Fn_CalcDC745('5234815') + ' = ' + '6'     -- Conta Real

   =============================================================================== */

BEGIN

	-- Declare the return variable here
	DECLARE @tNrDC    CHAR(01);

    DECLARE @nSoma  SMALLINT = 0;
    DECLARE @nMlt   SMALLINT = 2;
    DECLARE @nI     SMALLINT = 0;
    --DECLARE @nLen   SMALLINT = 0;
    DECLARE @nDCalc SMALLINT = 0;

    SET @nI = LEN(@tCode);

    -- 7500465    00007500465

    -- for (nI = nLen; nI >= 0; nI--) {

	WHILE @nI >= 0
	BEGIN
        
        SET @nSoma += CAST(SUBSTRING(@tCode, @nI, 1) AS SMALLINT) * @nMlt;
        SET @nMlt += 1;
        
        --if (nMlt > 7) {
        --//    nMlt = 2;
        --//}
    
	    SET @nI -= 1;
	END

    -- Se o Resto for maior que 1, subtraímos o valor de 11 (11 - Resto)
    -- Senão o DV será 0 (Se Resto = 0 ou 1)

    SET @nDCalc = 11 - (@nSoma % 11);
    IF @nDCalc > 9 
	BEGIN
        SET @nDCalc = 0;
    END

	SET @tNrDC = CAST(@nDCalc AS CHAR(1));

    RETURN @tNrDC;
    
END
