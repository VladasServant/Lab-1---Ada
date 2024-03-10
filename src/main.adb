with Ada.Text_IO;
with Ada.Unchecked_Deallocation;

procedure Main is

   can_stop : boolean := false;
   pragma Atomic(can_stop);

   task type break_thread;
   task type main_thread(id: Integer; step: Long_Long_Integer);

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
         sum := sum + count * step;
         count := count + 1;
         exit when can_stop;
      end loop;

      Ada.Text_IO.Put_Line("Thread: " & id'Img & " Sum: " & sum'Img & " Count: " & count'Img);
   end main_thread;

   b1 : break_thread;
   Thread : array(1..10) of access main_thread;
begin
   for i in 1..Thread'Length loop 
      Thread(i) := new main_thread(i, 1);
   end loop;

   for i in 1..Thread'Length loop 
      if Thread(i).all'access /= null then
         pragma Unchecked_Deallocation(Thread(i).all, Thread(i)'Access);
      end if;
   end loop;
end Main;
