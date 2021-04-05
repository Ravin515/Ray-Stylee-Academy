# ���Ƿ�ʵ�̵�cube��Ӯ�г�----
library(styleer)
library(quantreg)
library(lfe)
library(lmtest)
# �����������
url <- str_c(getwd(), "/data/Factors/")
file.names <- list.files(path = url, pattern = "*.txt|.csv")
for (i in file.names) {
    assign(str_sub(i, start = 1L, end = -5L), fread(str_c(url, toupper(i))))
}
# ����������̼�����
url <- str_c(getwd(), "/data/Clprc")
Clsprc <- fbread(path = url, pattern = "*.txt")
Clsprc[, stock.symbol := str_pad(Stkcd, 6, side = "left", pad = "0")
    ][, date := as.Date(Trddt)
    ][, ':='(file_id = NULL, Stkcd = NULL, Trddt = NULL, Markettype = NULL)]

# �ֱ��ȫƽ̨������follow֮����follow֮ǰ���������з���----
ld(f.main1, force = T)
ld(f.main2, force = T)
ld(f.cube.ret.sp)
#ld(f.nwl.1806)

# ���Ʊ����ļ��� ----
## ����ʱ��active.day����һ����portfolio��ʼһֱ��Ŀǰʱ����ʱ�䣨�죩
## ����Ƶ��trd.freq�����30��Ľ��״����Ķ���
## ��Ʊ������stock.num������Ĺ�Ʊ������
## �г������mmt������umd
## ��������post.num�����30��ķ��������Ķ���
## f.main1
f.main1[]


# 1. ƽ̨ȫ����----
f.full.daily <- fivefactor_daily[, setnames(.SD, 1, "date")
    ][, date := as.Date(date)
    ][f.cube.ret.sp, on = .(date)
    ][, ret := value / shift(value, type = "lag") - 1, by = .(cube.symbol)
    ][is.infinite(ret), ret := 0
    #][, period := max(date) - min(date), by = .(cube.symbol)
    #][period > 60, .SD
    ]
#f.main1 <- f.main1[, period := max(date) - min(date), by = .(cube.symbol)
    #][period > 60, .SD]

#f.main2 <- f.main2[, period := max(date) - min(date), by = .(cube.symbol)
    #][period > 60, .SD]

outlier <- f.full.daily[ret <= -0.1 | ret >= 0.1, unique(cube.symbol)]

#f.full.daily <- f.main2[, .(cube.symbol, date, follow.date)
    #][f.full.daily, on = .(cube.symbol, date), nomatch = 0
    #][, post.follow := fifelse(is.na(follow.date), 0, fifelse(date < follow.date, 0, 1))]
f.full.daily[!(cube.symbol %in% outlier), lm(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma)] %>% summary()
f.full.daily[!(cube.symbol %in% outlier), rq(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma, tau = 0.2, method = "pfn")] %>% summary()
f.full.daily[!(cube.symbol %in% outlier), rq(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma, tau = 0.4, method = "pfn")] %>% summary()
f.full.daily[!(cube.symbol %in% outlier), rq(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma, tau = 0.6, method = "pfn")] %>% summary()
f.full.daily[!(cube.symbol %in% outlier), rq(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma, tau = 0.8, method = "pfn")] %>% summary()

f.full.daily[!(cube.symbol %in% f.main2$cube.symbol) & !(cube.symbol %in% outlier), lm(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma)] %>% summary()
f.full.daily[!(cube.symbol %in% f.main2$cube.symbol) & !(cube.symbol %in% outlier), rq(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma, tau = 0.2, method = "pfn")] %>% summary()
f.full.daily[!(cube.symbol %in% f.main2$cube.symbol) & !(cube.symbol %in% outlier), rq(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma, tau = 0.8, method = "pfn")] %>% summary()

