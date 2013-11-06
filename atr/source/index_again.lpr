program index_again;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this };

type

  { TMyApplication }

  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TMyApplication }
function  validate_again(var f:textfile;s:string):integer;
var vbp:boolean;
    p,pp:string;
    a,b:integer;
begin
  b:=-1;
   vbp:=true;
//   writeln('s='+s+'|');
   while (not(eof(f)) and vbp) do
     begin
        readln(f,p);
        //writeln('p='+p);
        a:=pos('-',p);
        //writeln('pos(-)='+inttostr(a));
//        writeln(copy(p,1,a-1));
        pp:=copy(p,a+1,length(p)-a);
//        writeln('pp='+pp+'|');
        vbp:=not(s=pp);
        if not(vbp)
          then
            begin
//                writeln('FOUND!');
              try
                b:=strtoint(copy(p,1,a-1));
              except
                b:=-1;
                writeln('Strtoint problem in validate_again ');
                writeln(copy(p,1,a-1));
              end
            end
     end;
   if eof(f)and vbp
     then
       begin
         writeln('General index_again problem: bad input');
       end;
   validate_again:=b;
end;
{function  minimum(a,b:integer):integer ;
begin
  if a<b
    then
      begin
        minimum:=a
      end
    else
      begin
        minimum:=b
      end
end;
function  maximum(a,b:integer):integer ;
begin
  if a>b
    then
      begin
        maximum:=a
      end
    else
      begin
        maximum:=b
      end
end; }

procedure  validate(var f:textfile;ss:string;var out_f:textfile);
var a,k,i:integer;
    r,s:string;
    b:array[0..511]of integer;
    min,max:integer;
begin
  k:=0;
  s:=ss;
  while length(S)>3 do
    begin
      inc(k);
      a:=pos(' ',s);
      r:=copy(s,1,a-1);
//      writeln('Validating '+r);
      s:=copy(s,a+1,length(s)-a);
      b[k]:=validate_again(f,r);
    end;
  min:=b[1];
  max:=b[1];
  for i:=2 to k do
    begin
       if b[i]<min
        then
          begin
            min:=b[i];
          end;
       if b[i]>max
         then
           begin
             max:=b[i];
           end
    end;
  writeln(out_f,inttostr(min)+':'+ss);
end;
procedure  main(params:array of string);
var
    inp_f,out_f,dic_f:textfile;
    s:string;
    //k:integer;
    //vbp:boolean;
begin
  assignfile(dic_f,params[0]);
  assignfile(inp_f,params[1]);
  assignfile(out_f,params[2]);
//  writeln(params[0]);
  reset(inp_f);
  reset(dic_f);
  rewrite(out_f);
  while not(eof(inp_f)) do
  begin
    readln(inp_f,s);
    validate(dic_f,s,out_f);
  end;

  closefile(dic_f);
  closefile(inp_f);
  closefile(out_f);
end;


procedure TMyApplication.DoRun;
var
  i:integer;
  pampam:array[1..4]of string;
begin
  if HasOption('h','help') then begin
    WriteHelp;
    Halt;
  end;
  if ParamCount<>3 then
          begin
               writehelp;
               halt;
          end;
  for i:=1 to 3 do
           begin
                pampam[i]:=params[i];
           end;
  main(pampam);
  Terminate;
end;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TMyApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TMyApplication.WriteHelp;
begin
  writeln('Usage: ',ExeName,' [-h] *.end2-file *.008-file output-file');

end;

var
  Application: TMyApplication;
begin
  Application:=TMyApplication.Create(nil);
  Application.Title:='My Application';
  Application.Run;
  Application.Free;
end.

