# distutils: language=c++

from libc.math cimport ceil as c_ceil

from .base cimport *

cdef public class RlvData[object RlvData, type _RlvData]:
    cpdef public char cond(self, char cond_id):
        return self.f & (1 << cond_id) > 0

    def __init__(self, rlv, lv, star, s_craft, s_control, pb, qb, pd, qd, pm, qm, db, f):
        """

        :param rlv: recipe level
        :param s_craft: suggested craft
        :param s_control: suggested control
        :param pb: progress base
        :param qb: quality base
        :param pd: progress divider
        :param qd: quality divider
        :param pm: progress modifier
        :param qm: quality modifier
        :param db: durability base
        :param f: condition flag
        """
        self.rlv = rlv
        self.lv = lv
        self.star = star
        self.s_craft = s_craft
        self.s_control = s_control
        self.pb = pb
        self.qb = qb
        self.pd = pd
        self.qd = qd
        self.pm = pm
        self.qm = qm
        self.db = db
        self.f = f

cpdef public RlvData get_rlv_data(int rlv): return <RlvData> _rlv_data[rlv]

cdef public class Recipe[object Recipe, type _Recipe]:
    def __init__(self, int rlv, uchar pf, uchar qf, uchar df):
        """
        :param rlv: rlv data
        :param pf: progress factor
        :param qf: quality factor
        :param df: durability factor
        """
        self.rlv = get_rlv_data(rlv)
        self.p = self.rlv.pb * pf // 100
        self.q = self.rlv.qb * qf // 100
        self.d = self.rlv.db * df // 100

    def __str__(self):
        return f"Recipe: {self.rlv.rlv}({self.p}/{self.q}/{self.d})"

cdef public class Player[object Player, type _Player]:
    def __init__(self, craft, control, cp, lv, is_specialist=False):
        self.craft = craft
        self.control = control
        self.cp = cp
        self.lv = lv
        self.is_specialist = is_specialist

    @property
    def clv(self):
        """
        :return: the crafter level
        """
        return clv_list[self.lv]

    def __str__(self):
        if self.is_specialist:
            return f"Player: S{self.lv}({self.craft}/{self.control}/{self.cp})"
        return f"Player: {self.lv}({self.craft}/{self.control}/{self.cp})"

cdef public class Action[object Action, type _Action]:
    cpdef public int get_craft_progress(self, Craft craft):
        return self.p if self.get_progress is NULL else self.get_progress(craft)

    cpdef public int get_craft_quality(self, Craft craft):
        return self.q if self.get_quality is NULL else self.get_quality(craft)

    cpdef public int get_craft_cost(self, Craft craft):
        return self.c if self.get_cost is NULL else self.get_cost(craft)

    cpdef public  int get_craft_durability(self, Craft craft):
        return self.d if self.get_durability is NULL else self.get_durability(craft)

    cpdef public int get_craft_fail_rate(self, Craft craft):
        return self.f if self.get_fail_rate is NULL else self.get_fail_rate(craft)

    def __init__(
            self,
            id: int, name: str,
            kr: bool = False,
            f: int = 0, l: int = 0,
            p: int = 0, q: int = 0, c: int = 0, d: int = 0,
    ):
        """

        :param id: action id
        :param name: action name
        :param kr: keep round
        :param f: fail rate
        :param l: require level
        :param p: progress
        :param q: quality
        :param c: cost
        :param d: durability
        """
        self.id = id
        self.name = name
        self.kr = kr
        self.l = l
        self.f = f
        self.p = p
        self.q = q
        self.c = c
        self.d = d

        self.get_progress = NULL
        self.get_quality = NULL
        self.get_cost = NULL
        self.get_durability = NULL
        self.get_fail_rate = NULL
        self.after_use = NULL

    def __str__(self):
        return self.name

