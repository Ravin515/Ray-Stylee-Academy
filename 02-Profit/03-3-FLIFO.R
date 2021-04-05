library(styleer)
ld(f.hold.price.1806)

# 1. �ҳ���Щtw��pw��ͻ�ĵ���----
r.flifo <- f.hold.price.1806[, .(cube.symbol, stock.symbol, created.at, price, target.weight, prev.weight.adjusted, row = .I)]
# ����ĳЩͬһ�յ�ͬһ��Ʊ����ʱ�䲻һ�µ�����

#filter <- function(r.flifo, n) {
    #r.flifo.f <- data.table()
    #while (n < 10) {
        #r.flifo.1 <- r.flifo[order(cube.symbol, stock.symbol, row), .SD
        #][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
        #][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
        #][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
        #][tag.weird.sum >= 1, .SD
        ##][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
        #][, date := as.Date(created.at)
        #][, row := .I
        #][, row.rv := fcase(tag.weird == 1 & date == shift(date, type = "lag"), row - 1,
    #tag.weird == 0 & shift(tag.weird, type = "lead") == 1 & date == shift(date, type = "lead"), row + 1
    #), by = .(cube.symbol, stock.symbol)]

        #r.flifo.1 <- r.flifo[, .(cube.symbol, stock.symbol, created.at, row)]
        #r.flifo.2 <- r.flifo[, .(cube.symbol, stock.symbol, price, target.weight, prev.weight.adjusted, row = fifelse(is.na(row.rv), row, row.rv))]
        #a <- r.flifo[tag.weird.sum == 0, .SD]
        #r.flifo <- r.flifo.1[r.flifo.2, on = .(cube.symbol, stock.symbol, row)]
        #f.flifo.f <- rbindlist(list(a, f.flifo.f), fill = T)
        #n <- n + 1
    #}
    #r.flifo.f
#}
#r.flifo.f <- filter(r.flifo, 1)

# 2. �ظ���ϴ9��----
# ��ϴ��1��
r1.flifo <- r.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum >= 1, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ][, date := as.Date(created.at)
    ][, row := .I
    ][, row.rv := fcase(tag.weird == 1 & date == shift(date, type = "lag"), row - 1,
    tag.weird == 0 & shift(tag.weird, type = "lead") == 1 & date == shift(date, type = "lead"), row + 1
    ), by = .(cube.symbol, stock.symbol)]

r1.flifo.1 <- r1.flifo[, .(cube.symbol, stock.symbol, created.at, row)]
r1.flifo.2 <- r1.flifo[, .(cube.symbol, stock.symbol, price, target.weight, prev.weight.adjusted, row = fifelse(is.na(row.rv), row, row.rv))]
r1.flifo.f <- r.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum == 0, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ]
r1.flifo <- r1.flifo.1[r1.flifo.2, on = .(cube.symbol, stock.symbol, row)]

# ��ϴ��2��
r2.flifo <- r1.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum >= 1, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ][, date := as.Date(created.at)
    ][, row := .I
    ][, row.rv := fcase(tag.weird == 1 & date == shift(date, type = "lag"), row - 1,
    tag.weird == 0 & shift(tag.weird, type = "lead") == 1 & date == shift(date, type = "lead"), row + 1
    ), by = .(cube.symbol, stock.symbol)]

r2.flifo.1 <- r2.flifo[, .(cube.symbol, stock.symbol, created.at, row)]
r2.flifo.2 <- r2.flifo[, .(cube.symbol, stock.symbol, price, target.weight, prev.weight.adjusted, row = fifelse(is.na(row.rv), row, row.rv))]
r2.flifo.f <- r1.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum == 0, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ]
r2.flifo <- r2.flifo.1[r2.flifo.2, on = .(cube.symbol, stock.symbol, row)]

# ��ϴ��3��
r3.flifo <- r2.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum >= 1, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ][, date := as.Date(created.at)
    ][, row := .I
    ][, row.rv := fcase(tag.weird == 1 & date == shift(date, type = "lag"), row - 1,
    tag.weird == 0 & shift(tag.weird, type = "lead") == 1 & date == shift(date, type = "lead"), row + 1
    ), by = .(cube.symbol, stock.symbol)]