f.full.daily[(cube.symbol %in% f.main2$cube.symbol) & !(cube.symbol %in% outlier), lm(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma)] %>% summary()
f.full.daily[(cube.symbol %in% f.main2$cube.symbol) & !(cube.symbol %in% outlier), rq(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma, tau = 0.2, method = "pfn")] %>% summary()
f.full.daily[(cube.symbol %in% f.main2$cube.symbol) & !(cube.symbol %in% outlier), rq(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma, tau = 0.8, method = "pfn")] %>% summary()

f.full.daily[(cube.symbol %in% f.main1$cube.symbol) & !(cube.symbol %in% outlier), lm(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma)] %>% summary()
f.full.daily[(cube.symbol %in% f.main1$cube.symbol) & !(cube.symbol %in% outlier), rq(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma, tau = 0.2, method = "pfn")] %>% summary()
f.full.daily[(cube.symbol %in% f.main1$cube.symbol) & !(cube.symbol %in% outlier), rq(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma, tau = 0.8, method = "pfn")] %>% summary()
#f.full.daily[, rq(ret - rf ~ mkt_rf + smb + hml, tau = c(0.1, 0.5, 0.9), method = "pfn", data = .SD)] %>% summary()
#f.full.daily[, rq(ret - rf ~ mkt_rf + smb + hml + umd, tau = c(0.1, 0.5, 0.9), method = "pfn", data = .SD)] %>% summary()
#f.full.daily[, rq(ret - rf ~ mkt_rf + smb + hml + rmw + cma, tau = c(0.1, 0.5, 0.9), method = "pfn", data = .SD)] %>% summary()
#f.full.daily[, rq(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma, tau = c(0.1, 0.5, 0.9), method = "pfn", data = .SD)] %>% summary()



# 2. follow֮ǰ��֮��----
#  2.1 �ն�����----
#f.main1 <- f.cube.ret.sp[sample1[, unique(.SD), .SDcols = c("cube.symbol", "follow.date")]
    #, on = .(cube.symbol)
#][order(cube.symbol, date), .SD]

f.main1.daily <- fivefactor_daily[, setnames(.SD, 1, "date")
    ][, date := as.Date(date)
    ][f.main1, on = .(date)
    ][, ret := value / shift(value, type = "lag") - 1, by = .(cube.symbol)
    ][, period := max(date) - min(date), by = .(cube.symbol)
    ][period > 90, .SD
    ][, .SD[max(date) - follow.date > pre.period], by = .(cube.symbol)
    ][, post.follow := fifelse(date < follow.date, 0, 1), by = .(cube.symbol)
    ][, start := min(date), by = .(cube.symbol)
    ][, active.day := as.numeric(date - min(date)), by = .(cube.symbol)]

cube <- f.main1.daily[, .(len = .N), by = .(cube.symbol, post.follow)
    ][, .SD[len[.N] >= len[1]], by = .(cube.symbol) # ��ѡ����Щpost.followʱ�䳤�ȴ���pre.followʱ�䳤�ȵ�cube
    ][, unique(cube.symbol)]

f.main2.daily <- fivefactor_daily[, setnames(.SD, 1, "date")
    ][, date := as.Date(date)
    ][f.main2, on = .(date)
    ][order(cube.symbol, date), .SD
    ][, ret := value / shift(value, type = "lag") - 1, by = .(cube.symbol)
    ][is.infinite(ret), ret := 0
    ][, period := max(date) - min(date), by = .(cube.symbol)
    ][period > 90, .SD
    ][, .SD[max(date) - follow.date > follow.date - min(date)], by = .(cube.symbol)
    ][, start := min(date), by = .(cube.symbol)
    ][, active.day := as.numeric(date - min(date)), by = .(cube.symbol)]


# �ն����ݣ�followǰ��alpha�Ƚ�
f.main1.daily[!(cube.symbol %in% outlier) & post.follow == 0, lm(ret - rf ~ mkt_rf + smb + hml)] %>% summary()
f.main1.daily[!(cube.symbol %in% outlier) & post.follow == 0, lm(ret - rf ~ mkt_rf + smb + hml + umd)] %>% summary()
f.main1.daily[!(cube.symbol %in% outlier) & post.follow == 0, lm(ret - rf ~ mkt_rf + smb + hml + rmw + cma)] %>% summary()
f.main1.daily[!(cube.symbol %in% outlier) & post.follow == 0, lm(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma)] %>% summary()


