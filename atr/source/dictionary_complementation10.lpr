program dictionary_complementation10;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes,
  SysUtils,
  CustApp { you can add units after this };

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

const
  biginteger = 300001;
type
  s30 = string

    [80];
  ar15 = array[0..biginteger - 1] of s30;
var
  kio: ar15;
var
  delimeter: boolean;

  function cash(s: s30): integer;
  var
    i, l, a: integer;
  begin
    l := length(s);
    a := 0;
    for i := 1 to l do
    begin
      a := (a + Ord(s[i]) * i) mod biginteger;
    end;
    cash := a mod biginteger;
  end;

  procedure clear_table(var a: ar15);
  var
    i: integer;
  begin
    for i := 0 to biginteger - 1 do
    begin
      a[i] := '';
    end;
  end;

  procedure add_table(var a: ar15; word: s30);
  var
    k: integer;
  begin
    k := cash(word);
    while a[k] <> '' do
      k := (k + 1) mod biginteger;
    a[k] := word;
  end;

  function find_table(var a: ar15; word: s30): boolean;
  var
    k: integer;
  begin
    k := cash(word);
    while (a[k] <> '') and (a[k] <> word) do
    begin
      k := (k + 1) mod biginteger;
    end;
    find_table := (a[k] = word);
  end;


  procedure main(paramcount: integer; dictionary: s30; params: array of s30);
  var
    dic_f, out_f, inp_f: textfile;
    s: s30;
    i: integer;
  begin
    {
    writeln(dictionary);
    for i := 0 to paramcount - 1 do
    begin
      writeln(params[i]);
    end;
    }
    clear_table(kio);
    assignfile(dic_f, dictionary);
    reset(dic_f);
    while not (EOF(dic_f)) do
    begin
      readln(dic_f, s);
      add_table(kio, s);
    end;

    closefile(dic_f);

    for i := 0 to paramcount - 1 do
    begin
      assignfile(inp_f, params[i]);
      writeln('Processing ' + params[i]);
      assignfile(out_f, params[i] + '.olm');

      reset(inp_f);
      rewrite(out_f);
      while not (EOF(inp_f)) do
      begin
        readln(inp_f, s);

        if not (find_table(kio, s)) then
        begin
          //inc(k);
          writeln(out_f, s);
        end
        else
        begin
          if delimeter then
          begin
            writeln(out_f, '=Delimeter=');
          end;
        end;

      end;



      closefile(inp_f);
      closefile(out_f);
    end;
    //writeln('Terms found: ', k);
    //writeln('General lexic found: ', a);
    //writeln('Not found and in output:', o);
  end;


  procedure TMyApplication.DoRun;
  var
    i: integer;
    pampam: array[0..10000] of s30;
    dictionary: s30;
  begin
    // parse parameters
    if HasOption('h', 'help') then
    begin
      WriteHelp;
      Halt;
    end;
    if HasOption('d') then
    begin
      delimeter := True;
      if ParamCount < 3 then
      begin
        writehelp;
        halt;
      end;
      dictionary := params[2];
      for i := 0 to ParamCount - 3 do
      begin
        pampam[i] := params[i + 3];
      end;
      main(paramcount - 2, dictionary, pampam);
    end
    else
    begin
      delimeter := False;
      if ParamCount < 2 then
      begin
        writehelp;
        halt;
      end;
      dictionary := params[1];
      for i := 0 to paramcount - 2 do
      begin
        pampam[i] := params[i + 2];
      end;
      main(paramcount - 1, dictionary, pampam);
    end;

    //sleep(1000);
    Terminate;
  end;

  constructor TMyApplication.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;
  end;

  destructor TMyApplication.Destroy;
  begin
    inherited Destroy;
  end;

  procedure TMyApplication.WriteHelp;
  begin
    { add your help code here }
    writeln('Usage: ', ExeName, ' [-hd] dictionary_file input_files');

  end;

var
  Application: TMyApplication;
begin
  Application := TMyApplication.Create(nil);
  Application.Title := 'My Application';
  Application.Run;
  Application.Free;
end.

