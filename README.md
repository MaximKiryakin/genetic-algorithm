# genetic-algorithm
Требуется найти экстремум функции одной переменной на заданном интервале генетическим
алгоритмом [1].
Размер начальной популяции population_volume является параметром программы. Значение
по умолчанию равно 30. Начальная популяция формируется случайным образом. Количество
скрещиваемых особей (допустимых решений) и вероятность мутации особи задаются в парамет-
рах программы.
Все функции заданы на отрезке [0,4). В функциях 1,4-8 необходимо найти max и argmax, а
в функциях 2,3 необходимо найти min и argmin

Генетический алгоритм работает в соответствии со следующими шагами:
1. Чтение параметров
2. Формирование начальной популяции
3. Вычисление функции качества для каждой особи и сортировка популяции
4. Проверка условия остановки. Если достигнуто завершаем алгоритм.
5. Селекция
6. Формирование новой популяции: cкрещивания, мутации
7. переход на шаг 3.

4.2. Генерация начальной популяции
Генерация начальной популяции может происходить как случайным образом, так и с помощью
некоторого алгоритма.
4.3. Вычисление целевой функции
Целевая функция (функция качества) позволяет оценить степень приспособленности данной
особи в популяции и характеризует качество получаемого решения. В данной задаче целевая
функция это значение одной из функций f1(x),...,f8(x) в точке, соответствующей данной осо-
би. Во время генетического процесса вычисление целевой функции осуществляется над элемен-
тами всей популяции решений. Нужно отметить, что достаточно часто сложность генетических
алгоритмов оценивается по количеству вычислений целевой функции.
4.4. Произведение селекции
Выбор решений для следующей популяции (оператор селекции) предназначен для улучшения
качества решений в новой популяции, а именно сохранение разнообразия популяции, сохранение
лучших решений и удаление из нее недопустимых решений. Обычно выбираются элементы с
наибольшей приспособленностью (наилучшем значением функции качества).
Селекция в любом случае должна быть устроена так, что как минимум одна лучшая особь за-
щищена от истребления в результате селекции. В алгоритме число защищаемых верхних позиций
от отбора является параметром алгоритма preserved_high_positions. Так же полезно защищать
некоторое количество нижних позиций, так как в результате скрещивания с ними возможны
выходы из локальных экстремумов. Параметр preserved_low_positions.
Возможны различные варианты операции селекции, основанные на разных схемах отбора:
• Случайная схема. В данной схеме отбора особи, попадающие в новую популяцию выби-
раются случайным образом. Верхняя часть (по значению функции качества) не участвует
в отборе.
• Схема пропорционального отбора. В данной схеме отбора вычисляется значение целе-
вой функции для каждого решения fm(xi) и определяется среднее значение целевой функ-
ции в популяции Fave. Затем для каждого решения i вычисляется отношение fm(xi)/F_ave. 
Например, если отношение равно 2.36, то данное решение имеет двойной шанс на выживание в
популяции. Так же в зависимости от даннго коэффициента можно вычислять вероятность
скрещивания. Тогда решение будет иметь вероятность равную 0.36 для третьего скрещи-
вания. Если же приспособленность равна 0.54, то решение примет участие в единственном
скрещивании с вероятностью 0.54

Турнирный отбор. Схему турнирного отбора можно описать следующим образом: из по-
пуляции, содержащей N решений, выбирается случайным образом 2 решения и между вы-
бранными решениями проводится турнир. Победившее решение остаётся в популяции.
• Отбор усечением. Число решений для сохранения в популяции выбирается в соответствии
с порогом T ∈ [0; 1]. Порог определяет, какая доля особей, начиная с самой первой (самой
приспособленной) будет принимать участие в отборе.
4.5. Произведение скрещиваний
Оператор скрещивания используется для передачи родительских признаков потомкам. Пары
для скрещивания выбираются либо случайно, либо на основе одной из схем селекции, описанных
выше.
Доля особей участвующих в скрещивании задаётся параметром crossing_volume.
Возможны следующие варианты оператора скрещивания (рис. 2).
• Одноточечное скрещивание. Выбирается одна точка, и относительно неё решения об-
мениваются своими частями.
• Двухточечное скрещивание. Аналогично предыдущему, но точек скрещивания выбира-
ется две.
• Универсальное скрещивание. С некоторой вероятностью выбирается бит либо одного,
либо другого родителя.
• Однородное скрещивание. Каждый ген в потомстве создается посредством копирова-
ния соответствующего гена от одного или другого родителя, выбранного согласно случайно
сгенерированной маске скрещивания. Если в маске скрещивания стоит 1, то ген копиру-
ется от первого родителя, если в маске стоит 0, то ген копируется от второго родителя.
Процесс повторяется с новыми родителями для создания второго потомства. Новая маска
скрещивания случайно генерируется для каждой пары родителей.
После операции скрещивания новые решения остаются в популяции вместе с родителями, по
которым были порождены скрещенные особи.
4.6. Организация мутаций
Оператор мутации используется для внесения в решение некоторых новых признаков. Некото-
рые варианты реализации операции мутации представлены на рисунке 3. Все варианты изменяют
биты битовой строки с некоторой вероятностью.
Доля мутирующих особей в популяции определяется параметром алгоритма variability.
• Изменение случайно выбранного бита.
• Перестановка случайно выбранных битов местами.
• Реверс битовой строки, начиная со случайно выбранного бита.
