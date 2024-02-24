with Ada.Text_IO;

procedure Main is

   can_stop : boolean := false;
   pragma Atomic(can_stop);

   task type break_thread;
   task type main_thread(id: Integer);

   task body break_thread is
   begin
      delay 5.0;
      can_stop := true;
   end break_thread;

   task body main_thread is
      sum : Long_Long_Integer := 0;
      count : Long_Long_Integer := 0;
   begin
      loop
         sum := sum + count;
         count := count + 1;
         exit when can_stop;
      end loop;

      Ada.Text_IO.Put_Line("Thread: " & id'Img & " Sum: " & sum'Img & " Count: " & count'Img);
   end main_thread;

   b1 : break_thread;
   t1 : main_thread(1);
   t2 : main_thread(2);
   t3 : main_thread(3);
   t4 : main_thread(4);
   t5 : main_thread(5);

begin
   null;
end Main;