cdef public class Status[object Status, type _Status]:
    cpdef public int get_craft_progress_factor(self, Craft craft, Action action):
        return self.pf if self.get_progress_factor is NULL else self.get_progress_factor(craft, action)

    cpdef public int get_craft_quality_factor(self, Craft craft, Action action):
        return self.qf if self.get_quality_factor is NULL else self.get_quality_factor(craft, action)

    cpdef public int get_craft_cost_factor(self, Craft craft, Action action):
        return self.cf if self.get_cost_factor is NULL else self.get_cost_factor(craft, action)

    cpdef public int get_craft_durability_factor(self, Craft craft, Action action):
        return self.df if self.get_durability_factor is NULL else self.get_durability_factor(craft, action)

    def __init__(
            self,
            id: int, name: str, ks: bool = False,
            pf: int = 0, qf: int = 0, cf: int = 0, df: int = 0,
    ):
        """

        :param id: status id
        :param name: status name
        :param ks: keep stack
        :param pf: progress factor
        :param qf: quality factor
        :param cf: cost factor
        :param df: durability factor
        """
        self.id = id
        self.name = name
        self.ks = ks
        self.pf = pf
        self.qf = qf
        self.cf = cf
        self.df = df
        self.get_progress_factor = NULL
        self.get_quality_factor = NULL
        self.get_durability_factor = NULL
        self.get_cost_factor = NULL
        self.after_round = NULL

    def __str__(self):
        return self.name

cdef public class Condition[object Condition, type _Condition]:
    cpdef public int get_craft_progress_factor(self, Craft craft, Action action):
        return self.pf if self.get_progress_factor is NULL else self.get_progress_factor(craft, action)

    cpdef public int get_craft_quality_factor(self, Craft craft, Action action):
        return self.qf if self.get_quality_factor is NULL else self.get_quality_factor(craft, action)

    cpdef public  int get_craft_cost_factor(self, Craft craft, Action action):
        return self.cf if self.get_cost_factor is NULL else self.get_cost_factor(craft, action)

    cpdef public  int get_craft_durability_factor(self, Craft craft, Action action):
        return self.df if self.get_durability_factor is NULL else self.get_durability_factor(craft, action)

    def __init__(
            self,
            id: int, name: str,
            pf: int = 0, qf: int = 0, cf: int = 0, df: int = 0,
    ):
        """

        :param id: condition id
        :param name: condition name
        :param pf: progress factor
        :param qf: quality factor
        :param cf: cost factor
        :param df: durability factor
        """
        self.id = id
        self.name = name
        self.pf = pf
        self.qf = qf
        self.cf = cf
        self.df = df
        self.get_progress_factor = NULL
        self.get_quality_factor = NULL
        self.get_durability_factor = NULL
        self.get_cost_factor = NULL
        self.after_round = NULL

    def __str__(self):
        return self.name

cdef cpp_map[char, void_p] actions_manager = cpp_map[char, void_p]()
cdef cpp_map[char, void_p] status_manager = cpp_map[char, void_p]()
cdef cpp_map[char, void_p] condition_manager = cpp_map[char, void_p]()

cpdef public Action get_action(char id): return <Action> actions_manager[id]
cpdef public Status get_status(char id): return <Status> status_manager[id]
cpdef public Condition get_condition(char id): return <Condition> condition_manager[id]

cpdef public void add_action(Action action):
    """
    careful, keep ref in python side!!!
    """
    actions_manager[action.id] = <void *> action

cpdef public void add_status(Status status):
    """
    careful, keep ref in python side!!!
    """
    status_manager[status.id] = <void *> status

cpdef public void add_condition(Condition condition):
    """
    careful, keep ref in python side!!!
    """
    condition_manager[condition.id] = <void *> condition

cdef public class CraftData[object CraftData, type _CraftData]:
    def __init__(self, recipe: Recipe, player: Player):
        cdef char need_mod = player.clv <= recipe.rlv.rlv
        cdef float _base = player.craft * 10 / recipe.rlv.pd + 2
        self.bp = <ushort> (_base * recipe.rlv.pm / 100 if need_mod else _base)
        _base = player.control * 10 / recipe.rlv.qd + 35
        self.bq = <ushort> (_base * recipe.rlv.qm / 100 if need_mod else _base)
        # print(f"bp: {self.bp}, bq: {self.bq}")

