import argparse,json,re
p=argparse.ArgumentParser();p.add_argument('--kind',choices=['app','module','uvicorn'],default='app');p.add_argument('--name',required=True);p.add_argument('--app-dir',required=True);p.add_argument('--entry',required=True);a=p.parse_args()
if not re.fullmatch(r'[a-z0-9][a-z0-9-]*',a.name):raise SystemExit('name must be kebab-case')
call={'app':f'builder.AddPythonApp("{a.name}", "{a.app_dir}", "{a.entry}")','module':f'builder.AddPythonModule("{a.name}", "{a.app_dir}", "{a.entry}")','uvicorn':f'builder.AddUvicornApp("{a.name}", "{a.app_dir}", "{a.entry}")'}[a.kind]
print(json.dumps({'schema':'pmcro.aspire-python-plan/v1','package':'Aspire.Hosting.Python','kind':a.kind,'snippet':call+';','mutation':False},indent=2))