f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 1 & (date - follow.date <= pre.period)), lm(ret - rf ~ mkt_rf + smb + hml)] %>% summary()
f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 1 & (date - follow.date <= pre.period)), lm(ret - rf ~ mkt_rf + smb + hml + umd)] %>% summary()
f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 1 & (date - follow.date <= pre.period)), lm(ret - rf ~ mkt_rf + smb + hml + rmw + cma)] %>% summary()
f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 1 & (date - follow.date <= pre.period)), lm(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma)] %>% summary()

f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 1 & (date - follow.date > pre.period)), lm(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma)] %>% summary()
f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 1), lm(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma)] %>% summary()
f.main1.daily[!(cube.symbol %in% outlier), lm(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma)] %>% summary()

f.main2.daily[!(cube.symbol %in% outlier) & (date < follow.date), lm(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma)] %>% summary()
f.main2.daily[!(cube.symbol %in% outlier) & (date >= follow.date), lm(ret - rf ~ mkt_rf + smb + hml + umd + rmw + cma)] %>% summary()
#f.main1.daily[!(cube.symbol %in% outlier) & post.follow == 0, lm(ret - rf ~ mkt_rf + smb + hml + rmw + cma)] %>% summary()
#f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 1 & (date - follow.date < pre.period)), lm(ret - rf ~ mkt_rf + smb + hml + rmw + cma)] %>% summary()

#f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 1 & (date - follow.date > pre.period)), lm(ret - rf ~ mkt_rf + smb + hml)] %>% summary()
#f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 1 & (date - follow.date > pre.period)), lm(ret - rf ~ mkt_rf + smb + hml + umd)] %>% summary()

#f.main1.daily[!(cube.symbol %in% outlier) & post.follow == 1, lm(ret - rf ~ mkt_rf + smb + hml)] %>% summary()
#f.main1.daily[!(cube.symbol %in% outlier) & post.follow == 1, lm(ret - rf ~ mkt_rf + smb + hml + umd)] %>% summary()
#f.main1.daily[!(cube.symbol %in% outlier) & post.follow == 1, lm(ret - rf ~ mkt_rf + smb + hml + rmw + cma)] %>% summary()

#f.main1.daily[!(cube.symbol %in% outlier), lm(ret - rf ~ mkt_rf + smb + hml)] %>% summary()
#f.main1.daily[!(cube.symbol %in% outlier), lm(ret - rf ~ mkt_rf + smb + hml + umd)] %>% summary()


#f.main2 <- sample2[, .(cube.symbol = unique(cube.symbol))
#][f.cube.ret.sp, on = .(cube.symbol), nomatch = 0
#][f.nwl.1806, on = .(cube.symbol, date), nomatch = 0
#]

# �ն����ݣ�followǰ��ret�Ƚ�
# Newey West t-test
nwttest.daily <- f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 0 | (post.follow == 1 & (date - follow.date <= pre.period)))]
a <- nwttest.daily[post.follow == 0, ret]
b <- nwttest.daily[post.follow == 1, ret]
nwttest.daily[, .(avg.ret = mean(ret, na.rm = T)), by = .(post.follow, cube.symbol)
    ][, t.test(avg.ret ~ post.follow)]
lm((b - a) ~ 1) %>% lmtest::coeftest()

