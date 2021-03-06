unit DbOperate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ADODB, StdCtrls, activeX, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Phys.SQLite, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper, FireDAC.Phys.MySQL, FireDAC.Phys.Intf, Log, uConst;

const
  // 数据库SUS400-500,FAIL对应负数.
  SUS_CONNECT = 400;                     //连接数据库成功
  FAIL_CONNECT = -400;              //连接数据库失败
  SUS_QUERY = 401;                   //查询成功
  FAil_QUERY = -401;                 //查询失败
  SUS_DELETE = 402;                  //删除数据库表单成功
  FAil_DELETE = -402;                //删除数据库表单失败
  SUS_CLEAR = 403;                   //清除数据库表单成功
  FAil_CLEAR = -403;                 //清除数据库表单失败
  SUS_INSERT = 404;                  //插入数据库表单成功
  FAil_INSERT = -404;                //插入数据库表单失败
  SUS_UPDATE = 405;                  //插入数据库表单成功
  FAil_UPDATE = -405;                //插入数据库表单失败
  SUS_CREATE = 406;                  //插入数据库表单成功
  FAil_CREATE = -406;                //插入数据库表单失败
  SUS_FILE = 407;                    //数据库文件存在
  FAil_NOTFILE = -407;               //数据库文件不存在
  SUS_SQL = 408;                     // SQL执行成功
  FAil_SQL = -409;                   // SQL执行失败
  DBCONNECT_INFO = 410;              //数据库连接信息
  DBTABLE_INFO = 411;              //数据库中的表名列表
  DBFIELD_INFO = 412;              //数据库中的表中的字段名列表
  ERROR_SQLSENTENCE = -413;         // SQL语句错误
  SUS_EDPASSWORD = 414;              //修改数据库密码成功
  FAIL_EDPASSWORD = -414;              //修改数据库密码失败
  SUS_SETPASSWORD = 415;              //设置数据库密码成功
  FAIL_SETPASSWORD = -415;              //设置数据库密码失败
  SUS_REPASSWORD = 416;              //移除数据库密码成功
  FAIL_REPASSWORD = -416;              //移除数据库密码失败
  SUS_COMMIT = 417;              //提交成功
  FAIL_COMMIT = -417;              //提交失败

type
  TDbObj = class
  private
    fdCon: TFDConnection;
    fdqry: TFDQuery;
    FCS: TRTLCriticalSection;   //临界区
    FError: TError;
    FDbFile, FDbType: string;
    FSqlLogTag: Boolean;
    FDbOpenCount: Integer;
    FShareConnectTab: Integer;  //共享连接标准      线程1, 线程2
    function OpenCount(): Integer;      //数据库连接打开次数
    function CloseCount(): Integer;     //数据库关闭打开次数
  public
    constructor Create();
    destructor Destroy(); override;
    procedure OpenDb(const dbFilePath, dbType: string; const password: string = '');                           //打开数据库

    procedure CreateTable(const aSql, tableName, password: string);                       // 创建表
    procedure lock();                          //枷锁
    procedure unlock();                        //解锁
    procedure BeginTans;                      //开始事物
    procedure Commit;                        //提交
    procedure Rollback;                      //回滚
    procedure Sweep();                       //清理
    procedure fdConError(ASender, AInitiator: TObject; var AException: Exception);
   //FireDac
   //sqlite
    procedure ExcuteSql(const aSql: string);    //执行sql
    procedure CloseConnect();
    procedure OpenConnect();
    function QuerySql(const aSql: string): TFDMemTable;
    function SetPassword(const password: string): Boolean;                     //设置密码
    function ChangePassword(const oldPassword, newPassword: string): Boolean; //改变密码    newPassword 为空表示取消密码
    //other
    function GetLastError(): TError;
    function GetDbInfo(const dbInfoType: Integer; const tableName: string): TStringList;  //获取数据库信息
    property sqlLogTag: Boolean read FSqlLogTag write FSqlLogTag;
    property ShareConnectTab: Integer read FShareConnectTab write FShareConnectTab;
  end;

implementation

