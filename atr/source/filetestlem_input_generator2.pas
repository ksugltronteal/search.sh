program filetestlem_input_generator2;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils
  { you can add units after this };
var filename:string;
begin
     writeln('#!/bin/bash');
     write('./FileTestLem3 Russian ');
     while not(eof) do
     begin
       readln(filename);
       write(filename+' ');
     end;
end.