# �̶�ЧӦ�ع�
f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 0 | (post.follow == 1 & (date - follow.date <= pre.period))), felm(ret ~ post.follow | cube.symbol + follow.date + active.day)] %>% summary()
f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 0 | (post.follow == 1 & (date - follow.date <= pre.period))), felm(ret ~ post.follow + mkt_rf + smb + hml | cube.symbol + follow.date + active.day)] %>% summary()
f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 0 | (post.follow == 1 & (date - follow.date <= pre.period))), felm(ret ~ post.follow + mkt_rf + smb + hml + umd | cube.symbol + follow.date + active.day)] %>% summary()
f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 0 | (post.follow == 1 & (date - follow.date <= pre.period))), felm(ret ~ post.follow + mkt_rf + smb + hml + rmw + cma | cube.symbol + follow.date + active.day)] %>% summary()
f.main1.daily[!(cube.symbol %in% outlier) & (post.follow == 0 | (post.follow == 1 & (date - follow.date <= pre.period))), felm(ret ~ post.follow + mkt_rf + smb + hml + umd + rmw + cma | cube.symbol + follow.date + active.day)] %>% summary()
f.main1.daily[!(cube.symbol %in% outlier), felm(ret ~ post.follow  | cube.symbol + follow.date + active.day)] %>% summary()
f.main1.daily[!(cube.symbol %in% outlier), felm(ret ~ post.follow + mkt_rf + smb + hml + umd + rmw + cma | cube.symbol + follow.date + active.day)] %>% summary()

# �ն����ݣ��������������µ�ret�Ƚ�
f.main2.daily[!(cube.symbol %in% outlier), felm(ret ~ log(ind + 1) | cube.symbol  + active.day)] %>% summary()
f.main2.daily[!(cube.symbol %in% outlier), felm(ret ~ log(oud + 1) | cube.symbol  + active.day)] %>% summary()
f.main2.daily[!(cube.symbol %in% outlier), felm(ret ~ I(ln.cntr * 100) | cube.symbol  + active.day)] %>% summary()
f.main2.daily[!(cube.symbol %in% outlier), felm(ret ~ I(ln.cntr * 100) + log(oud + 1) + log(ind + 1) + umd | cube.symbol  + active.day)] %>% summary()
f.main2.daily[!(cube.symbol %in% outlier), felm(ret ~ I(ln.cntr * 100) + log(oud + 1) + log(ind + 1) + mkt_rf + smb + hml + umd + rmw + cma | cube.symbol  + active.day)] %>% summary()


### 2.2 �ܶ�����
#fivefactor_weekly[, trdwk := str_c(year(trdwk), week(trdwk))]
#f.main1[, trdwk := str_c(year(date), week(date))]
#f.main1.weekly <- fivefactor_weekly[f.main1, on = .(trdwk)
    #][, ret := value / shift(value, type = "lag") - 1, by = .(cube.symbol)
    #][is.infinite(ret), ret := 0
    ##][ret != 0, .SD # ȥ����Щvalueһֱû��ļ�¼
    #][, .SD[.N], by = .(cube.symbol, trdwk)
    #][, ret_week := value / shift(value, type = "lag") - 1, by = .(cube.symbol)
    #][is.infinite(ret_week), ret_week := 0
    #][pre.period >= 7, .SD
    #][, post.follow := fifelse(date < follow.date, 0, 1), by = .(cube.symbol)]

#f.main1.weekly[!(cube.symbol %in% outlier) & (post.follow == 0 | (post.follow == 1 & (date - follow.date < pre.period))), felm(ret_week ~ post.follow | cube.symbol + date)] %>% summary()

#f.main1.weekly[!(cube.symbol %in% outlier) & post.follow == 0, lm(ret_week - rf ~ mkt_rf + smb + hml)] %>% summary()
#f.main1.weekly[!(cube.symbol %in% outlier) & post.follow == 1 & (date - follow.date < pre.period), lm(ret_week - rf ~ mkt_rf + smb + hml)] %>% summary()

#f.main1.weekly[!(cube.symbol %in% outlier) & post.follow == 0, lm(ret_week - rf ~ mkt_rf + smb + hml + umd)] %>% summary()
#f.main1.weekly[!(cube.symbol %in% outlier) & post.follow == 1 & (date - follow.date < pre.period), lm(ret_week - rf ~ mkt_rf + smb + hml + umd)] %>% summary()

