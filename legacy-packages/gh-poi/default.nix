{ source
, buildGo121Module
,
}:
buildGo121Module {
  inherit (source) pname version src;
  vendorHash = "sha256-D/YZLwwGJWCekq9mpfCECzJyJ/xSlg7fC6leJh+e8i0=";
  doCheck = false;
}
