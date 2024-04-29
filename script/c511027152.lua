--クイズ・フロンティア
--Manga action field
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
end
s.af="a"
s.tableAction = {
	150000077,
	150000078,
	150000079,
	150000080,
	150000081,
	150000082,
	150000083,
	150000085,
	150000088,
	150000089,
	150000090,
	150000091,
	150000092,
	150000094,
	150000095,
	150000096,
	150000097,
	150000098,
	150000099,
	150000100,
	150000101,
	150000102,
	150000103,
	150000104,
	150000105,
	150000107,
	150000108,
	150000109,
	150000110,
	150000111,
}