{ TImageJudge }
constructor TDbObj.Create();
begin
  inherited;
  FDbOpenCount := 0;
  CoInitialize(nil);
  InitializeCriticalSection(FCS);
 // if FShareConnectTab then
  fdCon := TFDConnection.Create(nil);
 // if not Assigned(fdqry) then
  fdqry := TFDQuery.Create(nil);

end;

destructor TDbObj.Destroy;
begin
  fdCon.Close;
  fdqry.Close;
  if Assigned(fdCon) then
    fdCon.Free;
  if Assigned(fdqry) then
    fdqry.Free;
  inherited;
end;

function TDbObj.GetLastError: TError;
begin
  Result := FError;
end;

procedure TDbObj.OpenConnect;
begin
  if OpenCount = 1 then
    fdCon.Connected := True;
end;

function TDbObj.OpenCount: Integer;
begin
  Inc(FDbOpenCount);
  Result := FDbOpenCount;
end;

procedure TDbObj.OpenDb(const dbFilePath, dbType: string; const password: string = '');
var
  sParams: string;
begin
  if not FileExists(dbFilePath) then
  begin
    FError.errorCode := FAil_NOTFILE;
    FError.errorMsg := 'file is not exist';
    Exit;
  end;
  if fdCon.Connected then
  begin
    fdCon.Connected := False;
  end;
  try
    fdcon.Params.Clear;
    sParams := 'DriverID=' + dbType;
    fdcon.Params.Add(sParams);
    sParams := 'Database=' + dbFilePath;
    fdcon.Params.Add(sParams);
    if password <> '' then
    begin
      sParams := 'Password=' + password;
      fdcon.Params.Add(sParams);
    end;
    fdCon.Params.Add('SharedCache=False');
    fdCon.Params.Add('LockingMode=Normal');
    fdCon.TxOptions.Isolation := xiSnapshot;
    fdCon.Connected := false;
    fdCon.FetchOptions.RecordCountMode := cmTotal;
    fdqry.Connection := fdCon;
    fdqry.FetchOptions.Mode := fmAll;
    FDbFile := dbFilePath;
    FDbType := dbType;
  except
    FError.errorCode := FAIL_CONNECT;
    FError.errorMsg := 'db access fail ';
    Exit;
  end;
  FError.errorCode := SUS_CONNECT;
  FError.errorMsg := 'db access success ';
end;

procedure TDbObj.CreateTable(const aSql, tableName, password: string);
var
  tableList: TStringList;
begin
  OpenDb(FDbFile, FDbType, password);
  if FError.errorCode < 0 then
  begin
    Exit;
  end
  else
  begin
    tableList := TStringList.Create;
    tableList := GetDbInfo(DBTABLE_INFO, '');
   // if CheckSameItem(tableName, tableList) then
   //   Exit;
    ExcuteSql(aSql);
    tableList.Free;
  end;
end;

function TDbObj.GetDbInfo(const dbInfoType: Integer; const tableName: string): TStringList;
var
  List: TStrings;
  V: Variant;
  sDbInfo: string;
begin
  Result := TStringList.Create;
  if dbInfoType = DBCONNECT_INFO then
  begin
    fdCon.GetInfoReport(Result);
  end
  else if dbInfoType = DBTABLE_INFO then
  begin
    fdCon.GetTableNames('', '', '', Result);
  end
  else if dbInfoType = DBFIELD_INFO then
  begin
    fdCon.GetFieldNames('', '', tableName, '', Result);
  end;
end;

procedure TDbObj.fdConError(ASender, AInitiator: TObject; var AException: Exception);
var
  sError: string;
begin
  sError := AException.Message;
  Mylog.writeWorkLog(sError, ERROELOG);
end;

procedure TDbObj.BeginTans;
begin
  fdCon.StartTransaction;
end;

procedure TDbObj.Commit;
begin

  try
    fdCon.Commit;   //提交
  except
    FError.errorCode := SUS_COMMIT;
    FError.errorMsg := 'commit fail';
    Mylog.writeWorkLog('commit fail', ERROELOG);
   // fdCon.Rollback; //回滚
  end;
end;

procedure TDbObj.lock;
begin
  EnterCriticalSection(FCS);
end;

