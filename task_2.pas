
Uses
  mutation_module_new, sysutils;
{
procedure change_to_binar(n:cardinal;var a: array of byte;var x:integer);
var
i,c:integer;
begin
  c:= 0;
  repeat
    c:= c + 1;
    a[c]:= n mod 2;
    n:= n div 2;
  until n = 0;
   x:=c;
end;
}

procedure change_to_binar(n:cardinal;var a: array of byte;var x:integer);
var
i,c:integer;
begin
  c:= -1;
  repeat
        c:= c + 1;
    if (n and (1 << c))=(1 << c) then
    a[c]:= 1
    else
      a[c]:=0;

  until c = 16;
   x:=c;
end;



//облегчает считывание из файла
function get_number (s:string;i:integer):integer;

begin
  Delete(s, i, Length(s));
  Delete(s, 1, pos('=', s) + 1);
  Val(s, get_number, err);
end;
//процедура, которая считывает значения переменных из файла
procedure get_data;
var
  str: string;
  i, err, com: integer;
  f:text;
begin
  assign(f,'parametors_for_task_2.txt');
  reset(f);
  while not eof(f) do
  begin
    readln(f, str);
    i := pos('=', str) + 2;
    while (str[i] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) and (i < Length(str)) do
      i := i + 1;
    com := pos('#', str);
    if pos('population_volume', str) <> 0 then
      if (com >= i) or (com = 0) then
        begin
          population_volume:= get_number(str,i);
        end;
    if pos('preserved_high_positions', str) <> 0 then
      if (com >= i) or (com = 0) then
        begin
          preserved_high_positions:= get_number(str,i);
        end;
    if pos('preserved_low_positions', str) <> 0 then
      if (com >= i) or (com = 0) then
        begin
          preserved_low_positions:= get_number(str,i);
        end;
    if pos('crossing_volume', str) <> 0 then
      if (com >= i) or (com = 0) then
        begin
          crossing_volume:= get_number(str,i);
        end;
    if pos('variability', str) <> 0 then
      if (com >= i) or (com = 0) then
        begin
          variability:= get_number(str,i);
        end;
    if pos('truncation_selection_t', str) <> 0 then
      if (com >= i) or (com = 0) then
        begin
          truncation_selection_t:= get_number(str,i);
        end;
    if pos('operating_mode', str) <> 0 then
      if (com >= i) or (com = 0) then
        begin
          operating_mode:= get_number(str,i);
        end;
    if pos('printing_to_console', str) <> 0 then
      if (com >= i) or (com = 0) then
        begin
          printing_to_console:= get_number(str,i);
        end;
    if pos('operating_mode', str) <> 0 then
      if (com >= i) or (com = 0) then
        begin
          operating_mode:= get_number(str,i);
        end;
    if pos('mutation_type', str) <> 0 then
      if (com >= i) or (com = 0) then
        begin
          mutation_type:= get_number(str,i);
        end;
    if pos('crossbreeding', str) <> 0 then
      if (com >= i) or (com = 0) then
        begin
          crossbreeding:= get_number(str,i);
        end;
    if pos('selection_type', str) <> 0 then
      if (com >= i) or (com = 0) then
        begin
          selection_type:= get_number(str,i);
        end;
    if pos('Max_function_value_int', str) <> 0 then
      if (com >= i) or (com = 0) then
        begin
          Max_function_value_int:= get_number(str,i);
        end;
    if pos('Number_of_signs', str) <> 0 then
      if (com >= i) or (com = 0) then
        begin
          Number_of_signs:= get_number(str,i);
        end;
  end;
  close(f);
end;


//сортировка массива методом вставок
procedure Sorting_insert(var a: Array of individual_t; array_length: integer);
var
  i, j: integer;
  x:individual_t{ real};
begin
  for i := 1 to  array_length - 1 do
  begin
    x := a[i]{.f_val};
    j := i - 1;
    while (j >= 0) and (x.f_val - a[j].f_val > 0) do
    begin
      a[j + 1]{.f_val} := a[j]{.f_val};
      j := j - 1;
    end;
    a[j + 1]{.f_val} := x;
  end;
end;