#f.main1.weekly[!(cube.symbol %in% outlier) & post.follow == 0, lm(ret_week - rf ~ mkt_rf + smb + hml + rmw + cma)] %>% summary()
#f.main1.weekly[!(cube.symbol %in% outlier) & post.follow == 1 & (date - follow.date < pre.period), lm(ret_week - rf ~ mkt_rf + smb + hml + rmw + cma)] %>% summary()

#f.main1.weekly[post.follow == 1 & (date - follow.date > pre.period), lm(ret_week - rf ~ mkt_rf + smb + hml)] %>% summary()
#f.main1.weekly[post.follow == 1 & (date - follow.date > pre.period), lm(ret_week - rf ~ mkt_rf + smb + hml + umd)] %>% summary()
#f.main1.weekly[post.follow == 1 & (date - follow.date > pre.period), lm(ret_week - rf ~ mkt_rf + smb + hml + rmw + cma)] %>% summary()

#f.main1.weekly[post.follow == 1, lm(ret_week - rf ~ mkt_rf + smb + hml)] %>% summary()
#f.main1.weekly[post.follow == 1, lm(ret_week - rf ~ mkt_rf + smb + hml + umd)] %>% summary()
#f.main1.weekly[post.follow == 1, lm(ret_week - rf ~ mkt_rf + smb + hml + rmw + cma)] %>% summary()

#f.main1.weekly[, lm(ret_week - rf ~ mkt_rf + smb + hml)] %>% summary()
#f.main1.weekly[, lm(ret_week - rf ~ mkt_rf + smb + hml + umd)] %>% summary()
#f.main1.weekly[, lm(ret_week - rf ~ mkt_rf + smb + hml + rmw + cma)] %>% summary()


## 2.3 �¶����� ----
# �ȼ���ÿ�½�������
trd.dnum <- Clsprc[, .(date = unique(date))
    ][, trdmn := as.character(date) %>% str_sub(start = 1L, end = 7L) %>% str_replace_all("-", "")
    ][, trd.dnum.std := .N, by = .(trdmn)
    ][, unique(.SD), .SDcols = -1]
# f.main1
f.main1[, trdmn := as.character(date) %>% str_sub(start = 1L, end = 7L) %>% str_replace_all("-", "")
    ][, start := min(date), by = .(cube.symbol)
    ][, trd.dnum := .N, by = .(cube.symbol, trdmn)]
f.main1 <- trd.dnum[f.main1, on = .(trdmn)]

f.main1.monthly <- fivefactor_monthly[, trdmn := as.character(trdmn)
    ][f.main1, on = .(trdmn)
    ][, pre.period := follow.date - min(date), by = .(cube.symbol)
    ][pre.period >= 30, .SD
    ][, ret := value / shift(value, type = "lag") - 1, by = .(cube.symbol)
    ][is.infinite(ret), ret := 0
    #][ret != 0, .SD # ȥ����Щvalueһֱû��ļ�¼
    ][, .SD[.N], by = .(cube.symbol, trdmn)
    ][, ret_month := value / shift(value, type = "lag") - 1, by = .(cube.symbol)
    ][is.infinite(ret_month), ret_month := 0
    #][, trdmn.fd := as.character(follow.date) %>% str_sub(start = 1L, end = 7L) %>% str_replace_all("-", "")
    ][, post.follow := fifelse(date > follow.date, 1, 0), by = .(cube.symbol)
    #][, .SD[-.N], by = .(cube.symbol)
    ][, active.day := as.numeric(date - start), by = .(cube.symbol)
    ][!(trdmn %in% c("201606", "201807")), .SD
    ][trd.dnum.std == trd.dnum, .SD]


# �¶����ݣ��¶�Alpha�Ƚ� 
f.main1.monthly[!(cube.symbol %in% outlier) & post.follow == 0, lm(ret_month - rf ~ mkt_rf + smb + hml + umd + rmw + cma)] %>% summary()
f.main1.monthly[!(cube.symbol %in% outlier) & post.follow == 1 & (date - follow.date <= pre.period), lm(ret_month - rf ~ mkt_rf + smb + hml + umd + rmw + cma)] %>% summary()