r3.flifo.1 <- r3.flifo[, .(cube.symbol, stock.symbol, created.at, row)]
r3.flifo.2 <- r3.flifo[, .(cube.symbol, stock.symbol, price, target.weight, prev.weight.adjusted, row = fifelse(is.na(row.rv), row, row.rv))]
r3.flifo.f <- r2.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum == 0, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ]
r3.flifo <- r3.flifo.1[r3.flifo.2, on = .(cube.symbol, stock.symbol, row)]

# ��ϴ��4��
r4.flifo <- r3.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum >= 1, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ][, date := as.Date(created.at)
    ][, row := .I
    ][, row.rv := fcase(tag.weird == 1 & date == shift(date, type = "lag"), row - 1,
    tag.weird == 0 & shift(tag.weird, type = "lead") == 1 & date == shift(date, type = "lead"), row + 1
    ), by = .(cube.symbol, stock.symbol)]

r4.flifo.1 <- r4.flifo[, .(cube.symbol, stock.symbol, created.at, row)]
r4.flifo.2 <- r4.flifo[, .(cube.symbol, stock.symbol, price, target.weight, prev.weight.adjusted, row = fifelse(is.na(row.rv), row, row.rv))]
r4.flifo.f <- r3.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum == 0, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ]
r4.flifo <- r4.flifo.1[r4.flifo.2, on = .(cube.symbol, stock.symbol, row)]

# ��ϴ��5��
r5.flifo <- r4.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum >= 1, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ][, date := as.Date(created.at)
    ][, row := .I
    ][, row.rv := fcase(tag.weird == 1 & date == shift(date, type = "lag"), row - 1,
    tag.weird == 0 & shift(tag.weird, type = "lead") == 1 & date == shift(date, type = "lead"), row + 1
    ), by = .(cube.symbol, stock.symbol)]

r5.flifo.1 <- r5.flifo[, .(cube.symbol, stock.symbol, created.at, row)]
r5.flifo.2 <- r5.flifo[, .(cube.symbol, stock.symbol, price, target.weight, prev.weight.adjusted, row = fifelse(is.na(row.rv), row, row.rv))]
r5.flifo.f <- r4.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum == 0, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ]
r5.flifo <- r5.flifo.1[r5.flifo.2, on = .(cube.symbol, stock.symbol, row)]

# ��ϴ��6��
r6.flifo <- r5.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum >= 1, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ][, date := as.Date(created.at)
    ][, row := .I
    ][, row.rv := fcase(tag.weird == 1 & date == shift(date, type = "lag"), row - 1,
    tag.weird == 0 & shift(tag.weird, type = "lead") == 1 & date == shift(date, type = "lead"), row + 1
    ), by = .(cube.symbol, stock.symbol)]

r6.flifo.1 <- r6.flifo[, .(cube.symbol, stock.symbol, created.at, row)]
r6.flifo.2 <- r6.flifo[, .(cube.symbol, stock.symbol, price, target.weight, prev.weight.adjusted, row = fifelse(is.na(row.rv), row, row.rv))]
r6.flifo.f <- r5.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum == 0, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ]
r6.flifo <- r6.flifo.1[r6.flifo.2, on = .(cube.symbol, stock.symbol, row)]

# ��ϴ��7��
r7.flifo <- r6.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum >= 1, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ][, date := as.Date(created.at)
    ][, row := .I
    ][, row.rv := fcase(tag.weird == 1 & date == shift(date, type = "lag"), row - 1,
    tag.weird == 0 & shift(tag.weird, type = "lead") == 1 & date == shift(date, type = "lead"), row + 1
    ), by = .(cube.symbol, stock.symbol)]

r7.flifo.1 <- r7.flifo[, .(cube.symbol, stock.symbol, created.at, row)]
r7.flifo.2 <- r7.flifo[, .(cube.symbol, stock.symbol, price, target.weight, prev.weight.adjusted, row = fifelse(is.na(row.rv), row, row.rv))]
r7.flifo.f <- r6.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum == 0, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ]
r7.flifo <- r7.flifo.1[r7.flifo.2, on = .(cube.symbol, stock.symbol, row)]

