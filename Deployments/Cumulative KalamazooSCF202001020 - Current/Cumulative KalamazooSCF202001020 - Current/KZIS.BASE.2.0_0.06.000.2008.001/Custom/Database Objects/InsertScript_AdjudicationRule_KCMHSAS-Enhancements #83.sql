--10-08-2020 Kavya What: insert script for globalcode and adjudicationRule "Secondary claim does not require authorization"
--WHy: KCMHSAS Enhancement#83

if not exists ( select  *
                from    GlobalCodes gc
                where   gc.Category = 'DENIALREASON'
                        and Code = 'AUTHREQUIREDOVERRIDE'
                        and isnull(gc.RecordDeleted, 'N') = 'N' )
  begin
    insert  into GlobalCodes
            (Category,
             CodeName,
             Code,
             Active,
             CannotModifyNameOrDelete)
    select  'DENIALREASON',
            'Secondary claim does not require authorization',
            'AUTHREQUIREDOVERRIDE',
            'Y',
            'N'
  end

declare @GlobalCodeId int

select top 1
        @GlobalCodeId = gc.GlobalCodeId
from    GlobalCodes gc
where   gc.Category = 'DENIALREASON'
        and Code = 'AUTHREQUIREDOVERRIDE'
        and isnull(gc.RecordDeleted, 'N') = 'N'

if not exists ( select  *
                from    dbo.AdjudicationRules
                where   RuleTypeId = @GlobalCodeId
                        and isnull(RecordDeleted, 'N') = 'N' )
  begin
    insert  into AdjudicationRules
            (RuleTypeId,
             RuleName,
             SystemRequiredRule,
             Active,
             ClaimLineStatusIfBroken,
             MarkClaimLineToBeWorked,
             ToBeWorkedDays,
             AllInsurers)
    select  gc.GlobalCodeId,
            gc.CodeName,
            'N',
            'Y',
            'P',
            'N',
            30,
            'Y'
    from    GlobalCodes gc
    where   gc.GlobalCodeId = @GlobalCodeId
  end