# Newey west t-test
nwttest.monthly <- f.main1.monthly[!(cube.symbol %in% outlier) & (post.follow == 0 | (post.follow == 1 & (date - follow.date <= pre.period)))]
a <- nwttest.monthly[post.follow == 0, ret]
b <- nwttest.monthly[post.follow == 1, ret]
nwttest.monthly[, .(avg.ret = mean(ret_month, na.rm = T)), by = .(post.follow, cube.symbol)
    ][, t.test(avg.ret ~ post.follow)]
lm((b - a) ~ 1) %>% lmtest::coeftest()

# �¶����ݣ��¶�ret�Ƚ�
f.main1.monthly[!(cube.symbol %in% outlier) & (post.follow == 0 | (post.follow == 1 & (date - follow.date <= pre.period))), felm(ret_month ~ post.follow | cube.symbol + trdmn)] %>% summary()
f.main1.monthly[!(cube.symbol %in% outlier), felm(ret_month ~ post.follow | cube.symbol + follow.date + active.day)] %>% summary()
f.main1.monthly[!(cube.symbol %in% outlier) & (post.follow == 0 | (post.follow == 1 & (date - follow.date <= pre.period))), felm(ret_month ~ post.follow + mkt_rf + smb + hml + umd + rmw + cma | cube.symbol + follow.date + active.day)] %>% summary()
f.main1.monthly[!(cube.symbol %in% outlier), felm(ret_month ~ post.follow + mkt_rf + smb + hml + umd + rmw + cma | cube.symbol + follow.date + active.day)] %>% summary()


# f.main2
f.main2[, trdmn := as.character(date) %>% str_sub(start = 1L, end = 7L) %>% str_replace_all("-", "")
    ][, start := min(date), by = .(cube.symbol)]
f.main2.monthly <- fivefactor_monthly[, trdmn := as.character(trdmn)
    ][f.main2, on = .(trdmn)
    ][, ret := value / shift(value, type = "lag") - 1, by = .(cube.symbol)
    ][is.infinite(ret), ret := 0
    ][, ':='(oud_month = mean(oud, na.rm = T), ind_month = mean(ind, na.rm = T), ln.cntr_month = mean(ln.cntr, na.rm = T)), by = .(cube.symbol, trdmn)
    #][ret != 0, .SD # ȥ����Щvalueһֱû��ļ�¼
    ][, .SD[.N], by = .(cube.symbol, trdmn)
    ][, ret_month := value / shift(value, type = "lag") - 1, by = .(cube.symbol)
    ][is.infinite(ret_month), ret_month := 0
    ][, pre.period := follow.date - min(date), by = .(cube.symbol)
    ][pre.period >= 30, .SD
    ][order(cube.symbol, date, trdmn), .SD
    ][, post.follow := fifelse(date < follow.date, 0, 1), by = .(cube.symbol)
    ][, .SD[-.N], by = .(cube.symbol)
    ]

f.main2.monthly[!(cube.symbol %in% outlier), felm(ret_month ~ log(ind_month + 1) | cube.symbol + follow.date)] %>% summary()
f.main2.monthly[!(cube.symbol %in% outlier), felm(ret_month ~ log(oud_month + 1) | cube.symbol + follow.date)] %>% summary()
f.main2.monthly[!(cube.symbol %in% outlier), felm(ret_month ~ I(ln.cntr_month * 100) | cube.symbol + follow.date)] %>% summary()
f.main2.monthly[!(cube.symbol %in% outlier), felm(ret_month ~ I(ln.cntr_month * 100) + log(oud_month + 1) + log(ind_month + 1)  | cube.symbol + date)] %>% summary()
#f.main2.monthly[!(cube.symbol %in% outlier), felm(ret_month ~ I(ln.cntr * 100) + log(oud + 1) + log(ind + 1) + mkt_rf + smb + hml + umd + rmw + cma | cube.symbol + follow.date)] %>% summary()