//тело программы
begin
counter_1:=0;
buffer1_1 := Now;
  RandSeed:=100500;
  count_stog := 0;
  if operating_mode = 0 then
  begin
    assign(out, 'log.txt');
    rewrite(out);
  end;

  //получаем значения из файла
  err:=0;
  del:=1;
  get_data;
  //переводим верхнюю границу функции в вещественное число
  if Number_of_signs <> 0 then
    for i:=1 to Number_of_signs do
      del := del*10;
  Max_function_value := Max_function_value_int/del;
  if err <> 0 then
    begin
    writeln('Wrong input. Using basic settings');
    population_volume := 30;
    preserved_high_positions := 4;
    preserved_low_positions := 4;                       // число штук
    crossing_volume := 100;                             // в процентах
    variability := 90;                                  // в процентах
    truncation_selection_t := 80;                       // в процентах (это доля Т для отбора усечением)
    operating_mode := 0;                                // Режим программы. 0 - тестовый 1 - основной
    printing_to_console := 0;                           // 1-печать, 0 не печатать (в тестовом режиме)
    mutation_type := 2;                                 // 1 - рандом. бит; 2 - двубитовая; 3 - реверс
    crossbreeding := 1;                                 // 1- одноточное; 2 - двуточеное; 3 - универс.; 4 - однородное
    selection_type := 1;
    Max_function_value := 0.4115;
    end;
  //переводим процент отбора в десятичное число
  T := truncation_selection_t/100;
  stop_count := 0;
  count_stog := 0;
  high_level_flag := false;
  stop_count_flag := false;
  stogn_flag := false;
  //Randomize;

  //первая популяция
  number_of_individuals := population_volume;
  setlength(population, number_of_individuals);
  for i := 0 to number_of_individuals - 1 do
  begin
    population[i].ent := random(M);
    population[i].val := population[i].ent * 4 / M;
    population[i].f_val := f(population[i].val);
  end;
  if (printing_to_console = 1) and (operating_mode = 0) then
    begin
      writeln('start population');
      for i := 0 to number_of_individuals - 1 do
      begin
        change_to_binar(population[i].ent,a,index);
        write(i+1,') binar: ');
        for j:={index}15 downto 0 do
          begin
            write(a[j]);
          end;
        writeln( '  ent: ', population[i].ent,', val: ',population[i].val:2:5,', f_val: ',population[i].f_val:2:5);
      end;
    end;
  if operating_mode = 0 then
    begin
      writeln(out, '--------------First generation--------------');
      for i := 0 to number_of_individuals - 1 do
        begin
          change_to_binar(population[i].ent,a,index);
          write(out,i+1,') binar: ');
          for j:={index}15 downto 0 do
            begin
              write(out,a[j]);
            end;
          writeln(out,' ent: ',population[i].ent,', val: ',population[i].val:2:5,', f_val: ',population[i].f_val:2:5);
        end;
    end;


  repeat
    pr:=population[0].f_val;
    //переопределение значений и сортировка массива по значениям функции
	setlength(ent_array, number_of_individuals);
	setlength(val_array, number_of_individuals);
	setlength(f_val_array, number_of_individuals);
	for i:=0 to number_of_individuals-1 do
	begin
	ent_array[i] := population[i].ent;
	val_array[i] := population[i].val;
	f_val_array[i] := population[i].f_val;
	end;
    Sorting_insert(population, number_of_individuals);
    for i:=0 to number_of_individuals-1 do
	begin
	ent_array[i] := population[i].ent;
	val_array[i] := population[i].val;
	f_val_array[i] := population[i].f_val;
	end;
	buffer2_1 := Now;
	counter_1:=counter_1+buffer2_1 -buffer1_1;
    //вывод информации о текущем поколении
    if (printing_to_console = 1) and (operating_mode = 0) then
      begin
        writeln('--------------Generation number ',stop_count,' --------------');
        for i := 0 to number_of_individuals - 1 do
        begin
          change_to_binar(population[i].ent,a,index);
          write(i+1,') binar: ');
          for j:={index}15 downto 0 do
            begin
            write(a[j]);
            end;
          writeln('  ent: ', population[i].ent,', val: ',population[i].val:2:5,'  funtion value: ', population[i].f_val:2:5);
        end;
      end;
    if operating_mode = 0 then
      begin
        writeln(out, '--------------Generation number ',stop_count,' --------------');
        for i := 0 to number_of_individuals - 1 do
        begin
          change_to_binar(population[i].ent,a,index);
          write(out,i+1,') binar: ');
          for j:={index}15 downto 0 do
            write(out,a[j]);
          writeln(out,' ent: ',population[i].ent,', val: ',population[i].val:2:5,', f_val: ',population[i].f_val:2:5);
        end;
      end;

    //назависимо печатаем самую лучшую особь в консоль
    writeln('Generation number ',stop_count,'; Best value: ',population[0].f_val:2:5);
    //проверяем критерий останова по лучшему значению