cdef public class CraftStatic[object CraftStatic, type _CraftStatic]:
    def __init__(self, player: Player, recipe: Recipe, craft_data: CraftData = None):
        self.player = player
        self.recipe = recipe
        self.craft_data = craft_data if craft_data else CraftData(recipe, player)

    def get_craft(
            self,
            r: int = 1,
            d: int = None,
            cp: int = None,
            p: int = 0,
            q: int = 0,
            cid: int = 0,
            la: int = -1,
            status: dict[int, int] = None
    )-> Craft:
        _status = cpp_map[char, char]()
        if status is not None:
            for k, v in status.items():
                _status[k] = v
        if cp is None: cp = self.player.cp
        if d is None: d = self.recipe.d
        cdef Crafting crafting = Crafting(r=r, d=d, cp=cp, p=p, q=q, cid=cid, la=la, status=_status, used_action=cpp_map[char, char]())
        return Craft(self, crafting)

cdef public class Crafting[object Crafting, type _Crafting]:
    def __init__(self, r: int, d: int, cp: int, p: int, q: int, cid: int, la: int, status: cpp_map[char, char], used_action: cpp_map[char, char]):
        self.r = r
        self.d = d
        self.cp = cp
        self.p = p
        self.q = q
        self.cid = cid
        self.la = la
        self.status = status
        self.to_add_status = cpp_map[char, char]()
        self.used_action = used_action

    cpdef Crafting clone(self):
        return Crafting(self.r, self.d, self.cp, self.p, self.q, self.cid, self.la, self.status, self.used_action)

