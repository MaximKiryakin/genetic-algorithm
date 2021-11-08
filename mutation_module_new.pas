  Unit mutation_module_new;
  Interface
    type
      individual_t = record
        ent: cardinal;
        val: real;
        f_val: real;
    end;
    
    type
      arr_t = array of individual_t;


  var
    ent_array: array of cardinal;
	val_array: array of single;
	f_val_array: array of single;
    a: array[0..100] of byte;
    out:text;
    population: array of individual_t;
    save: array of individual_t;
    save_good: array of individual_t;
    number_of_individuals, i,stop_count,second_child,mutation_indiv,j,num,index :integer;
    operating_mode,mutation_number,crossing_number,cross_1,cross_2,count_stog :integer;
    T,ans_pr,quality_epsilon,pr,f_ave,Max_function_value :real;
    s,individual_1,individual_2 :individual_t;
    high_level_flag,stop_count_flag,stogn_flag:boolean;
    population_volume,max_iters,max_valueless_iters,preserved_high_positions :integer;
    preserved_low_positions,crossing_volume,variability,truncation_selection_t:integer;
    printing_to_console,mutation_type,crossbreeding,selection_type,err:integer;
    Max_function_value_int,Number_of_signs,del:integer;
	counter_1, buffer1_1, buffer2_1 :TDateTime;
		counter_2, buffer1_2, buffer2_2 :TDateTime;
  function f(x: real): real;
  procedure mutation_random_bit (x:cardinal;var population:arr_t);
  procedure mutation_2_bits (x:cardinal;var population:arr_t);
  procedure reverse_mutation(x:cardinal;var population:arr_t);
  procedure get_child_universal (x,y:cardinal;var population:arr_t);
  procedure get_child_homogeneous (x,y:cardinal;var population:arr_t);
  procedure get_child_two_points (x,y:cardinal;var population:arr_t);
  procedure get_child_one_point (x,y:cardinal;var population:arr_t);

  const
    M = 65535;
    eps = 0.001;
    // Max_function_value = 0.4115;

  implementation

  function f(x: real): real;
    begin
      f := x * sin(x + 5) * cos(x - 6) * sin(x + 7) * cos(x - 8) * sin(x / 3);
    end;

  //мутация изменением случайного бита. процедура получает номер особи в массиве
  procedure mutation_random_bit (x:cardinal;var population:arr_t);
  var
    change,s:cardinal;
  begin
    change:=random(15{31});
    s:=1<<change;
    if ((population[x].ent and s) = s) then
      population[x].ent:= (population[x].ent-s)
    else
      population[x].ent:= (population[x].ent+s);
      population[x].val:=population[x].ent * 4 / M;
      population[x].f_val:=f(population[x].val);
  end;

  //Перестановка случайно выбранных битов местами.Процедура получает номер особи в массиве
  procedure mutation_2_bits (x:cardinal;var population:arr_t);
  var
    bit_number_1,bit_number_2,s,s_1:cardinal;
    ans:individual_t;
  begin
    bit_number_1:=random(13{30})+2;
    bit_number_2:=random(bit_number_1);
    s:=1<<bit_number_1;
    s_1:=1<<bit_number_2;
    if ((population[x].ent and s) = s) and ((population[x].ent and s_1) = 0) then
      begin
        population[x].ent:= (population[x].ent-s);
        population[x].ent:= (population[x].ent+s_1);
      end
    else
   if ((population[x].ent and s) = 0) and ((population[x].ent and s_1) = s_1) then
   begin
     population[x].ent:= (population[x].ent+s);
     population[x].ent:= (population[x].ent-s_1);
   end;
   population[x].val:=population[x].ent * 4 / M;
   population[x].f_val:=f(population[x].val);
  end;

  //Реверс битовой строки, начиная со случайно выбранного бита. Принимает номер элемента в массиве
  procedure reverse_mutation(x:cardinal;var population:arr_t);
  var
  chek,s,i:cardinal;
  begin
    chek:=random(15{31});
    for i:=0 to (chek div 2) do
    begin
      if ((population[x].ent and (1<<(chek-i))) = (1<<(chek-i))) and (population[x].ent and (1<<i) = 0) then
       begin
         population[x].ent:= (population[x].ent-(1<<(chek-i)));
         population[x].ent:= (population[x].ent+(1<<i));
       end
       else
         if ((population[x].ent and (1<<(chek-i))) = 0) and (population[x].ent and (1<<i) = (1<<i)) then
         begin
           population[x].ent:= (population[x].ent+(1<<(chek-i)));
           population[x].ent:= (population[x].ent-(1<<i));
         end
    end;
    population[x].val:=population[x].ent * 4 / M;
    population[x].f_val:=f(population[x].val);
  end;


  //скрещивание по 1 точке
  procedure get_child_one_point (x,y:cardinal;var population:arr_t);
  var
    bit_number,a,b:cardinal;
    ans:individual_t;
  begin
    bit_number:=random(15);
    a:=((1<<bit_number)-1);//перваяя часть
    b:=not a;
    ans.ent:=(x and a) + (y and b);
    ans.val:=ans.ent * 4 / M;
    ans.f_val:=f(ans.val);
    if number_of_individuals < population_volume then
    begin
      number_of_individuals:=number_of_individuals+1;
      setlength(population, number_of_individuals);
      population[number_of_individuals-1]:= ans;
    end;
  end;

  //скрещивание по 2м точкам
  procedure get_child_two_points (x,y:cardinal;var population:arr_t);
  var
    bit_number_1,a,b,a_0,bit_number_2:cardinal;
    ans:individual_t;
  begin
    bit_number_1:=random(13)+2;
    bit_number_2:=random(bit_number_1);
    a:=((1<<bit_number_1)-1);
    a_0:=((1<<bit_number_2)-1);
    a:=a-a_0;
    b:=not a;
    ans.ent:=(x and a) + (y and b);
    ans.val:=ans.ent * 4 / M;
    ans.f_val:=f(ans.val);
    if number_of_individuals < population_volume then
    begin
      number_of_individuals:=number_of_individuals+1;
      setlength(population, number_of_individuals);
      population[number_of_individuals-1]:= ans;
    end;
  end;

  //однородное скрещивание
  procedure get_child_homogeneous (x,y:cardinal;var population:arr_t);
  var
    mask:cardinal;
    i,chek:integer;
    ans:individual_t;
  begin
    mask:=0;
    //создаем маску
    for i:=0 to 30 do
    begin
      chek:=random(2);
      if chek mod 2 = 1 then
        mask:=mask+(1<<i);
    end;
    //делаем потомка
    ans.ent:=(x and mask) + (y and not mask);
    ans.val:=ans.ent * 4 / M;
    ans.f_val:=f(ans.val);
    if number_of_individuals < population_volume then
    begin
      number_of_individuals:=number_of_individuals+1;
      setlength(population, number_of_individuals);
      population[number_of_individuals-1]:= ans;
    end;
  end;

  //универсальное скрещивание
  procedure get_child_universal (x,y:cardinal;var population:arr_t);
  var
    mask:cardinal;
    chek:integer;
    ans:individual_t;
  begin
    mask:=0;
    //создаем маску
    chek:=random(31);
    mask:=mask+(1<<chek);
    //делаем потомка
    ans.ent:=(x and mask) + (y and not mask);
    ans.val:=ans.ent * 4 / M;
    ans.f_val:=f(ans.val);
    if number_of_individuals < population_volume then
    begin
      number_of_individuals:=number_of_individuals+1;
      setlength(population, number_of_individuals);
      population[number_of_individuals-1]:= ans;
    end;
  end;
begin

end.