USE [FnDB]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_CalcDC104]    Script Date: 18/02/2020 17:57:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[Fn_CalcDC104](@tCode VARCHAR(20) )
/* ==========================================================================================
   Author      : Waldemar Guerrero
   Create date : 
   Description : Calculo do digito de controle para agencia e contas corrente 
                 do banco 104 CEF Caixa 041 Banrisul

	Formato
	             AAAAPPPCCCCCCCC
				 
				 AAAA     - Quatro digitos para numero da agência
				 PPP      - Código da operação. 3 dígitos.
				            Pode assumir o valores 000|001|003|013|023
				 CCCCCCCC - Numero da conta corrente em 8 posições, sem digito de controle
             
             
			 PRINT dbo.Fn_CalcDC104('012301300123456') + ' = ' + '1'
			 PRINT dbo.Fn_CalcDC104('123400000654321') + ' = ' + '4'
             
			 PRINT dbo.Fn_CalcDC104('432100100987654') + ' = ' + '0'
			 PRINT dbo.Fn_CalcDC104('214302300654987') + ' = ' + '2'
             
			 -- 2004 001 00000448    - 0
			 PRINT dbo.Fn_CalcDC104('200400100000448') + ' = ' + '6'
             
   ========================================================================================== */

   RETURNS CHAR(01)

AS
BEGIN

	-- Declare the return variable here
	DECLARE @tDC CHAR(01);

    DECLARE @nMlt   SMALLINT = 2;
    DECLARE @nSoma  SMALLINT = 0;
    DECLARE @nI     SMALLINT = 0;
    DECLARE @nDCalc SMALLINT = 0;

    SET @nI = LEN(@tCode);
	
	WHILE @nI > 0 
	BEGIN
	    
        SET @nSoma += CAST(SUBSTRING(@tCode, @nI, 1) AS SMALLINT) * @nMlt;

        SET @nMlt += 1;
        IF @nMlt > 9
		BEGIN
           SET @nMlt = 2;
        END
        SET @nI -= 1;
	END

    SET @nSoma = @nSoma * 10;
    SET @nDCalc = @nSoma % 11;

    IF @nDCalc = 10
	BEGIN
        SET @nDCalc = 0;
    END

    SET @tDC = CAST(@nDCalc AS CHAR(1));

	RETURN @tDC;
    
END
