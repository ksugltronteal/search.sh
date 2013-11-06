program querygenerator2;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes { you can add units after this };

{$R *.res}
var
  s: string;
  m: integer;
  fl: boolean;
begin
  m := 0;
  fl := True;
  if EOF() then
  begin
    writeln('1');
    writeln('Search query is empty or can not be recognized. Use other search engine.');
  end
  else
  begin
    while not (EOF) do
    begin
      readln(s);//writeln(m);
      if fl then
        if (copy(s, 1, 6) = '==GL==') then
        begin
          writeln('1');
          writeln('General lexic found: ' + copy(s, 8, length(s) - 7));
          halt(0);
        end
        else
        begin
          writeln('0');
        end;
      fl := False;
      case m of
        0: if s <> '=Delimeter=' then
          begin
            m := 1;
            Write('(' + s);
          end
          else
          begin
            //writeln();
            //writeln('=ERROR!=');
            //writeln('querygenerator::31 exception "Delimeter on status 0"');
          end;
        1: if s <> '=DELIMETER=' then
          begin
            Write(' OR ' + s);
          end
          else
          begin
            m := 2;
            Write(')');
          end;
        2: if s <> '=DELIMETER=' then
          begin
            m := 1;
            Write('AND(' + s);
          end
          else
          begin
            writeln();
            writeln('=ERROR!=');
            writeln('querygenerator::53 exception "Delimeter on status 2"');
          end;
      end;
    end;
    writeln;
  end;
end.