procedure TDbObj.unlock;
begin
  LeaveCriticalSection(FCS);
end;

procedure TDbObj.Rollback;
begin
  fdCon.Rollback; //回滚
end;

procedure TDbObj.Sweep;
begin

end;

// sqlite
function TDbObj.SetPassword(const password: string): Boolean;
begin

end;

function TDbObj.ChangePassword(const oldPassword, newPassword: string): Boolean;
begin
  Result := False;
  fdcon.Params.Clear;
  fdcon.Connected := False;
  try
    fdcon.Params.Add('DriverID=' + FDbType);
    fdcon.Params.Add('Database=' + FDbFile);
    fdcon.Params.Add('Password=' + oldPassword);
    fdcon.Params.Add('NewPassword=' + newPassword); //新密码, 密码为空表示取消密码
    fdcon.Connected := True;
  except
    FError.errorCode := SUS_EDPASSWORD;
    FError.errorMsg := 'change dbpassword fail';
  end;
  FError.errorCode := FAIL_EDPASSWORD;
  FError.errorMsg := 'change dbpassword success';
  fdcon.Connected := False;
  Result := True;
end;

procedure TDbObj.CloseConnect;
begin
  if CloseCount = 0 then
    fdCon.Connected := False;
end;

function TDbObj.CloseCount: Integer;
begin
  dec(FDbOpenCount);
  Result := FDbOpenCount;
end;

function TDbObj.QuerySql(const aSql: string): TFDMemTable;
var
  i: Integer;
begin
  Result := TFDMemTable.Create(nil);
  lock;
  try

    fdqry.Close;
   // fdqry.Close;
    fdqry.SQL.Clear;
    try
      //OpenConnect;
      fdqry.Open(aSql);
      Result.Data := fdqry.Data;
     // i := fdqry.SourceView.Rows.Count;
    except
      FError.errorCode := FAil_QUERY;
      FError.errorMsg := 'query fail';
      Exit;
    end;
    FError.errorCode := SUS_QUERY;
    FError.errorMsg := 'query success';
    {for (int i = 0; i < FDMemTable->SourceView->Rows->Count; i++)
     Caption = FDMemTable->SourceView->Rows->ItemsI[i]->GetData(1);
    }
   // CloseConnect;
    unlock;
  finally
   // fdqry.Close;
    //unlock;
  end;
end;

procedure TDbObj.ExcuteSql(const aSql: string);
var
  FDCommand_tmp: TFDCommand;
begin
  lock;
  fdqry.Close;
  fdqry.SQL.Clear;
  fdqry.SQL.Text := aSql;
  try
   // OpenConnect;
    fdqry.ExecSQL;
    FError.errorCode := SUS_SQL;
    FError.errorMsg := 'sql excute  success';
  except
    FError.errorCode := ERROR_SQLSENTENCE;
    FError.errorMsg := 'sql sentence  error';
  end;
  //CloseConnect;
  unlock;

  Exit;
  begin
    FDCommand_tmp := TFDCommand.Create(nil);
    try
      FDCommand_tmp.Connection := fdCon;
      FDCommand_tmp.CommandText.Add(aSql);
      try
        FDCommand_tmp.OpenOrExecute();
        FError.errorCode := SUS_SQL;
        FError.errorMsg := 'sql excute  success';
      except
        FError.errorCode := ERROR_SQLSENTENCE;
        FError.errorMsg := 'sql sentence  error';
      end;
    finally
      FDCommand_tmp.Close;
      freeandnil(FDCommand_tmp);
    end;

  end;
  with TSQLiteStatement.Create(fdcon.CliObj) do
  try
    try
      Prepare(aSql);
    except
      FError.errorCode := ERROR_SQLSENTENCE;
      FError.errorMsg := 'sql sentence  error';
      Exit;
    end;
    try
      Execute;
      while PrepareNextCommand do
        Execute;
    except
      FError.errorCode := FAil_SQL;
      FError.errorMsg := 'sql excute  fail';
      Exit;

    end;
    FError.errorCode := SUS_SQL;
    FError.errorMsg := 'sql excute  success';
  finally
    Free;
   // fdCon.Close;
  end;
end;

end.

