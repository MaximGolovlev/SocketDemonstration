# SocketDemonstration

Реализовать основную таблицу выведения котировок (один экран), данные обновляются в реальном времени.
Подписка на котировки по сокетам (socket-io).

Аналогично приложению https://apps.apple.com/app/id1178912301

Или мобильной версии сайта https://tradernet.ru/terminal/mobile/quotes

![Image of Yaktocat](https://i.ibb.co/Wz4M1ZD/2020-09-21-21-40-05.png)
1. API для получения данных по котировкам (сервер ws3.tradernet.ru) https://tradernet.ru/tradernet-api/quotes-get-changes
2. Использовать фиксированный список бумаг с идентификаторами
RSTI,GAZP,MRKZ,RUAL,HYDR,MRKS,SBER,FEES,TGKA,VTBR,ANH.US,VICL.US,BURG. US,NBL.US,YETI.US,WSFS.US,NIO.US,DXC.US,MIC.US,HSBC.US,EXPN.EU,GSK.EU,SH P.EU,MAN.EU,DB1.EU,MUV2.EU,TATE.EU,KGF.EU,MGGT.EU,SGGD.EU
3. Логотипы компаний не требуются.
4. Данные используемые в верстке
1. Тикер
2. Изменение в процентах относительно цены закрытия предыдущей торговой сессии
3. Биржа последней сделки
4. Название бумаги
5. Цена последней сделки
6. (Изменение цены последней сделки в пунктах относительно цены закрытия предыдущей торговой сессии)
5. Значение с положительным значение имеет зеленый шрифт, с отрицательным – красный.
6. Подсветка идет зеленым при изменении значения в положительную сторону, красным при изменении значения в отрицательную сторону.
7. Разрешено использование сторонних библиотек и решений (Socket.IO-Client-Swift, Alamofire и проч.).
Будем рады промежуточным результатам.

По желанию:
1. Получить список котировок в api
https://tradernet.ru/tradernet-api/quotes-get-top-securities
'type': 'stocks', 'exchange': 'russia', 'gainers': 0, 'limit': 30 
2. Получить лого здесь
https://tradernet.ru/logos/get-logo-by-ticker?ticker= + lowercased ticker 
3. Округлить выводимое значение цены и изменения цены до min_step