# ��ϴ��8��
r8.flifo <- r7.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum >= 1, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ][, date := as.Date(created.at)
    ][, row := .I
    ][, row.rv := fcase(tag.weird == 1 & date == shift(date, type = "lag"), row - 1,
    tag.weird == 0 & shift(tag.weird, type = "lead") == 1 & date == shift(date, type = "lead"), row + 1
    ), by = .(cube.symbol, stock.symbol)]

r8.flifo.1 <- r8.flifo[, .(cube.symbol, stock.symbol, created.at, row)]
r8.flifo.2 <- r8.flifo[, .(cube.symbol, stock.symbol, price, target.weight, prev.weight.adjusted, row = fifelse(is.na(row.rv), row, row.rv))]
r8.flifo.f <- r7.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum == 0, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ]
r8.flifo <- r8.flifo.1[r8.flifo.2, on = .(cube.symbol, stock.symbol, row)]

# ��ϴ��9��
r9.flifo <- r8.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum >= 1, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ][, date := as.Date(created.at)
    ][, row := .I
    ][, row.rv := fcase(tag.weird == 1 & date == shift(date, type = "lag"), row - 1,
    tag.weird == 0 & shift(tag.weird, type = "lead") == 1 & date == shift(date, type = "lead"), row + 1
    ), by = .(cube.symbol, stock.symbol)]

r9.flifo.1 <- r9.flifo[, .(cube.symbol, stock.symbol, created.at, row)]
r9.flifo.2 <- r9.flifo[, .(cube.symbol, stock.symbol, price, target.weight, prev.weight.adjusted, row = fifelse(is.na(row.rv), row, row.rv))]
r9.flifo.f <- r8.flifo[order(cube.symbol, stock.symbol, row), .SD
    ][, ':='(tt.sale = fifelse(target.weight - shift(target.weight, type = 'lag') > 0, 0, 1), tp.sale = fifelse(target.weight - prev.weight.adjusted > 0, 0, 1)), by = .(cube.symbol, stock.symbol)
    ][, tag.weird := fifelse(!is.na(tt.sale) & tt.sale != tp.sale, 1, 0)
    ][, tag.weird.sum := sum(tag.weird, na.rm = T), by = .(cube.symbol, stock.symbol)
    ][tag.weird.sum == 0, .SD
    #][, .SD[prev.weight.adjusted[1] == 0], by = .(cube.symbol, stock.symbol)
    ]
r9.flifo <- r9.flifo.1[r9.flifo.2, on = .(cube.symbol, stock.symbol, row)]

# 3. ��������ϴ�������ݽ��кϲ�----
a <- ls() %>% str_detect(".+flifo\\.f")
a <- ls()[a]
f.flifo <- rbindlist(lapply(a, get), fill = T)
rm(list = ls()[!(ls() %in% c("f.flifo", "f.hold.price.1806"))])


# ������cubeÿһֻ��Ʊͬһ��Ľ��׽��кϲ�
ld(f.flifo, force = T)
f.flifo <- f.flifo[, unique(.SD), .SDcols = -(7:11)
    ][, unique(.SD)
    ][order(cube.symbol, stock.symbol, created.at), .SD
    ]
r.flifo <- f.flifo[, tag := sum(.N), by = .(cube.symbol, stock.symbol, created.at)
    ][tag > 1, .SD
    ][, .(prev.weight.adjusted = prev.weight.adjusted[1], target.weight = target.weight[.N], price = mean(price)), by = .(cube.symbol, stock.symbol, created.at)]
f.flifo <- f.flifo[tag == 1, .SD
    ][, tag := NULL]
f.flifo <- rbindlist(list(f.flifo, r.flifo), fill = T, use.names = T)
rm(r.flifo)
sv(f.flifo, svname = "f.flifo")

# 4. �п��ܴ������ʽ���target.weight��ȵ�״�������������ɾ��һ�����ڸ�����Ľ��� ----
ld(f.flifo, force = T)
filter <- f.flifo[, tag := fifelse(target.weight == shift(target.weight, type = "lag") | target.weight == shift(target.weight, type = "lead"), 1, 0)
    ][tag == 1, .SD
    ][, .SD[created.at == min(created.at)], by = .(cube.symbol, stock.symbol)]
