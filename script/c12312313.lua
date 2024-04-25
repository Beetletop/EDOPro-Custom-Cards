local s,id=GetID()
function s.initial_effect(c)
	--Search "Cynet Mining"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
s.listed_names={57160136}
function s.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(57160136)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
    		Duel.ConfirmCards(1-tp,g)
            --cannot link summon
        	local e1=Effect.CreateEffect(e:GetHandler())
        	e1:SetType(EFFECT_TYPE_FIELD)
        	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
        	e1:SetDescription(aux.Stringid(id,1))
        	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        	e1:SetTargetRange(1,0)
        	e1:SetReset(RESET_PHASE+PHASE_END)
        	e1:SetTarget(s.splimit)
        	Duel.RegisterEffect(e1,tp)
        end
	end
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return c:IsLinkMonster() and c:GetLink()>=3 and (sumtp&SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end