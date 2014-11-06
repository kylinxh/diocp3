unit DZipTools;

interface

uses
  Classes, Zlib, SysUtils;

type
  TDZipTools = class(TObject)
  public
    /// <summary>
    ///   UnZip
    /// </summary>
    class procedure UnZipStream(const pvInStream, pvOutStream: TStream);

    /// <summary>
    ///   Zip
    /// </summary>
    class procedure ZipStream(const pvInStream, pvOutStream: TStream);


    class function verifyData(const buf; len:Cardinal): Cardinal;
    class function verifyStream(pvStream:TStream; len:Cardinal): Cardinal;
  end;

implementation

class procedure TDZipTools.UnZipStream(const pvInStream, pvOutStream: TStream);
begin
  if pvInStream= nil then Exit;
  if pvInStream.Size = 0 then Exit;
  ZLib.ZDecompressStream(pvInStream, pvOutStream);
end;

class function TDZipTools.verifyData(const buf; len: Cardinal): Cardinal;
var
  i:Cardinal;
  p:PByte;
begin
  i := 0;
  Result := 0;
  p := PByte(@buf);
  while i < len do
  begin
    Result := Result + p^;
    Inc(p);
    Inc(i);
  end;
end;

class function TDZipTools.verifyStream(pvStream:TStream; len:Cardinal):
    Cardinal;
var
  l, j:Cardinal;
  lvBytes:TBytes;
begin
  SetLength(lvBytes, 1024);

  if len = 0 then
  begin
    j := pvStream.Size - pvStream.Position;
  end else
  begin
    j := len;
  end;

  Result := 0;

  while j > 0 do
  begin
    if j <1024 then l := j else l := 1024;

    pvStream.ReadBuffer(lvBytes[0], l);

    Result := Result + verifyData(lvBytes[0], l);
    Dec(j, l);
  end;
end;

class procedure TDZipTools.ZipStream(const pvInStream, pvOutStream: TStream);
begin
  ZLib.ZCompressStream(pvInStream, pvOutStream);
end;

end.