raw <- f.flifo[tag == 0, .SD]
f.flifo <- rbindlist(list(filter, raw), fill = T, use.names = T)
f.flifo <- f.flifo[, tag := NULL
    ][order(cube.symbol, stock.symbol, created.at), .SD]
sv(f.flifo, svname = "f.flifo")

# 5. ����FIFO�������ÿ�ʽ���֮���open postion----
ld(f.flifo)
f.fifo <- f.flifo[, id := .I #���ÿһ�ʽ��׵�id
    ][, sale := fifelse(target.weight < prev.weight.adjusted, 1, 0)
    ][, tag.stock := ifelse(target.weight == 0, 1, 0) # ����ÿ��ͬһֻ��Ʊ��ֱ��
    ][, tag.stock := cumsum(tag.stock), by = .(cube.symbol, stock.symbol)
    ][, tag.stock.lag := shift(tag.stock), by = .(cube.symbol, stock.symbol)
    ][, tag.stock.lag := fifelse(is.na(tag.stock.lag), tag.stock, tag.stock.lag)
    ][, tag.stock := tag.stock.lag
    ][, tag.stock.lag := NULL
    ][, stock.symbol.tag := str_c(stock.symbol, tag.stock, sep = "_") # ����ÿ��ͬһֻ��Ʊ��ֱ��
    ][, change.weight := target.weight - shift(target.weight, type = "lag"), by = .(cube.symbol, stock.symbol.tag)
    ][, change.weight := fifelse(is.na(change.weight), target.weight, change.weight)
    ][, cum.change.weight := cumsum(change.weight), by = .(cube.symbol, stock.symbol)
    ][, tag.order := 1:.N, by = .(cube.symbol, stock.symbol.tag)
    ][, prev.weight := shift(target.weight, type = "lag"), by = .(cube.symbol, stock.symbol.tag)
    ][, prev.weight := fifelse(is.na(prev.weight), 0, prev.weight)
    ]

f.fifo <- f.fifo[, .(open.position = {
    l <- list()
    for (i in 1:.N) {
        if (tag.order[i] == 1) {
            # ÿ��cubeÿ��stock�ĵ�һ�ʽ���
            l[[i]] <- data.table(hold.weight = target.weight[i], hold.price = price[i], hold.id = id[i])
        }
        else {
            # �ǵ�һ�ʽ���
            rd <- .SD[1:(i - 1)];
            buy.rd <- rd[sale == 0, .SD
                    ][, cum.buy.weight := cumsum(change.weight)];
            sale.rd <- rd[sale == 1, .SD
                    ][, cum.sale.weight := cumsum(change.weight)];
            if (target.weight[i] == 0) {
                # ���
                l[[i]] <- data.table()
                # ����һ��realized.gain��Ҫ����
            }
            else if (change.weight[i] < 0 & target.weight[i] != 0) {
                # ��ǰΪ��������
                hw <- target.weight[i];
                p <- price[i];
                br <- buy.rd[order(-id), .SD
                        ][, cum.buy.weight1 := cumsum(change.weight)]
                s.1 <- br[cum.buy.weight1 <= hw
                        ][, .(hold.weight = change.weight, hold.price = price, hold.id = id)];
                s.2 <- br[cum.buy.weight1 - hw > 0, .SD[1]
                        ][, .(hold.weight = abs(hw - s.1[, sum(hold.weight)]), hold.price = price, hold.id = id)];
                s.3 <- rbindlist(list(s.1, s.2), fill = T, use.names = T)
                l[[i]] <- s.3
            }
            else if (change.weight[i] > 0) {
                # ��ǰΪ���뽻��
                if (sale.rd[, .N] == 0) {
                    # ֮ǰ����������Ϊ0��
                    b.1 <- buy.rd[, .(hold.weight = change.weight, hold.price = price, hold.id = id)]
                    b.2 <- data.table(hold.weight = change.weight[i], hold.price = price[i], hold.id = id[i])
                    l[[i]] <- rbindlist(list(b.1, b.2), fill = T, use.names = T)
                }
                else {
                    # ֮ǰ���������ײ�Ϊ0��
                    # ��Ҫ�����׷�Ϊ��һ�ʽ��׵����һ���������ף����һ���������׵�������ʽ���������
                    # ��һ�ʽ��׵��������׵Ĳ���
                    rd1 <- rd[id <= sale.rd[, id[.N]]];
                    buy.rd1 <- rd1[sale == 0, .SD
                            ][, cum.buy.weight := cumsum(change.weight)];
                    sale.rd1 <- rd[sale == 1, .SD
                            ][, cum.sale.weight := cumsum(change.weight)];
                    hw <- rd1[, target.weight[.N]];
                    p <- price[i];
                    br1 <- buy.rd1[order(-id), .SD
                            ][, cum.buy.weight1 := cumsum(change.weight)]
                    b.1 <- br1[cum.buy.weight1 <= hw
                            ][, .(hold.weight = change.weight, hold.price = price, hold.id = id)];
                    b.2 <- br1[cum.buy.weight1 - hw > 0, .SD[1]
                            ][, .(hold.weight = abs(hw - s.1[, sum(hold.weight)]), hold.price = price, hold.id = id)];
                    # ���һ���������׵�������ʽ��׵Ĳ���
                    b.3 <- rd[id > sale.rd[, id[.N]]
                        ][, .(hold.weight = change.weight, hold.price = price, hold.id = id)];
                    b.4 <- data.table(hold.weight = change.weight[i], hold.price = price[i], hold.id = id[i])
                    l[[i]] <- rbindlist(list(b.1, b.2, b.3, b.4), fill = T, use.names = T)
                }
            }
        }
    }
    l
}, created.at = created.at, price, target.weight, prev.weight.adjusted, id), by = .(cube.symbol, stock.symbol.tag)]
sv(f.fifo, svname = "f.fifo")