cdef public class Craft[object Craft, type _Craft]:
    def __init__(self, static: CraftStatic, Crafting craft):
        self.cs = static
        self.craft = craft

    cpdef public char is_finished(self):
        return self.craft.d <= 0 or self.is_success()

    cpdef public char is_success(self):
        return self.craft.p >= self.cs.recipe.p

    cpdef public char has_status(self, char sid):
        return self.craft.status.count(sid) > 0

    cpdef public char get_status_stack(self, char sid):
        return self.craft.status.count(sid) and self.craft.status[sid]

    cpdef public void set_status_stack(self, char sid, char stack):
        self.craft.status[sid] = stack

    cpdef public void crafting_add_status(self, char sid, char stack):
        self.craft.status.erase(sid)
        if self.craft.to_add_status.count(sid) == 0 or self.craft.to_add_status[sid] < stack:
            self.craft.to_add_status[sid] = stack

    cpdef public int crafting_add_progress(self, int p):
        self.craft.p += p
        if self.craft.p > self.cs.recipe.p:
            self.craft.p = self.cs.recipe.p
        elif self.craft.p < 0:
            self.craft.p = 0
        return p

    cpdef public int crafting_add_quality(self, int q):
        self.craft.q += q
        if self.craft.q > self.cs.recipe.q:
            self.craft.q = self.cs.recipe.q
        elif self.craft.q < 0:
            self.craft.q = 0
        return q

    cpdef public int crafting_use_cp(self, int cp):
        self.craft.cp -= cp
        if self.craft.cp > self.cs.player.cp:
            self.craft.cp = self.cs.player.cp
        elif self.craft.cp < 0:
            raise Exception("Crafting: cp < 0")
        return cp

    cpdef public int crafting_use_durability(self, int d):
        self.craft.d -= d
        if self.craft.d > self.cs.recipe.d:
            self.craft.d = self.cs.recipe.d
        elif self.craft.d < 0:
            self.craft.d = 0
        return d

    cpdef public int craft_get_action_progress(self, Action action):
        cdef short action_progress = action.get_craft_progress(self)
        if action_progress == 0: return 0
        cdef short status_factor = 0
        for p in self.craft.status: status_factor += get_status(p.first).get_craft_progress_factor(self, action)
        # print(f"base: {self.cs.craft_data.bp}, action: {action_progress}, status: {status_factor} cond: {get_condition(self.craft.cid).get_craft_progress_factor(self, action)}")
        return <int> (
                self.cs.craft_data.bp * action_progress *
                (1 + get_condition(self.craft.cid).get_craft_progress_factor(self, action) / 100) *
                (1 + status_factor / 100) / 100
        )

    cpdef public int craft_get_action_quality(self, Action action):
        cdef short action_quality = action.get_craft_quality(self)
        if action_quality == 0: return 0
        cdef short status_factor = 0
        for p in self.craft.status: status_factor += get_status(p.first).get_craft_quality_factor(self, action)
        # print(f"base: {self.cs.craft_data.bq}, action: {action_quality}, status: {status_factor} cond: {get_condition(self.craft.cid).get_craft_quality_factor(self, action)}")
        return <int> (
                self.cs.craft_data.bq * action_quality * (1 + self.get_status_stack(s_InnerQuiet) / 10) *
                (1 + get_condition(self.craft.cid).get_craft_quality_factor(self, action) / 100) *
                (1 + status_factor / 100) / 100
        )

    cpdef public short craft_get_action_durability(self, Action action):
        cdef float status_factor = 1
        cdef ushort action_durability = action.get_craft_durability(self)
        if action_durability == 0: return 0
        for p in self.craft.status: status_factor *= (100 + get_status(p.first).get_craft_durability_factor(self, action)) / 100
        return <short> c_ceil(action_durability * status_factor * (
                100 + get_condition(self.craft.cid).get_craft_durability_factor(self, action)
        ) / 100)

    cpdef public short craft_get_action_cost(self, Action action):
        cdef float status_factor = 1
        cdef ushort action_cost = action.get_craft_cost(self)
        if action_cost == 0: return 0
        for p in self.craft.status: status_factor *= (100 + get_status(p.first).get_craft_cost_factor(self, action)) / 100
        return <short> c_ceil(action_cost * status_factor * (
                100 + get_condition(self.craft.cid).get_craft_cost_factor(self, action)
        ) / 100)

    cpdef public char craft_get_used_action(self, char action_id):
        return self.craft.used_action.count(action_id) and self.craft.used_action[action_id]

    cpdef public Craft use_action(self, Action action, uchar fail):
        cdef Status status
        self.craft.to_add_status.clear()
        cdef char is_success = fail == 100 or fail <= action.get_craft_fail_rate(self)
        self.crafting_use_cp(self.craft_get_action_cost(action))
        self.crafting_use_durability(self.craft_get_action_durability(action))
        if is_success == 1:
            self.crafting_add_progress(self.craft_get_action_progress(action))
            if self.crafting_add_quality(self.craft_get_action_quality(action)) > 0 and \
                    self.cs.player.lv >= 11 and self.get_status_stack(s_InnerQuiet) == 0:
                self.crafting_add_status(s_InnerQuiet, 1)
            if action.after_use is not NULL: action.after_use(self)

        if action.kr == 0:
            self.craft.r += 1
            for p in self.craft.status:
                status = get_status(p.first)
                if status.after_round is not NULL:
                    status.after_round(self, action, is_success)
                if status.ks == 0:
                    if p.second <= 1:
                        self.craft.status.erase(p.first)
                    elif self.craft.status.count(p.first) != 0:
                        self.craft.status[p.first] = p.second - 1
            self.craft.la = action.id if is_success else -1
            self.craft.used_action[action.id] = self.craft_get_used_action(action.id) + 1

        cdef Condition condition = get_condition(self.craft.cid)
        if condition.after_round is not NULL: condition.after_round(self, action, is_success)
        for p in self.craft.to_add_status:
            self.craft.status[p.first] = p.second
        self.craft.to_add_status.clear()
        return self

    cpdef public Craft clone(self):
        return Craft(self.cs, self.craft.clone())

    def __str__(self):
        return f"{self.craft.r}|{get_condition(self.craft.cid)}|{self.craft.p}/{self.cs.recipe.p}|" \
               f"{self.craft.q}/{self.cs.recipe.q}|{self.craft.d}/{self.cs.recipe.d}|" \
               f"{self.craft.cp}/{self.cs.player.cp}|" + \
               "/".join(f"{get_status(p.first)}-{p.second}" for p in self.craft.status)
