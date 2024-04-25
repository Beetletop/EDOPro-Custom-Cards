local s,id=GetID()
function s.initial_effect(c)
	--Special summon itself
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(s.sumsuc)
	c:RegisterEffect(e3)
	--summon success
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Grant a double attacking effect to a "Number" Xyz Monster that is summoned using this card as material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(s.mtcon)
	e5:SetOperation(s.mtop)
	c:RegisterEffect(e5)
end
s.listed_series={0x6f}
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_XYZ and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetReasonCard():IsRace(RACE_WARRIOR)
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--Take no effect damage, if the amount is less than this card's ATK
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.damval)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(rc)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT|RESETS_STANDARD)
	e2:SetValue(s.efilter)
	rc:RegisterEffect(e2,true)
	--cannot be target
	local e4=Effect.CreateEffect(rc)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetReset(RESET_EVENT|RESETS_STANDARD)
	e4:SetValue(aux.tgoval)
	rc:RegisterEffect(e4,true)
	local e5=Effect.CreateEffect(rc)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	e5:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	rc:RegisterEffect(e5,true)
	local e6=Effect.CreateEffect(rc)
	e6:SetDescription(aux.Stringid(id,4))
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,1)
	e6:SetValue(1)
	e6:SetCondition(s.actcon)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e6,true)
	--pierce
	local e7=Effect.CreateEffect(rc)
	e6:SetDescription(aux.Stringid(id,5))
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_PIERCE)
	e7:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e7,true)
	--atkup
	local e8=Effect.CreateEffect(rc)
	e6:SetDescription(aux.Stringid(id,6))
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_SET_ATTACK_FINAL)
	e8:SetValue(s.atkval)
	rc:RegisterEffect(e8)
	if not rc:IsType(TYPE_EFFECT) then
		--Becomes an Effect Monster if it wasn't one already
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT|RESETS_STANDARD)
		rc:RegisterEffect(e3,true)
	end
end
function s.atkval(e,c)
	return c:GetAttack()*2
end
function s.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsPosition(POS_DEFENSE)
end
function s.efilter(e,te)
    local atk=e:GetHandler():GetAttack()
    return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER)
		and te:GetOwner():GetAttack()<atk and te:GetOwner():GetAttack()>=0
end
function s.damval(e,re,val,r,rp,rc)
	local atk=e:GetHandler():GetAttack()
	if val<=atk then return 0 else return val end
end
function s.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsSummonPlayer(tp) and c:IsSetCard(0x6f)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   --Banish it if it leaves the field
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3300)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT|RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end