# 6. ������Щ�������׵�realized return----
ld(f.fifo, force = T)
# ɾ��һЩ�������
remove.tag <- f.fifo[, .SD[target.weight == shift(target.weight, type = "lag") | target.weight == shift(target.weight, type = "lead")], by = .(cube.symbol, stock.symbol.tag)
    ][sapply(open.position, is.null), .SD
    ][, id]
f.fifo <- f.fifo[!(id %in% remove.tag), .SD]

# ����realized return
f.fifo.filter <- f.fifo[, sale := fifelse(target.weight < prev.weight.adjusted, 1, 0)
    #][, realized.ret := NULL
    ][, .SD[.N > 1], by = .(cube.symbol, stock.symbol.tag)
    ]
f.fifo.filter <- f.fifo.filter[target.weight != prev.weight.adjusted, realized.ret := {
    l <- vector(mode = "numeric")
    for (i in 2:.N) {
        if (sale[i] == 1) {
            a <- open.position[[i]]
            b <- open.position[[i - 1]]
            if (length(a) == 0) {
                hw <- b[, .(rr = sum((price[i] - hold.price) * hold.weight)/sum(hold.price * hold.weight))]
                l[i] <- unique(hw$rr)
            }
            else {
                hw <- a[b, on = .(hold.id, hold.price)
                ][, hold.weight.change := fifelse(!is.na(hold.weight), i.hold.weight - hold.weight, i.hold.weight)
                ][, .(rr = sum((price[i] - hold.price) * hold.weight.change)/sum(hold.price * hold.weight.change))]
                l[i] <- unique(hw$rr)
            }
        }
        else {
            l[i] <- 0
        }
    }
    l
    }, by = .(cube.symbol, stock.symbol.tag)]

f.fifo.filter <- f.fifo.filter[, .SD, .SDcols = c("cube.symbol", "stock.symbol.tag", "created.at", "realized.ret")
    ][f.fifo[target.weight != prev.weight.adjusted, .SD], on = .(cube.symbol, stock.symbol.tag, created.at), nomatch = NA]
f.fifo.filter[, realized.ret := fifelse(is.na(realized.ret), 0, realized.ret)]
f.fifo <- f.fifo.filter
rm(f.fifo.filter)
sv(f.fifo, svname = "f.fifo")