buffer1_1 := Now;

    if population[0].f_val - Max_function_value >=0 then
      high_level_flag := true;
    if stop_count >= 300 then
      stop_count_flag := true;
    if count_stog >= 50 then
      stogn_flag := true;
    if pr-population[0].f_val - eps <0 then
      count_stog:=count_stog+1
    else
      count_stog:=0;
    stop_count := stop_count + 1;

    if (high_level_flag = false) and (stop_count_flag = false) and (stogn_flag = false) then
    begin
      //сохраняем нужную часть самых плохих особей
      setlength(save, preserved_low_positions);
      for j:=0 to preserved_low_positions-1 do
        save[j] := population[number_of_individuals - 1-j];
      //сохраняем часть самых хороших особей
      setlength(save_good, preserved_high_positions);
      for j:=0 to preserved_high_positions-1 do
        begin
        save_good[j] := population[j];
        end;
      //производим отбор
      if selection_type = 1 then
        begin
        // усечение
        number_of_individuals := trunc(T * number_of_individuals) + preserved_low_positions;
        setlength(population, number_of_individuals);
        for j:=0 to preserved_low_positions-1 do
          population[number_of_individuals - 1-j] := save[j];
        end
        else
        begin
        //пропорциональный отбор
        f_ave:= 0;
        for j:=0 to number_of_individuals-1 do
          f_ave:= f_ave+population[j].f_val;
        f_ave:=f_ave/number_of_individuals;
        for j:=0 to number_of_individuals-1 do
          begin
            if (random(100)*(population[j].f_val/f_ave) < 50) then
              begin
                //заполняем выбывшего пришельцем
                population[j].ent := random(M);
                population[i].val := population[i].ent * 4 / M;
                population[i].f_val := f(population[i].val);
              end;
          end;

        end;

    //проводим скрещивание
    crossing_number := trunc((crossing_volume/100)*(number_of_individuals - 1));
    if crossbreeding = 1 then
      begin
        for i:=0 to mutation_number do
        begin
          cross_1 := random(number_of_individuals - 1);
          cross_2 := random(number_of_individuals - 1);
		  
          get_child_one_point(population[cross_1].ent, population[cross_2].ent,population);
		 
		
        end;
      end;
    if crossbreeding = 2 then
      begin
        for i:=0 to mutation_number do
        begin
          cross_1 := random(number_of_individuals - 1);
          cross_2 := random(number_of_individuals - 1);
          get_child_two_points(population[cross_1].ent, population[cross_2].ent,population);
        end;
      end;
    if crossbreeding = 3 then
      begin
        for i:=0 to mutation_number do
        begin
          cross_1 := random(number_of_individuals - 1);
          cross_2 := random(number_of_individuals - 1);
          get_child_homogeneous(population[cross_1].ent, population[cross_2].ent,population);
        end;
      end;
    if crossbreeding = 4 then
      begin
        for i:=0 to mutation_number do
        begin
          cross_1 := random(number_of_individuals - 1);
          cross_2 := random(number_of_individuals - 1);
          get_child_universal(population[cross_1].ent, population[cross_2].ent,population);
        end;
      end;

    //проводим мутацию
    mutation_number := trunc(variability/100*(number_of_individuals - 1));
    if mutation_type = 1 then
      begin
        for i:=0 to mutation_number do
        begin
          mutation_indiv := random(number_of_individuals - 1);
          mutation_random_bit(mutation_indiv,population);
		 
        end;
      end;
    if mutation_type = 2 then
      begin
        for i:=0 to mutation_number do
        begin
          mutation_indiv := random(number_of_individuals - 1);
          mutation_2_bits(mutation_indiv, population);
        end;
      end;
    if mutation_type = 3 then
      begin
        for i:=0 to mutation_number do
        begin
          mutation_indiv := random(number_of_individuals - 1);
          reverse_mutation(mutation_indiv, population);
        end;
      end;
    end;
  //восстанавливаем лучших
  {
  for j:=0 to preserved_high_positions-1 do
    population[j] := save_good[j];
 }
  until (high_level_flag = true) or (stop_count_flag = true) or (stogn_flag = true);
  if operating_mode = 0 then
    close(out);
	 
	 
	 buffer2_1 := Now;
	 counter_1:=counter_1 + buffer2_1-buffer1_1;
	
  //вывод ответа в консоль
  writeln('--------------------------------------------------');
  writeln('Resolt: ', population[0].f_val:2:10,' Number of iterations: ',stop_count);
  writeln('--------------------------------------------------');
  writeln('high_level_flag:= ',high_level_flag);
  writeln('stop_count_flag:= ',stop_count_flag);
  writeln('stagnation_flag:= ',stogn_flag);

  
writeln('Выыожу время счета');
writeln(counter_1);

  readln();
  readln();
end.
